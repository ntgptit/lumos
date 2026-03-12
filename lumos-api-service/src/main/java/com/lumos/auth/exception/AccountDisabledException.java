package com.lumos.auth.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class AccountDisabledException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public AccountDisabledException() {
        super(ErrorMessageKeys.AUTH_ACCOUNT_DISABLED);
    }
}
