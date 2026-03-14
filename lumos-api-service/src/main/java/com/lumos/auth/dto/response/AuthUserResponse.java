package com.lumos.auth.dto.response;

public record AuthUserResponse(
        Long id,
        String username,
        String email,
        String accountStatus) {
}
