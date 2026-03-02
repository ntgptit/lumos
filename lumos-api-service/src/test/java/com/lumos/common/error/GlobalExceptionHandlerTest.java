package com.lumos.common.error;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

import java.lang.reflect.Method;
import java.util.Locale;
import java.util.Set;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.core.MethodParameter;

import com.lumos.deck.exception.DeckNameConflictException;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.exception.DeckParentHasSubfoldersException;
import com.lumos.folder.exception.FolderHasDecksConflictException;
import com.lumos.folder.exception.FolderNameConflictException;
import com.lumos.folder.exception.FolderNotFoundException;

import jakarta.validation.ConstraintViolationException;

@ExtendWith(MockitoExtension.class)
class GlobalExceptionHandlerTest {

    @Mock
    private MessageSource messageSource;

    @AfterEach
    void clearRequestContext() {
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void constructor_createsHandlerInstance() {
        final var handler = new GlobalExceptionHandler(this.messageSource);

        assertTrue(handler instanceof GlobalExceptionHandler);
    }

    @Test
    void handleFolderNotFound_returnsNotFoundResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders/10");

        final var response = handler.handleFolderNotFound(new FolderNotFoundException(10L), request);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertEquals("resolved:folder.not-found", response.getBody().message());
    }

    @Test
    void handleFolderNameConflict_returnsConflictResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders");

        final var response = handler.handleFolderNameConflict(new FolderNameConflictException("A"), request);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals("resolved:folder.name-conflict", response.getBody().message());
    }

    @Test
    void handleFolderHasDecksConflict_returnsConflictResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders");

        final var response = handler.handleFolderHasDecksConflict(new FolderHasDecksConflictException(1L), request);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals("resolved:folder.has-decks-conflict", response.getBody().message());
    }

    @Test
    void handleDeckNotFound_returnsNotFoundResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders/1/decks/2");

        final var response = handler.handleDeckNotFound(new DeckNotFoundException(2L), request);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertEquals("resolved:deck.not-found", response.getBody().message());
    }

    @Test
    void handleDeckNameConflict_returnsConflictResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders/1/decks");

        final var response = handler.handleDeckNameConflict(new DeckNameConflictException("A"), request);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals("resolved:deck.name-conflict", response.getBody().message());
    }

    @Test
    void handleDeckParentHasSubfolders_returnsConflictResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders/1/decks");

        final var response = handler.handleDeckParentHasSubfolders(new DeckParentHasSubfoldersException(1L), request);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals("resolved:deck.parent-has-subfolders", response.getBody().message());
    }

    @Test
    void handleValidation_returnsBadRequestWithFieldErrors() throws Exception {
        final var handler = handler();
        final var request = request("/api/v1/folders");
        final var bindingResult = new BeanPropertyBindingResult(new ValidationDummy(), "validationDummy");
        bindingResult.addError(new FieldError("validationDummy", "name", "{folder.name.required}"));
        bindingResult.addError(new FieldError("validationDummy", "description", " "));
        final Method method = ValidationDummy.class.getDeclaredMethod("setValue", String.class);
        final var methodParameter = new MethodParameter(method, 0);
        final var exception = new MethodArgumentNotValidException(methodParameter, bindingResult);

        final var response = handler.handleValidation(exception, request);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("resolved:app.validation.failed", response.getBody().message());
        assertEquals("resolved:folder.name.required", response.getBody().fieldErrors().get("name"));
        assertEquals("resolved:app.validation.failed", response.getBody().fieldErrors().get("description"));
    }

    @Test
    void handleConstraintViolation_returnsBadRequestResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders");
        final var exception = new ConstraintViolationException(Set.of());

        final var response = handler.handleConstraintViolation(exception, request);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("resolved:app.validation.failed", response.getBody().message());
    }

    @Test
    void handleUnhandledException_returnsInternalServerErrorResponse() {
        final var handler = handler();
        final var request = request("/api/v1/folders");

        final var response = handler.handleUnhandledException(new IllegalStateException("boom"), request);

        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertEquals("resolved:common.unexpected-error", response.getBody().message());
    }

    private GlobalExceptionHandler handler() {
        when(this.messageSource.getMessage(any(), any(), any(), any(Locale.class)))
                .thenAnswer(invocation -> "resolved:" + invocation.getArgument(0, String.class));
        return new GlobalExceptionHandler(this.messageSource);
    }

    private MockHttpServletRequest request(String uri) {
        final var request = new MockHttpServletRequest();
        request.setRequestURI(uri);
        request.addPreferredLocale(Locale.US);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
        return request;
    }

    private static final class ValidationDummy {
        @SuppressWarnings("unused")
        public void setValue(String value) {
        }
    }
}
