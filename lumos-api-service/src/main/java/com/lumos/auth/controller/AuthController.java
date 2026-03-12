package com.lumos.auth.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.auth.dto.request.LoginRequest;
import com.lumos.auth.dto.request.LogoutRequest;
import com.lumos.auth.dto.request.RefreshTokenRequest;
import com.lumos.auth.dto.request.RegisterRequest;
import com.lumos.auth.dto.response.AuthResponse;
import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.auth.service.AuthService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

/**
 * Authentication endpoints.
 */
@Validated
@RestController
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Authentication APIs")
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;

    /**
     * Register a new account and return the authenticated session payload.
     *
     * @param request registration payload
     * @return created auth session response
     */
    @Operation(summary = "Register account")
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        final AuthResponse response = this.authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Authenticate a user by username or email plus password.
     *
     * @param request login payload
     * @return authenticated session response
     */
    @Operation(summary = "Login")
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        final AuthResponse response = this.authService.login(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Rotate the refresh token and issue a fresh access token.
     *
     * @param request refresh payload
     * @return refreshed auth session response
     */
    @Operation(summary = "Refresh access token")
    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        final AuthResponse response = this.authService.refreshToken(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Revoke the active refresh token.
     *
     * @param request logout payload
     * @return empty response
     */
    @Operation(summary = "Logout")
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@Valid @RequestBody LogoutRequest request) {
        this.authService.logout(request);
        return ResponseEntity.noContent().build();
    }

    /**
     * Return the current authenticated user.
     *
     * @return current user response
     */
    @Operation(summary = "Get current user")
    @GetMapping("/me")
    public ResponseEntity<CurrentUserResponse> getCurrentUser() {
        final CurrentUserResponse response = this.authService.getCurrentUser();
        return ResponseEntity.ok(response);
    }
}
