package com.lumos.deck.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class DeckNotFoundException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public DeckNotFoundException(Long deckId) {
        super(ErrorMessageKeys.DECK_NOT_FOUND, deckId);
    }
}
