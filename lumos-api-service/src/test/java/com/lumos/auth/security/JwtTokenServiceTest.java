package com.lumos.auth.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

import com.lumos.auth.entity.UserAccount;

class JwtTokenServiceTest {

    @Test
    void generateAccessToken_andParseAccessToken_roundTripsClaims() {
        final JwtProperties properties = new JwtProperties();
        properties.setSecret("lumos-demo-secret-key-lumos-demo-secret-key");
        properties.setAccessTokenTtlSeconds(900L);
        properties.setRefreshTokenTtlSeconds(7200L);
        final JwtTokenService jwtTokenService = new JwtTokenService(properties);
        final UserAccount user = new UserAccount();
        user.setId(10L);
        user.setUsername("tester");

        final String accessToken = jwtTokenService.generateAccessToken(user);
        final JwtAccessTokenClaims claims = jwtTokenService.parseAccessToken(accessToken);

        assertTrue(accessToken.length() > 0);
        assertEquals(10L, claims.userId());
        assertEquals("tester", claims.username());
        assertEquals(900L, jwtTokenService.getAccessTokenTtlSeconds());
        assertEquals(7200L, jwtTokenService.getRefreshTokenTtlSeconds());
    }
}
