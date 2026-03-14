package com.lumos.auth.dto.response;

public record AuthResponse(
        AuthUserResponse user,
        String accessToken,
        String refreshToken,
        Long expiresIn,
        boolean authenticated) {
}
