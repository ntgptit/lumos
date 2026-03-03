package com.lumos.common.logging;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.IOException;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

class ExecutionLoggingAspectTest {

    private static final String REQUEST_METHOD_GET = "GET";
    private static final String REQUEST_METHOD_POST = "POST";
    private static final String REQUEST_URI_PING = "/api/v1/ping";
    private static final String REQUEST_URI_FOLDERS = "/api/v1/folders";
    private static final String REQUEST_QUERY_PAGE = "page=1";
    private static final String REQUEST_CONTENT_TYPE_JSON = "application/json";
    private static final String REQUEST_BODY_JSON = "{\"name\":\"Folder A\"}";
    private static final String RESPONSE_BODY_OK = "ok";
    private static final String RESPONSE_BODY_CREATED = "{\"id\":1}";

    private final ExecutionLoggingAspect filter = new ExecutionLoggingAspect();

    @Test
    void doFilter_forGetRequest_writesResponseBody() throws ServletException, IOException {
        final var request = new MockHttpServletRequest(REQUEST_METHOD_GET, REQUEST_URI_PING);
        final var response = new MockHttpServletResponse();
        final var chain = new MockFilterChain(new EchoBodyServlet(RESPONSE_BODY_OK));

        this.filter.doFilter(request, response, chain);

        assertEquals(RESPONSE_BODY_OK, response.getContentAsString());
    }

    @Test
    void doFilter_forPostRequest_withBodyAndQuery_writesResponseBody() throws ServletException, IOException {
        final var request = new MockHttpServletRequest(REQUEST_METHOD_POST, REQUEST_URI_FOLDERS);
        request.setQueryString(REQUEST_QUERY_PAGE);
        request.setContentType(REQUEST_CONTENT_TYPE_JSON);
        request.setContent(REQUEST_BODY_JSON.getBytes());
        final var response = new MockHttpServletResponse();
        final var chain = new MockFilterChain(new EchoBodyServlet(RESPONSE_BODY_CREATED));

        this.filter.doFilter(request, response, chain);

        assertEquals(RESPONSE_BODY_CREATED, response.getContentAsString());
    }

    private static final class EchoBodyServlet extends HttpServlet {

        private static final long serialVersionUID = 1L;
        private final String body;

        private EchoBodyServlet(String body) {
            this.body = body;
        }

        @Override
        protected void service(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            resp.getWriter().write(this.body);
        }
    }
}
