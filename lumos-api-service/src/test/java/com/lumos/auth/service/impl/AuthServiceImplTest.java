package com.lumos.auth.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.lumos.auth.dto.request.LoginRequest;
import com.lumos.auth.dto.request.LogoutRequest;
import com.lumos.auth.dto.request.RefreshTokenRequest;
import com.lumos.auth.dto.request.RegisterRequest;
import com.lumos.auth.entity.RefreshToken;
import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.enums.AccountStatus;
import com.lumos.auth.enums.RefreshTokenStatus;
import com.lumos.auth.exception.InvalidCredentialsException;
import com.lumos.auth.repository.RefreshTokenRepository;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.auth.security.JwtTokenService;

@ExtendWith(MockitoExtension.class)
class AuthServiceImplTest {

    @Mock
    private UserAccountRepository userAccountRepository;

    @Mock
    private RefreshTokenRepository refreshTokenRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtTokenService jwtTokenService;

    @Mock
    private AuthenticatedUserProvider authenticatedUserProvider;

    @InjectMocks
    private AuthServiceImpl authService;

    @Test
    void register_createsUserAndReturnsSession() {
        final RegisterRequest request = new RegisterRequest("Test.User", "USER@MAIL.COM", "password123");
        final UserAccount savedUser = user(10L, "test.user", "user@mail.com");
        when(this.userAccountRepository.existsByUsernameIgnoreCase("test.user")).thenReturn(false);
        when(this.userAccountRepository.existsByEmailIgnoreCase("user@mail.com")).thenReturn(false);
        when(this.passwordEncoder.encode("password123")).thenReturn("encoded-password");
        when(this.userAccountRepository.save(any(UserAccount.class))).thenReturn(savedUser);
        when(this.jwtTokenService.generateAccessToken(savedUser)).thenReturn("access-token");
        when(this.jwtTokenService.getAccessTokenTtlSeconds()).thenReturn(900L);
        when(this.jwtTokenService.getRefreshTokenTtlSeconds()).thenReturn(7200L);

        final var response = this.authService.register(request);

        assertEquals("test.user", response.user().username());
        assertEquals("user@mail.com", response.user().email());
        assertEquals("access-token", response.accessToken());
        final ArgumentCaptor<UserAccount> userCaptor = ArgumentCaptor.forClass(UserAccount.class);
        verify(this.userAccountRepository).save(userCaptor.capture());
        assertEquals("test.user", userCaptor.getValue().getUsername());
        assertEquals("user@mail.com", userCaptor.getValue().getEmail());
        assertEquals(AccountStatus.ACTIVE, userCaptor.getValue().getAccountStatus());
    }

    @Test
    void login_withInvalidPassword_throwsInvalidCredentialsException() {
        final UserAccount user = user(10L, "tester", "tester@mail.com");
        user.setPasswordHash("encoded");
        when(this.userAccountRepository.findActiveByIdentifier("tester"))
                .thenReturn(Optional.of(user));
        when(this.passwordEncoder.matches("wrong-password", "encoded")).thenReturn(false);

        assertThrows(
                InvalidCredentialsException.class,
                () -> this.authService.login(new LoginRequest("tester", "wrong-password")));
    }

    @Test
    void refreshToken_rotatesCurrentTokenAndReturnsNewSession() {
        final UserAccount user = user(10L, "tester", "tester@mail.com");
        final RefreshToken refreshToken = refreshToken(user, RefreshTokenStatus.ACTIVE, Instant.now().plusSeconds(60));
        when(this.refreshTokenRepository.findByTokenHashAndDeletedAtIsNull(any())).thenReturn(Optional.of(refreshToken));
        when(this.jwtTokenService.generateAccessToken(user)).thenReturn("access-token");
        when(this.jwtTokenService.getAccessTokenTtlSeconds()).thenReturn(900L);
        when(this.jwtTokenService.getRefreshTokenTtlSeconds()).thenReturn(7200L);

        final var response = this.authService.refreshToken(new RefreshTokenRequest("refresh-token"));

        assertEquals(RefreshTokenStatus.ROTATED, refreshToken.getTokenStatus());
        assertEquals("access-token", response.accessToken());
        verify(this.refreshTokenRepository).save(any(RefreshToken.class));
    }

    @Test
    void logout_revokesRefreshToken() {
        final UserAccount user = user(10L, "tester", "tester@mail.com");
        final RefreshToken refreshToken = refreshToken(user, RefreshTokenStatus.ACTIVE, Instant.now().plusSeconds(60));
        when(this.refreshTokenRepository.findByTokenHashAndDeletedAtIsNull(any())).thenReturn(Optional.of(refreshToken));

        this.authService.logout(new LogoutRequest("refresh-token"));

        assertEquals(RefreshTokenStatus.REVOKED, refreshToken.getTokenStatus());
    }

    @Test
    void getCurrentUser_returnsCurrentUserResponse() {
        final UserAccount user = user(10L, "tester", "tester@mail.com");
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(10L);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(user));

        final var response = this.authService.getCurrentUser();

        assertEquals(10L, response.id());
        assertEquals("tester", response.username());
    }

    private UserAccount user(Long id, String username, String email) {
        final UserAccount user = new UserAccount();
        user.setId(id);
        user.setUsername(username);
        user.setEmail(email);
        user.setAccountStatus(AccountStatus.ACTIVE);
        
        return user;
    }

    private RefreshToken refreshToken(UserAccount user, RefreshTokenStatus status, Instant expiresAt) {
        final RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUserAccount(user);
        refreshToken.setTokenHash("hash");
        refreshToken.setTokenStatus(status);
        refreshToken.setExpiresAt(expiresAt);
        
        return refreshToken;
    }
}
