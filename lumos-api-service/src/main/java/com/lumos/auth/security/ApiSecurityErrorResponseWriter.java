package com.lumos.auth.security;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lumos.common.error.ApiErrorResponse;
import com.lumos.common.error.ApiErrorResponseFactory;
import com.lumos.common.error.ErrorMessageKeys;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ApiSecurityErrorResponseWriter {

    private final ApiErrorResponseFactory apiErrorResponseFactory;
    private final ObjectMapper objectMapper;

    public void writeUnauthorized(HttpServletRequest request, HttpServletResponse response) throws IOException {
        writeErrorResponse(
                request,
                response,
                HttpStatus.UNAUTHORIZED,
                ErrorMessageKeys.AUTH_UNAUTHORIZED);
    }

    public void writeForbidden(
            HttpServletRequest request,
            HttpServletResponse response,
            String messageKey) throws IOException {
        writeErrorResponse(
                request,
                response,
                HttpStatus.FORBIDDEN,
                messageKey);
    }

    private void writeErrorResponse(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpStatus status,
            String messageKey) throws IOException {
        // Stop immediately when another layer has already produced the HTTP response.
        if (response.isCommitted()) {
            // Return immediately because the response body can no longer be changed safely.
            return;
        }

        final ApiErrorResponse body = this.apiErrorResponseFactory.build(
                status,
                this.apiErrorResponseFactory.resolveMessage(messageKey),
                request.getRequestURI(),
                Map.of())
                .getBody();

        // Keep the HTTP status aligned with the serialized API error payload.
        response.setStatus(status.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        // Stop immediately when the error factory did not produce a body payload.
        if (body == null) {
            response.flushBuffer();
            // Return immediately because there is no payload left to serialize into the response body.
            return;
        }

        this.objectMapper.writeValue(response.getOutputStream(), body);
        response.flushBuffer();
    }
}
