package com.lumos.deck.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class DeckImportPayloadTooLargeException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public DeckImportPayloadTooLargeException(Integer maxFileSizeMb) {
        super(ErrorMessageKeys.DECK_IMPORT_FILE_TOO_LARGE, maxFileSizeMb);
    }
}
