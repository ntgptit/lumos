package com.lumos.auth.dto.response;

public record CurrentUserResponse(
        Long id,
        String username,
        String email,
        String accountStatus) {
}
