package com.lumos.common.logging;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.concurrent.TimeUnit;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * HTTP request/response logging filter with boxed output format.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class ExecutionLoggingAspect extends OncePerRequestFilter {

    private static final Logger LOG = LoggerFactory.getLogger(ExecutionLoggingAspect.class);

    private static final int BOX_WIDTH = 80;
    private static final int MAX_BODY_LOG_BYTES = 4096;
    private static final int REQUEST_CACHE_LIMIT_BYTES = MAX_BODY_LOG_BYTES;
    private static final String ELLIPSIS = "... [truncated]";

    private static final String TOP_LEFT = "╔";
    private static final String PIPE = "║";
    private static final String BOTTOM_LEFT = "╚";
    private static final String DIVIDER_LEFT = "╠";
    private static final String CORNER_BADGE = "╣";
    private static final String H_LINE = "═";
    private static final String DIVIDER_END = "╣";
    private static final String BOTTOM_RIGHT = "╝";
    private static final String EMPTY_LINE = "\n";

    private static final String BOTTOM_LINE = BOTTOM_LEFT + H_LINE.repeat(BOX_WIDTH) + BOTTOM_RIGHT;
    private static final String DIVIDER_LINE = DIVIDER_LEFT + H_LINE.repeat(BOX_WIDTH) + DIVIDER_END;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        final var wrappedRequest = new ContentCachingRequestWrapper(request, REQUEST_CACHE_LIMIT_BYTES);
        final var wrappedResponse = new ContentCachingResponseWrapper(response);
        final var startNs = System.nanoTime();

        try {
            filterChain.doFilter(wrappedRequest, wrappedResponse);
        } finally {
            final var durationMs = TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - startNs);
            this.logRequest(wrappedRequest);
            this.logResponse(wrappedRequest, wrappedResponse, durationMs);
            wrappedResponse.copyBodyToResponse();
        }
    }

    private void logRequest(ContentCachingRequestWrapper request) {
        // Skip request log when debug logging is disabled.
        if (!LOG.isDebugEnabled()) {
            return;
        }

        final var method = request.getMethod();
        final var uri = this.buildUri(request);
        final var body = this.readBody(request.getContentAsByteArray());
        final var builder = new StringBuilder(EMPTY_LINE);

        builder.append(this.boxTop(this.badge("Request") + " ║ " + method + " ║ " + uri)).append(EMPTY_LINE);
        this.appendHeaderLine(builder, "Content-Type", request.getContentType());
        this.appendHeaderLine(builder, "Accept", request.getHeader("Accept"));
        this.appendHeaderLine(builder, "TraceId", request.getHeader("X-Trace-Id"));

        // Append request body block only when payload exists.
        if (StringUtils.isNotBlank(body)) {
            builder.append(DIVIDER_LINE).append(EMPTY_LINE);
            builder.append(PIPE).append("  Body").append(EMPTY_LINE);
            builder.append(PIPE).append(EMPTY_LINE);
            for (String line : body.split(EMPTY_LINE)) {
                builder.append(PIPE).append("  ").append(line).append(EMPTY_LINE);
            }
            builder.append(PIPE).append(EMPTY_LINE);
        }

        builder.append(BOTTOM_LINE);
        LOG.debug("{}", builder);
    }

    private void logResponse(ContentCachingRequestWrapper request, ContentCachingResponseWrapper response, long durationMs) {
        final var method = request.getMethod();
        final var status = response.getStatus();
        final var url = this.buildFullUrl(request);
        final var body = this.readBody(response.getContentAsByteArray());
        final var builder = new StringBuilder(EMPTY_LINE);

        builder.append(this.boxTop(this.badge("Response") + " ║ " + method + " ║ Status: " + status + "   ║ Time: "
                + durationMs + " ms")).append(EMPTY_LINE);
        builder.append(PIPE).append("  ").append(url).append(EMPTY_LINE);
        builder.append(BOTTOM_LINE).append(EMPTY_LINE);
        builder.append(this.boxTop("Body")).append(EMPTY_LINE);
        builder.append(PIPE).append(EMPTY_LINE);

        // Append response body lines only when payload exists.
        if (StringUtils.isNotBlank(body)) {
            for (String line : body.split(EMPTY_LINE)) {
                builder.append(PIPE).append("    ").append(line).append(EMPTY_LINE);
            }
        }

        builder.append(PIPE).append(EMPTY_LINE);
        builder.append(BOTTOM_LINE);

        // Route 5xx responses to error level.
        if (status >= 500) {
            LOG.error("{}", builder);
            return;
        }
        // Route 4xx responses to warn level.
        if (status >= 400) {
            LOG.warn("{}", builder);
            return;
        }
        LOG.info("{}", builder);
    }

    private String boxTop(String content) {
        return TOP_LEFT + CORNER_BADGE + " " + content;
    }

    private String badge(String label) {
        return label;
    }

    private void appendHeaderLine(StringBuilder builder, String key, String value) {
        // Skip empty header values.
        if (StringUtils.isBlank(value)) {
            return;
        }
        builder.append(PIPE).append("  ").append(key).append(": ").append(value).append(EMPTY_LINE);
    }

    private String buildUri(HttpServletRequest request) {
        final var queryString = request.getQueryString();
        // Return URI only when query string is absent.
        if (StringUtils.isBlank(queryString)) {
            return request.getRequestURI();
        }
        return request.getRequestURI() + "?" + queryString;
    }

    private String buildFullUrl(HttpServletRequest request) {
        final var url = request.getRequestURL();
        final var queryString = request.getQueryString();
        // Append query string when request contains parameters.
        if (StringUtils.isNotBlank(queryString)) {
            url.append("?").append(queryString);
        }
        return url.toString();
    }

    private String readBody(byte[] bodyBytes) {
        // Return empty body when byte array is null or empty.
        if (bodyBytes == null || bodyBytes.length == 0) {
            return StringUtils.EMPTY;
        }

        final var shouldTruncate = bodyBytes.length > MAX_BODY_LOG_BYTES;
        final byte[] slice = shouldTruncate ? Arrays.copyOf(bodyBytes, MAX_BODY_LOG_BYTES) : bodyBytes;
        final var body = StringUtils.trim(new String(slice, StandardCharsets.UTF_8));

        // Append truncation marker when payload exceeds log limit.
        if (shouldTruncate) {
            return body + EMPTY_LINE + ELLIPSIS;
        }
        return body;
    }
}
