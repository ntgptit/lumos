package com.lumos.common.error;

import java.time.Instant;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Strings;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.validation.FieldError;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ApiErrorResponseFactory {

    private final MessageSource messageSource;

    public ResponseEntity<ApiErrorResponse> build(
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

    public String resolveFieldValidationMessage(FieldError fieldError) {
        final String defaultMessage = fieldError.getDefaultMessage();
        if (StringUtils.isBlank(defaultMessage)) {
            return resolveMessage(ErrorMessageKeys.APP_VALIDATION_FAILED);
        }
        return resolveMessage(normalizeMessageKey(defaultMessage));
    }

    public String resolveMessage(String messageKey, Object... args) {
        return this.messageSource.getMessage(messageKey, args, messageKey, resolveLocale());
    }

    private String normalizeMessageKey(String rawValue) {
        if (!Strings.CS.startsWith(rawValue, "{") || !Strings.CS.endsWith(rawValue, "}")) {
            return rawValue;
        }
        return rawValue.substring(1, rawValue.length() - 1);
    }

    private Locale resolveLocale() {
        final var attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return Locale.getDefault();
        }
        final var requestLocale = attributes.getRequest().getLocale();
        return Objects.requireNonNullElse(requestLocale, Locale.getDefault());
    }
}
