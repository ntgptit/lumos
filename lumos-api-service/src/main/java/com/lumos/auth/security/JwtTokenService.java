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

    private static final String USERNAME_CLAIM = "username";

    private final JwtProperties jwtProperties;

    public String generateAccessToken(UserAccount userAccount) {
        final Instant now = Instant.now();
        final Instant expiresAt = now.plusSeconds(this.jwtProperties.getAccessTokenTtlSeconds());
        return Jwts.builder()
                .subject(String.valueOf(userAccount.getId()))
                .claim(USERNAME_CLAIM, userAccount.getUsername())
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
        return new JwtAccessTokenClaims(
                Long.valueOf(claims.getSubject()),
                claims.get(USERNAME_CLAIM, String.class));
    }

    public long getAccessTokenTtlSeconds() {
        return this.jwtProperties.getAccessTokenTtlSeconds();
    }

    public long getRefreshTokenTtlSeconds() {
        return this.jwtProperties.getRefreshTokenTtlSeconds();
    }

    private SecretKey resolveSigningKey() {
        return Keys.hmacShaKeyFor(this.jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8));
    }
}
