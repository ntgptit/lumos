package com.lumos.auth.dto.request;

import com.lumos.auth.constant.AuthConstants;
import com.lumos.auth.constant.ValidationMessageKeys;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @NotBlank(message = ValidationMessageKeys.USERNAME_REQUIRED)
        @Size(max = AuthConstants.USERNAME_MAX_LENGTH, message = ValidationMessageKeys.USERNAME_MAX_LENGTH)
        @Pattern(regexp = AuthConstants.USERNAME_PATTERN, message = ValidationMessageKeys.USERNAME_PATTERN)
        String username,
        @NotBlank(message = ValidationMessageKeys.EMAIL_REQUIRED)
        @Email(message = ValidationMessageKeys.EMAIL_INVALID)
        @Size(max = AuthConstants.EMAIL_MAX_LENGTH, message = ValidationMessageKeys.EMAIL_INVALID)
        String email,
        @NotBlank(message = ValidationMessageKeys.PASSWORD_REQUIRED)
        @Size(min = AuthConstants.PASSWORD_MIN_LENGTH, message = ValidationMessageKeys.PASSWORD_MIN_LENGTH)
        @Size(max = AuthConstants.PASSWORD_MAX_LENGTH, message = ValidationMessageKeys.PASSWORD_MAX_LENGTH)
        String password) {
}
