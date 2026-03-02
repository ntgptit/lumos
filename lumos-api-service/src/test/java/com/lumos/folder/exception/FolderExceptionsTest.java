package com.lumos.folder.exception;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.lumos.common.error.ErrorMessageKeys;

class FolderExceptionsTest {

    @Test
    void folderHasDecksConflictException_setsMessageKeyAndArgs() {
        final var exception = new FolderHasDecksConflictException(10L);

        assertEquals(ErrorMessageKeys.FOLDER_HAS_DECKS_CONFLICT, exception.getMessageKey());
        assertArrayEquals(new Object[] { 10L }, exception.getMessageArgs());
    }

    @Test
    void folderNameConflictException_setsMessageKeyAndArgs() {
        final var exception = new FolderNameConflictException("Folder A");

        assertEquals(ErrorMessageKeys.FOLDER_NAME_CONFLICT, exception.getMessageKey());
        assertArrayEquals(new Object[] { "Folder A" }, exception.getMessageArgs());
    }

    @Test
    void folderNotFoundException_setsMessageKeyAndArgs() {
        final var exception = new FolderNotFoundException(22L);

        assertEquals(ErrorMessageKeys.FOLDER_NOT_FOUND, exception.getMessageKey());
        assertArrayEquals(new Object[] { 22L }, exception.getMessageArgs());
    }
}
