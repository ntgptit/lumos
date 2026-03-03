package com.lumos.flashcard.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class FlashcardNotFoundException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public FlashcardNotFoundException(Long flashcardId) {
        super(ErrorMessageKeys.FLASHCARD_NOT_FOUND, flashcardId);
    }
}
