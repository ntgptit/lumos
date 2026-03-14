package com.lumos.auth.constant;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ValidationMessageKeys {

    public static final String USERNAME_REQUIRED = "{auth.username.required}";
    public static final String USERNAME_MAX_LENGTH = "{auth.username.max-length}";
    public static final String USERNAME_PATTERN = "{auth.username.pattern}";
    public static final String EMAIL_REQUIRED = "{auth.email.required}";
    public static final String EMAIL_INVALID = "{auth.email.invalid}";
    public static final String PASSWORD_REQUIRED = "{auth.password.required}";
    public static final String PASSWORD_MIN_LENGTH = "{auth.password.min-length}";
    public static final String PASSWORD_MAX_LENGTH = "{auth.password.max-length}";
    public static final String IDENTIFIER_REQUIRED = "{auth.identifier.required}";
}
