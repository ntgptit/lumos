package com.lumos.common.error;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class BaseApiExceptionTest {

    @Test
    void getMessageKey_returnsAssignedKey() {
        final var exception = new TestApiException("test.key", "arg-1", 2L);

        assertEquals("test.key", exception.getMessageKey());
    }

    @Test
    void getMessageArgs_returnsAssignedArguments() {
        final var exception = new TestApiException("test.key", "arg-1", 2L);

        assertArrayEquals(new Object[] { "arg-1", 2L }, exception.getMessageArgs());
    }

    private static final class TestApiException extends BaseApiException {

        private static final long serialVersionUID = 1L;

        private TestApiException(String messageKey, Object... messageArgs) {
            super(messageKey, messageArgs);
        }
    }
}
