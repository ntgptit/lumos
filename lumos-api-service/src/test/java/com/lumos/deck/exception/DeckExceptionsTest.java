package com.lumos.deck.exception;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.lumos.common.error.ErrorMessageKeys;

class DeckExceptionsTest {

    @Test
    void deckNameConflictException_setsMessageKeyAndArgs() {
        final var exception = new DeckNameConflictException("Deck A");

        assertEquals(ErrorMessageKeys.DECK_NAME_CONFLICT, exception.getMessageKey());
        assertArrayEquals(new Object[] { "Deck A" }, exception.getMessageArgs());
    }

    @Test
    void deckNotFoundException_setsMessageKeyAndArgs() {
        final var exception = new DeckNotFoundException(10L);

        assertEquals(ErrorMessageKeys.DECK_NOT_FOUND, exception.getMessageKey());
        assertArrayEquals(new Object[] { 10L }, exception.getMessageArgs());
    }

    @Test
    void deckParentHasSubfoldersException_setsMessageKeyAndArgs() {
        final var exception = new DeckParentHasSubfoldersException(20L);

        assertEquals(ErrorMessageKeys.DECK_PARENT_HAS_SUBFOLDERS, exception.getMessageKey());
        assertArrayEquals(new Object[] { 20L }, exception.getMessageArgs());
    }

    @Test
    void deckImportFileInvalidException_setsMessageKeyAndArgs() {
        final var exception = new DeckImportFileInvalidException(
                ErrorMessageKeys.DECK_IMPORT_FILE_EMPTY,
                2);

        assertEquals(ErrorMessageKeys.DECK_IMPORT_FILE_EMPTY, exception.getMessageKey());
        assertArrayEquals(new Object[] { 2 }, exception.getMessageArgs());
    }

    @Test
    void deckImportPayloadTooLargeException_setsMessageKeyAndArgs() {
        final var exception = new DeckImportPayloadTooLargeException(50);

        assertEquals(ErrorMessageKeys.DECK_IMPORT_FILE_TOO_LARGE, exception.getMessageKey());
        assertArrayEquals(new Object[] { 50 }, exception.getMessageArgs());
    }
}
