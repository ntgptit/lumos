package com.lumos.auth.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.dto.request.LoginRequest;
import com.lumos.auth.dto.request.LogoutRequest;
import com.lumos.auth.dto.request.RefreshTokenRequest;
import com.lumos.auth.dto.request.RegisterRequest;
import com.lumos.auth.dto.response.AuthResponse;
import com.lumos.auth.dto.response.AuthUserResponse;
import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.auth.service.AuthService;

@ExtendWith(MockitoExtension.class)
class AuthControllerTest {

    @Mock
    private AuthService authService;

    @InjectMocks
    private AuthController authController;

    @Test
    void register_returnsCreated() {
        final RegisterRequest request = new RegisterRequest("tester", "tester@mail.com", "password123");
        final AuthResponse response = authResponse();
        when(this.authService.register(request)).thenReturn(response);

        final var entity = this.authController.register(request);

        assertEquals(201, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void login_returnsOk() {
        final LoginRequest request = new LoginRequest("tester", "password123");
        final AuthResponse response = authResponse();
        when(this.authService.login(request)).thenReturn(response);

        final var entity = this.authController.login(request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void refreshToken_returnsOk() {
        final RefreshTokenRequest request = new RefreshTokenRequest("refresh-token");
        final AuthResponse response = authResponse();
        when(this.authService.refreshToken(request)).thenReturn(response);

        final var entity = this.authController.refreshToken(request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void logout_returnsNoContent() {
        final LogoutRequest request = new LogoutRequest("refresh-token");

        final var entity = this.authController.logout(request);

        verify(this.authService).logout(request);
        assertEquals(204, entity.getStatusCode().value());
        assertNull(entity.getBody());
    }

    @Test
    void getCurrentUser_returnsOk() {
        final CurrentUserResponse response = new CurrentUserResponse(10L, "tester", "tester@mail.com", "ACTIVE");
        when(this.authService.getCurrentUser()).thenReturn(response);

        final var entity = this.authController.getCurrentUser();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    private AuthResponse authResponse() {
        return new AuthResponse(
                new AuthUserResponse(10L, "tester", "tester@mail.com", "ACTIVE"),
                "access-token",
                "refresh-token",
                900L,
                true);
    }
}
