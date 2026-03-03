package com.lumos.flashcard.exception;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.lumos.common.error.ErrorMessageKeys;

class FlashcardExceptionsTest {

    @Test
    void flashcardNotFoundException_setsMessageKeyAndArgs() {
        final var exception = new FlashcardNotFoundException(10L);

        assertEquals(ErrorMessageKeys.FLASHCARD_NOT_FOUND, exception.getMessageKey());
        assertArrayEquals(new Object[] { 10L }, exception.getMessageArgs());
    }
}
