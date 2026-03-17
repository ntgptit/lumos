package com.lumos.deck.exception;

import com.lumos.common.error.BaseApiException;

public class DeckImportFileInvalidException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public DeckImportFileInvalidException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
    }
}
