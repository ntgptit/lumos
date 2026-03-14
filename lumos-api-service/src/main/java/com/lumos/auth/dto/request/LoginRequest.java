package com.lumos.auth.dto.request;

import com.lumos.auth.constant.AuthConstants;
import com.lumos.auth.constant.ValidationMessageKeys;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record LoginRequest(
        @NotBlank(message = ValidationMessageKeys.IDENTIFIER_REQUIRED)
        String identifier,
        @NotBlank(message = ValidationMessageKeys.PASSWORD_REQUIRED)
        @Size(min = AuthConstants.PASSWORD_MIN_LENGTH, message = ValidationMessageKeys.PASSWORD_MIN_LENGTH)
        @Size(max = AuthConstants.PASSWORD_MAX_LENGTH, message = ValidationMessageKeys.PASSWORD_MAX_LENGTH)
        String password) {
}
