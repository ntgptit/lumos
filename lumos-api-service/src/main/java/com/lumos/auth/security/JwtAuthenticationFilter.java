package com.lumos.auth.security;

import java.io.IOException;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.enums.AccountStatus;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.common.error.ErrorMessageKeys;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtTokenService jwtTokenService;
    private final UserAccountRepository userAccountRepository;
    private final ApiSecurityErrorResponseWriter apiSecurityErrorResponseWriter;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        final String token = resolveAccessToken(request);
        // Skip authentication when the request does not carry a usable bearer token.
        if (StringUtils.isEmpty(StringUtils.strip(token))) {
            filterChain.doFilter(request, response);
            // Return without mutating the security context for unauthenticated requests.
            return;
        }
        try {
            final JwtAccessTokenClaims claims = this.jwtTokenService.parseAccessToken(token);
            final UserAccount userAccount = this.userAccountRepository
                    .findByIdAndDeletedAtIsNull(claims.userId())
                    .orElse(null);
            // Reject the token when the referenced account no longer exists.
            if (userAccount == null) {
                SecurityContextHolder.clearContext();
                this.apiSecurityErrorResponseWriter.writeUnauthorized(request, response);
                // Return immediately because deleted accounts must not keep using stale tokens.
                return;
            }
            // Reject the token when the account is no longer allowed to sign in.
            if (userAccount.getAccountStatus() != AccountStatus.ACTIVE) {
                SecurityContextHolder.clearContext();
                this.apiSecurityErrorResponseWriter.writeForbidden(
                        request,
                        response,
                        ErrorMessageKeys.AUTH_ACCOUNT_DISABLED);
                // Return immediately because inactive accounts must not regain access.
                return;
            }
            final AuthUserPrincipal principal = new AuthUserPrincipal(userAccount.getId(), userAccount.getUsername());
            final UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    principal,
                    token,
                    AuthorityUtils.NO_AUTHORITIES);
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (JwtException | IllegalArgumentException exception) {
            SecurityContextHolder.clearContext();
            this.apiSecurityErrorResponseWriter.writeUnauthorized(request, response);
            // Return immediately because expired and malformed access tokens must stop at the security boundary.
            return;
        }
        filterChain.doFilter(request, response);
    }

    private String resolveAccessToken(HttpServletRequest request) {
        final String rawAuthorization = request.getHeader(AUTHORIZATION_HEADER);
        final String token = StringUtils.substringAfter(rawAuthorization, BEARER_PREFIX);
        // Ignore authorization headers that do not contain a bearer token payload.
        if (StringUtils.isEmpty(StringUtils.strip(token))) {
            // Return null so the filter treats the request as unauthenticated.
            return null;
        }
        // Return the raw bearer token so downstream JWT parsing can validate it.
        return token;
    }
}
