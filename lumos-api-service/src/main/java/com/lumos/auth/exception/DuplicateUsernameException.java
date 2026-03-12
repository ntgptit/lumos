package com.lumos.auth.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class DuplicateUsernameException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public DuplicateUsernameException() {
        super(ErrorMessageKeys.AUTH_DUPLICATE_USERNAME);
    }
}
