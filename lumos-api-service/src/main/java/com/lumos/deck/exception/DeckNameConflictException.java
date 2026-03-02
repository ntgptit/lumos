package com.lumos.deck.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class DeckNameConflictException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public DeckNameConflictException(String deckName) {
        super(ErrorMessageKeys.DECK_NAME_CONFLICT, deckName);
    }
}
