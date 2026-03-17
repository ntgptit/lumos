package com.lumos.common.error;

import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import com.lumos.auth.exception.AccountDisabledException;
import com.lumos.auth.exception.DuplicateEmailException;
import com.lumos.auth.exception.DuplicateUsernameException;
import com.lumos.auth.exception.InvalidCredentialsException;
import com.lumos.auth.exception.InvalidRefreshTokenException;
import com.lumos.auth.exception.UnauthorizedAccessException;
import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.exception.DeckImportFileInvalidException;
import com.lumos.deck.exception.DeckImportPayloadTooLargeException;
import com.lumos.deck.exception.DeckNameConflictException;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.exception.DeckParentHasSubfoldersException;
import com.lumos.flashcard.exception.FlashcardNotFoundException;
import com.lumos.folder.exception.FolderHasDecksConflictException;
import com.lumos.folder.exception.FolderNameConflictException;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.study.exception.StudyAnswerPayloadInvalidException;
import com.lumos.study.exception.StudyCommandNotAllowedException;
import com.lumos.study.exception.StudySessionNotFoundException;
import com.lumos.study.exception.StudySessionUnavailableException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private final ApiErrorResponseFactory apiErrorResponseFactory;

    public GlobalExceptionHandler(ApiErrorResponseFactory apiErrorResponseFactory) {
        this.apiErrorResponseFactory = apiErrorResponseFactory;
    }

    @ExceptionHandler(FolderNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleFolderNotFound(
            FolderNotFoundException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.NOT_FOUND, exception, request);
    }

    @ExceptionHandler(FolderNameConflictException.class)
    public ResponseEntity<ApiErrorResponse> handleFolderNameConflict(
            FolderNameConflictException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(FolderHasDecksConflictException.class)
    public ResponseEntity<ApiErrorResponse> handleFolderHasDecksConflict(
            FolderHasDecksConflictException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(DeckNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleDeckNotFound(
            DeckNotFoundException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.NOT_FOUND, exception, request);
    }

    @ExceptionHandler(DeckNameConflictException.class)
    public ResponseEntity<ApiErrorResponse> handleDeckNameConflict(
            DeckNameConflictException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(DeckParentHasSubfoldersException.class)
    public ResponseEntity<ApiErrorResponse> handleDeckParentHasSubfolders(
            DeckParentHasSubfoldersException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(DeckImportFileInvalidException.class)
    public ResponseEntity<ApiErrorResponse> handleDeckImportFileInvalid(
            DeckImportFileInvalidException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.BAD_REQUEST, exception, request);
    }

    @ExceptionHandler(DeckImportPayloadTooLargeException.class)
    public ResponseEntity<ApiErrorResponse> handleDeckImportPayloadTooLarge(
            DeckImportPayloadTooLargeException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.PAYLOAD_TOO_LARGE, exception, request);
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<ApiErrorResponse> handleMaxUploadSizeExceeded(
            MaxUploadSizeExceededException exception,
            HttpServletRequest request) {
        return this.apiErrorResponseFactory.build(
                HttpStatus.PAYLOAD_TOO_LARGE,
                this.apiErrorResponseFactory.resolveMessage(
                        ErrorMessageKeys.DECK_IMPORT_FILE_TOO_LARGE,
                        DeckImportConstants.MAX_FILE_SIZE_MB),
                request.getRequestURI(),
                Map.of());
    }

    @ExceptionHandler(FlashcardNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleFlashcardNotFound(
            FlashcardNotFoundException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.NOT_FOUND, exception, request);
    }

    @ExceptionHandler(DuplicateUsernameException.class)
    public ResponseEntity<ApiErrorResponse> handleDuplicateUsername(
            DuplicateUsernameException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(DuplicateEmailException.class)
    public ResponseEntity<ApiErrorResponse> handleDuplicateEmail(
            DuplicateEmailException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public ResponseEntity<ApiErrorResponse> handleInvalidCredentials(
            InvalidCredentialsException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.UNAUTHORIZED, exception, request);
    }

    @ExceptionHandler(InvalidRefreshTokenException.class)
    public ResponseEntity<ApiErrorResponse> handleInvalidRefreshToken(
            InvalidRefreshTokenException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.UNAUTHORIZED, exception, request);
    }

    @ExceptionHandler(UnauthorizedAccessException.class)
    public ResponseEntity<ApiErrorResponse> handleUnauthorizedAccess(
            UnauthorizedAccessException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.UNAUTHORIZED, exception, request);
    }

    @ExceptionHandler(AccountDisabledException.class)
    public ResponseEntity<ApiErrorResponse> handleAccountDisabled(
            AccountDisabledException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.FORBIDDEN, exception, request);
    }

    @ExceptionHandler(StudySessionNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleStudySessionNotFound(
            StudySessionNotFoundException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.NOT_FOUND, exception, request);
    }

    @ExceptionHandler(StudySessionUnavailableException.class)
    public ResponseEntity<ApiErrorResponse> handleStudySessionUnavailable(
            StudySessionUnavailableException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(StudyCommandNotAllowedException.class)
    public ResponseEntity<ApiErrorResponse> handleStudyCommandNotAllowed(
            StudyCommandNotAllowedException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.CONFLICT, exception, request);
    }

    @ExceptionHandler(StudyAnswerPayloadInvalidException.class)
    public ResponseEntity<ApiErrorResponse> handleStudyAnswerPayloadInvalid(
            StudyAnswerPayloadInvalidException exception,
            HttpServletRequest request) {
        return handleApiException(HttpStatus.BAD_REQUEST, exception, request);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidation(
            MethodArgumentNotValidException exception,
            HttpServletRequest request) {
        final Map<String, String> fieldErrors = new LinkedHashMap<>();
        // Preserve the original validation order so the client can map field messages predictably.
        for (final FieldError fieldError : exception.getBindingResult().getFieldErrors()) {
            final var resolvedFieldMessage = this.apiErrorResponseFactory.resolveFieldValidationMessage(fieldError);
            fieldErrors.put(fieldError.getField(), resolvedFieldMessage);
        }
        return this.apiErrorResponseFactory.build(
                HttpStatus.BAD_REQUEST,
                this.apiErrorResponseFactory.resolveMessage(ErrorMessageKeys.APP_VALIDATION_FAILED),
                request.getRequestURI(),
                fieldErrors);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiErrorResponse> handleConstraintViolation(
            ConstraintViolationException exception,
            HttpServletRequest request) {
        return this.apiErrorResponseFactory.build(
                HttpStatus.BAD_REQUEST,
                this.apiErrorResponseFactory.resolveMessage(ErrorMessageKeys.APP_VALIDATION_FAILED),
                request.getRequestURI(),
                Map.of());
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleNoResourceFound(
            NoResourceFoundException exception,
            HttpServletRequest request) {
        return this.apiErrorResponseFactory.build(
                HttpStatus.NOT_FOUND,
                this.apiErrorResponseFactory.resolveMessage(ErrorMessageKeys.COMMON_RESOURCE_NOT_FOUND),
                request.getRequestURI(),
                Map.of());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleUnhandledException(
            Exception exception,
            HttpServletRequest request) {
        return this.apiErrorResponseFactory.build(
                HttpStatus.INTERNAL_SERVER_ERROR,
                this.apiErrorResponseFactory.resolveMessage(ErrorMessageKeys.COMMON_UNEXPECTED_ERROR),
                request.getRequestURI(),
                Map.of());
    }

    private ResponseEntity<ApiErrorResponse> handleApiException(
            HttpStatus status,
            BaseApiException exception,
            HttpServletRequest request) {
        return this.apiErrorResponseFactory.build(
                status,
                this.apiErrorResponseFactory.resolveMessage(exception.getMessageKey(), exception.getMessageArgs()),
                request.getRequestURI(),
                Map.of());
    }
}
