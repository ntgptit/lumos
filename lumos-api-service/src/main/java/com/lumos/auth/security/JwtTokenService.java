package com.lumos.auth.security;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.stereotype.Service;

import com.lumos.auth.entity.UserAccount;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JwtTokenService {

    private static final String AUTHORITIES_CLAIM = "authorities";
    private static final String TOKEN_TYPE_ACCESS = "access";
    private static final String TOKEN_TYPE_CLAIM = "token_type";
    private static final String USERNAME_CLAIM = "username";

    private final JwtProperties jwtProperties;

    public String generateAccessToken(UserAccount userAccount) {
        final Instant now = Instant.now();
        final Instant expiresAt = now.plusSeconds(this.jwtProperties.getAccessTokenTtlSeconds());
        // Return a signed access token that carries the canonical auth claims for this user.
        return Jwts.builder()
                .subject(String.valueOf(userAccount.getId()))
                .claim(TOKEN_TYPE_CLAIM, TOKEN_TYPE_ACCESS)
                .claim(USERNAME_CLAIM, userAccount.getUsername())
                .claim(AUTHORITIES_CLAIM, java.util.List.of())
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiresAt))
                .signWith(resolveSigningKey())
                .compact();
    }

    public JwtAccessTokenClaims parseAccessToken(String accessToken) {
        final Claims claims = Jwts.parser()
                .verifyWith(resolveSigningKey())
                .build()
                .parseSignedClaims(accessToken)
                .getPayload();
        // Return the minimal claims object that downstream security code needs for authorization.
        return new JwtAccessTokenClaims(
                Long.valueOf(claims.getSubject()),
                claims.get(USERNAME_CLAIM, String.class));
    }

    public long getAccessTokenTtlSeconds() {
        // Return the configured access-token lifetime so clients can anticipate refresh timing.
        return this.jwtProperties.getAccessTokenTtlSeconds();
    }

    public long getRefreshSessionIdleTimeoutSeconds() {
        // Return the configured idle-timeout window used by refresh-session persistence decisions.
        return this.jwtProperties.getRefreshSessionIdleTimeoutSeconds();
    }

    private SecretKey resolveSigningKey() {
        // Return the HMAC signing key derived from the configured shared JWT secret.
        return Keys.hmacShaKeyFor(this.jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8));
    }
}
