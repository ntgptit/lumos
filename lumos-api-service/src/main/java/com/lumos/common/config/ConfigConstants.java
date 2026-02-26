package com.lumos.common.config;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ConfigConstants {

    public static final String CORS_PATH_PATTERN = "/**";
    public static final String CORS_PREFIX = "app.cors";
    public static final String AUTH_WHITELIST_PATH = "/**";
    public static final String ACTUATOR_PATH = "/actuator/**";
    public static final String I18N_PARAM_LANG = "lang";
    public static final String I18N_BASENAME = "messages";
    public static final String I18N_DEFAULT_LANGUAGE = "en";
    public static final String I18N_DEFAULT_COUNTRY = "US";
    public static final String I18N_ENCODING = "UTF-8";
}
