package com.lumos.common.error;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Strings;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.lumos.folder.exception.FolderNameConflictException;
import com.lumos.folder.exception.FolderNotFoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private final MessageSource messageSource;

    public GlobalExceptionHandler(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    @ExceptionHandler(FolderNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleFolderNotFound(
            FolderNotFoundException exception,
            HttpServletRequest request) {
        return buildErrorResponse(
                HttpStatus.NOT_FOUND,
                resolveMessage(exception.getMessageKey(), exception.getMessageArgs()),
                request.getRequestURI(),
                Map.of());
    }

    @ExceptionHandler(FolderNameConflictException.class)
    public ResponseEntity<ApiErrorResponse> handleFolderNameConflict(
            FolderNameConflictException exception,
            HttpServletRequest request) {
        return buildErrorResponse(
                HttpStatus.CONFLICT,
                resolveMessage(exception.getMessageKey(), exception.getMessageArgs()),
                request.getRequestURI(),
                Map.of());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidation(
            MethodArgumentNotValidException exception,
            HttpServletRequest request) {
        final Map<String, String> fieldErrors = new LinkedHashMap<>();
        for (final FieldError fieldError : exception.getBindingResult().getFieldErrors()) {
            final var resolvedFieldMessage = resolveFieldValidationMessage(fieldError);
            fieldErrors.put(fieldError.getField(), resolvedFieldMessage);
        }
        return buildErrorResponse(
                HttpStatus.BAD_REQUEST,
                resolveMessage(ErrorMessageKeys.APP_VALIDATION_FAILED),
                request.getRequestURI(),
                fieldErrors);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiErrorResponse> handleConstraintViolation(
            ConstraintViolationException exception,
            HttpServletRequest request) {
        return buildErrorResponse(
                HttpStatus.BAD_REQUEST,
                resolveMessage(ErrorMessageKeys.APP_VALIDATION_FAILED),
                request.getRequestURI(),
                Map.of());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleUnhandledException(
            Exception exception,
            HttpServletRequest request) {
        return buildErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR,
                resolveMessage(ErrorMessageKeys.COMMON_UNEXPECTED_ERROR),
                request.getRequestURI(),
                Map.of());
    }

    private ResponseEntity<ApiErrorResponse> buildErrorResponse(
            HttpStatus status,
            String message,
            String path,
            Map<String, String> fieldErrors) {
        final var response = new ApiErrorResponse(
                Instant.now(),
                status.value(),
                status.getReasonPhrase(),
                message,
                path,
                fieldErrors);
        return ResponseEntity.status(status).body(response);
    }

    private String resolveFieldValidationMessage(FieldError fieldError) {
        final String defaultMessage = fieldError.getDefaultMessage();
        // Fallback to generic validation message when field-level message is unavailable.
        if (StringUtils.isBlank(defaultMessage)) {
            return resolveMessage(ErrorMessageKeys.APP_VALIDATION_FAILED);
        }
        final var messageKey = normalizeMessageKey(defaultMessage);
        return resolveMessage(messageKey);
    }

    private String normalizeMessageKey(String rawValue) {
        // Keep raw value when it is not a placeholder-style message key.
        if (!Strings.CS.startsWith(rawValue, "{") || !Strings.CS.endsWith(rawValue, "}")) {
            return rawValue;
        }
        return rawValue.substring(1, rawValue.length() - 1);
    }

    private String resolveMessage(String messageKey, Object... args) {
        final var locale = resolveLocale();
        return this.messageSource.getMessage(messageKey, args, messageKey, locale);
    }

    private Locale resolveLocale() {
        final var attributes = (ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes();
        // Fallback to JVM locale if request context is not available.
        if (attributes == null) {
            return Locale.getDefault();
        }
        final var request = attributes.getRequest();
        final var requestLocale = request.getLocale();
        return Objects.requireNonNullElse(requestLocale, Locale.getDefault());
    }
}
