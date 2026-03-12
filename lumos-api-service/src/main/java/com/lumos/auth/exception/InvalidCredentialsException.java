package com.lumos.auth.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class InvalidCredentialsException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public InvalidCredentialsException() {
        super(ErrorMessageKeys.AUTH_INVALID_CREDENTIALS);
    }
}
