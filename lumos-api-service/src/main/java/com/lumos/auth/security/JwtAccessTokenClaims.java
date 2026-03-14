package com.lumos.auth.security;

public record JwtAccessTokenClaims(Long userId, String username) {
}
