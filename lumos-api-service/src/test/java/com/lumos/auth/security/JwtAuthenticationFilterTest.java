package com.lumos.auth.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.context.SecurityContextHolder;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.enums.AccountStatus;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.common.error.ErrorMessageKeys;

import jakarta.servlet.FilterChain;

@ExtendWith(MockitoExtension.class)
class JwtAuthenticationFilterTest {

    @Mock
    private JwtTokenService jwtTokenService;

    @Mock
    private UserAccountRepository userAccountRepository;

    @Mock
    private ApiSecurityErrorResponseWriter apiSecurityErrorResponseWriter;

    @Mock
    private FilterChain filterChain;

    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @BeforeEach
    void setUp() {
        this.jwtAuthenticationFilter = new JwtAuthenticationFilter(
                this.jwtTokenService,
                this.userAccountRepository,
                this.apiSecurityErrorResponseWriter);
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void doFilter_rejectsInvalidAccessTokenWithUnauthorizedResponse() throws Exception {
        final MockHttpServletRequest request = requestWithBearerToken("invalid-token");
        final MockHttpServletResponse response = new MockHttpServletResponse();
        when(this.jwtTokenService.parseAccessToken("invalid-token"))
                .thenThrow(new IllegalArgumentException("invalid-token"));

        this.jwtAuthenticationFilter.doFilter(request, response, this.filterChain);

        verify(this.apiSecurityErrorResponseWriter).writeUnauthorized(request, response);
        verify(this.filterChain, never()).doFilter(request, response);
        verifyNoInteractions(this.userAccountRepository);
    }

    @Test
    void doFilter_rejectsInactiveAccountWithForbiddenResponse() throws Exception {
        final MockHttpServletRequest request = requestWithBearerToken("inactive-token");
        final MockHttpServletResponse response = new MockHttpServletResponse();
        final JwtAccessTokenClaims claims = new JwtAccessTokenClaims(10L, "tester");
        final UserAccount userAccount = userAccount(AccountStatus.DISABLED);
        when(this.jwtTokenService.parseAccessToken("inactive-token")).thenReturn(claims);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(userAccount));

        this.jwtAuthenticationFilter.doFilter(request, response, this.filterChain);

        verify(this.apiSecurityErrorResponseWriter).writeForbidden(
                request,
                response,
                ErrorMessageKeys.AUTH_ACCOUNT_DISABLED);
        verify(this.filterChain, never()).doFilter(request, response);
    }

    @Test
    void doFilter_authenticatesActiveAccountAndContinuesFilterChain() throws Exception {
        final MockHttpServletRequest request = requestWithBearerToken("active-token");
        final MockHttpServletResponse response = new MockHttpServletResponse();
        final JwtAccessTokenClaims claims = new JwtAccessTokenClaims(10L, "tester");
        final UserAccount userAccount = userAccount(AccountStatus.ACTIVE);
        when(this.jwtTokenService.parseAccessToken("active-token")).thenReturn(claims);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(userAccount));

        this.jwtAuthenticationFilter.doFilter(request, response, this.filterChain);

        verify(this.filterChain).doFilter(request, response);
        verifyNoInteractions(this.apiSecurityErrorResponseWriter);
        assertEquals(10L, ((AuthUserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).userId());
    }

    private MockHttpServletRequest requestWithBearerToken(String token) {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer " + token);
        return request;
    }

    private UserAccount userAccount(AccountStatus accountStatus) {
        final UserAccount userAccount = new UserAccount();
        userAccount.setId(10L);
        userAccount.setUsername("tester");
        userAccount.setAccountStatus(accountStatus);
        return userAccount;
    }
}
