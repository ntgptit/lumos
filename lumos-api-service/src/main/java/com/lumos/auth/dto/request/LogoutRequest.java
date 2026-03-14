package com.lumos.auth.dto.request;

import com.lumos.auth.constant.ValidationMessageKeys;

import jakarta.validation.constraints.NotBlank;

public record LogoutRequest(
        @NotBlank(message = ValidationMessageKeys.IDENTIFIER_REQUIRED)
        String refreshToken) {
}
