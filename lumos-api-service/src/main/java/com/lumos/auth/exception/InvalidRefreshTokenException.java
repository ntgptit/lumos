package com.lumos.auth.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class InvalidRefreshTokenException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public InvalidRefreshTokenException() {
        super(ErrorMessageKeys.AUTH_INVALID_REFRESH_TOKEN);
    }
}
