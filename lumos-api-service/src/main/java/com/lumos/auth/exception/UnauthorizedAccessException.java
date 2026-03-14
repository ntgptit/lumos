package com.lumos.auth.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class UnauthorizedAccessException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public UnauthorizedAccessException() {
        super(ErrorMessageKeys.AUTH_UNAUTHORIZED);
    }
}
