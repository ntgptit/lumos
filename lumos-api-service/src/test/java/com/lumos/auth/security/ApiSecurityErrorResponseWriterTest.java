package com.lumos.auth.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import java.util.Locale;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lumos.common.error.ApiErrorResponse;
import com.lumos.common.error.ApiErrorResponseFactory;
import com.lumos.common.error.ErrorMessageKeys;

@ExtendWith(MockitoExtension.class)
class ApiSecurityErrorResponseWriterTest {

    @Mock
    private MessageSource messageSource;

    @AfterEach
    void tearDown() {
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void writeUnauthorized_serializesUnauthorizedApiErrorResponse() throws Exception {
        when(this.messageSource.getMessage(any(), any(), any(), any(Locale.class)))
                .thenAnswer(invocation -> "resolved:" + invocation.getArgument(0, String.class));
        final ApiSecurityErrorResponseWriter writer = writer();
        final MockHttpServletRequest request = request("/api/v1/study/sessions");
        final MockHttpServletResponse response = new MockHttpServletResponse();

        writer.writeUnauthorized(request, response);

        final ApiErrorResponse body = objectMapper().readValue(response.getContentAsByteArray(), ApiErrorResponse.class);
        assertEquals(HttpStatus.UNAUTHORIZED.value(), response.getStatus());
        assertEquals("resolved:" + ErrorMessageKeys.AUTH_UNAUTHORIZED, body.message());
        assertEquals("/api/v1/study/sessions", body.path());
    }

    @Test
    void writeForbidden_serializesForbiddenApiErrorResponse() throws Exception {
        when(this.messageSource.getMessage(any(), any(), any(), any(Locale.class)))
                .thenAnswer(invocation -> "resolved:" + invocation.getArgument(0, String.class));
        final ApiSecurityErrorResponseWriter writer = writer();
        final MockHttpServletRequest request = request("/api/v1/profile");
        final MockHttpServletResponse response = new MockHttpServletResponse();

        writer.writeForbidden(request, response, ErrorMessageKeys.AUTH_ACCOUNT_DISABLED);

        final ApiErrorResponse body = objectMapper().readValue(response.getContentAsByteArray(), ApiErrorResponse.class);
        assertEquals(HttpStatus.FORBIDDEN.value(), response.getStatus());
        assertEquals("resolved:" + ErrorMessageKeys.AUTH_ACCOUNT_DISABLED, body.message());
        assertEquals("/api/v1/profile", body.path());
    }

    private ApiSecurityErrorResponseWriter writer() {
        return new ApiSecurityErrorResponseWriter(
                new ApiErrorResponseFactory(this.messageSource),
                objectMapper());
    }

    private MockHttpServletRequest request(String uri) {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        request.setRequestURI(uri);
        request.addPreferredLocale(Locale.US);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
        return request;
    }

    private ObjectMapper objectMapper() {
        return new ObjectMapper().findAndRegisterModules();
    }
}
