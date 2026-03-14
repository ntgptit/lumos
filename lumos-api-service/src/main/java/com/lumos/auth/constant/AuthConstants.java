package com.lumos.auth.constant;

import lombok.experimental.UtilityClass;

@UtilityClass
public class AuthConstants {

    public static final int USERNAME_MAX_LENGTH = 40;
    public static final int EMAIL_MAX_LENGTH = 120;
    public static final int PASSWORD_MIN_LENGTH = 8;
    public static final int PASSWORD_MAX_LENGTH = 120;
    public static final int TOKEN_HASH_LENGTH = 128;
    public static final int DEVICE_LABEL_MAX_LENGTH = 120;
    public static final String USERNAME_PATTERN = "^[a-z0-9._]+$";
}
