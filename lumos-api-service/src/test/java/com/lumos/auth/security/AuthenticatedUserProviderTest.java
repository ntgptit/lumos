package com.lumos.auth.security;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;

class AuthenticatedUserProviderTest {

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void getCurrentUserId_readsPrincipalFromSecurityContext() {
        final AuthenticatedUserProvider provider = new AuthenticatedUserProvider();
        final AuthUserPrincipal principal = new AuthUserPrincipal(20L, "tester");
        final UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                principal,
                null,
                AuthorityUtils.NO_AUTHORITIES);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        final Long userId = provider.getCurrentUserId();

        assertEquals(20L, userId);
    }
}
