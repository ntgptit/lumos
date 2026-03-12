package com.lumos.auth.service.impl;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.HexFormat;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.dto.request.LoginRequest;
import com.lumos.auth.dto.request.LogoutRequest;
import com.lumos.auth.dto.request.RefreshTokenRequest;
import com.lumos.auth.dto.request.RegisterRequest;
import com.lumos.auth.dto.response.AuthResponse;
import com.lumos.auth.dto.response.AuthUserResponse;
import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.auth.entity.RefreshToken;
import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.enums.AccountStatus;
import com.lumos.auth.enums.RefreshTokenStatus;
import com.lumos.auth.exception.AccountDisabledException;
import com.lumos.auth.exception.DuplicateEmailException;
import com.lumos.auth.exception.DuplicateUsernameException;
import com.lumos.auth.exception.InvalidCredentialsException;
import com.lumos.auth.exception.InvalidRefreshTokenException;
import com.lumos.auth.exception.UnauthorizedAccessException;
import com.lumos.auth.repository.RefreshTokenRepository;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.auth.security.JwtTokenService;
import com.lumos.auth.service.AuthService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private static final String HASH_ALGORITHM = "SHA-256";

    private final UserAccountRepository userAccountRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenService jwtTokenService;
    private final AuthenticatedUserProvider authenticatedUserProvider;

    /**
     * Register a new account and issue the initial authenticated session.
     *
     * @param request registration payload
     * @return authenticated session response
     */
    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        final String normalizedUsername = normalizeUsername(request.username());
        final String normalizedEmail = normalizeEmail(request.email());
        validateUniqueness(normalizedUsername, normalizedEmail);
        final UserAccount userAccount = new UserAccount();
        userAccount.setUsername(normalizedUsername);
        userAccount.setEmail(normalizedEmail);
        userAccount.setPasswordHash(this.passwordEncoder.encode(request.password()));
        userAccount.setAccountStatus(AccountStatus.ACTIVE);
        final UserAccount savedUserAccount = this.userAccountRepository.save(userAccount);
        return issueAuthResponse(savedUserAccount);
    }

    /**
     * Authenticate a user by username or email plus password.
     *
     * @param request login payload
     * @return authenticated session response
     */
    @Override
    @Transactional
    public AuthResponse login(LoginRequest request) {
        final String normalizedIdentifier = StringUtils.strip(request.identifier());
        final UserAccount userAccount = resolveUserByIdentifier(normalizedIdentifier)
                .orElseThrow(InvalidCredentialsException::new);
        ensureAccountIsActive(userAccount);
        // Reject the login when the submitted password does not match the stored hash.
        if (!this.passwordEncoder.matches(request.password(), userAccount.getPasswordHash())) {
            throw new InvalidCredentialsException();
        }
        return issueAuthResponse(userAccount);
    }

    /**
     * Rotate the refresh token and issue a new access token.
     *
     * @param request refresh token payload
     * @return refreshed auth session response
     */
    @Override
    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        final RefreshToken refreshToken = resolveRefreshToken(request.refreshToken());
        ensureRefreshTokenIsUsable(refreshToken);
        final UserAccount userAccount = refreshToken.getUserAccount();
        ensureAccountIsActive(userAccount);
        rotateRefreshToken(refreshToken);
        return issueAuthResponse(userAccount);
    }

    /**
     * Revoke the provided refresh token.
     *
     * @param request logout payload
     */
    @Override
    @Transactional
    public void logout(LogoutRequest request) {
        final RefreshToken refreshToken = resolveRefreshToken(request.refreshToken());
        // Keep logout idempotent when the refresh token was already revoked earlier.
        if (refreshToken.getTokenStatus() == RefreshTokenStatus.REVOKED) {
            return;
        }
        refreshToken.setTokenStatus(RefreshTokenStatus.REVOKED);
        refreshToken.setRevokedAt(Instant.now());
    }

    /**
     * Return the current authenticated user profile.
     *
     * @return current user response
     */
    @Override
    @Transactional(readOnly = true)
    public CurrentUserResponse getCurrentUser() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final UserAccount userAccount = this.userAccountRepository.findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(UnauthorizedAccessException::new);
        ensureAccountIsActive(userAccount);
        return new CurrentUserResponse(
                userAccount.getId(),
                userAccount.getUsername(),
                userAccount.getEmail(),
                userAccount.getAccountStatus().name());
    }

    private void validateUniqueness(String normalizedUsername, String normalizedEmail) {
        // Reject the registration when another active account already owns the username.
        if (this.userAccountRepository.existsByUsernameIgnoreCase(normalizedUsername)) {
            throw new DuplicateUsernameException();
        }
        // Reject the registration when another active account already owns the email.
        if (this.userAccountRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new DuplicateEmailException();
        }
    }

    private Optional<UserAccount> resolveUserByIdentifier(String normalizedIdentifier) {
        return this.userAccountRepository.findActiveByIdentifier(normalizedIdentifier);
    }

    private void ensureAccountIsActive(UserAccount userAccount) {
        // Continue only when the account is currently allowed to sign in.
        if (userAccount.getAccountStatus() == AccountStatus.ACTIVE) {
            return;
        }
        throw new AccountDisabledException();
    }

    private AuthResponse issueAuthResponse(UserAccount userAccount) {
        final String accessToken = this.jwtTokenService.generateAccessToken(userAccount);
        final String refreshTokenValue = generateRefreshTokenValue();
        final RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUserAccount(userAccount);
        refreshToken.setTokenHash(hashToken(refreshTokenValue));
        refreshToken.setTokenStatus(RefreshTokenStatus.ACTIVE);
        refreshToken.setExpiresAt(Instant.now().plusSeconds(this.jwtTokenService.getRefreshTokenTtlSeconds()));
        this.refreshTokenRepository.save(refreshToken);
        return new AuthResponse(
                toAuthUserResponse(userAccount),
                accessToken,
                refreshTokenValue,
                this.jwtTokenService.getAccessTokenTtlSeconds(),
                true);
    }

    private AuthUserResponse toAuthUserResponse(UserAccount userAccount) {
        return new AuthUserResponse(
                userAccount.getId(),
                userAccount.getUsername(),
                userAccount.getEmail(),
                userAccount.getAccountStatus().name());
    }

    private String normalizeUsername(String username) {
        return StringUtils.trimToEmpty(username).toLowerCase(Locale.ROOT);
    }

    private String normalizeEmail(String email) {
        return StringUtils.trimToEmpty(email).toLowerCase(Locale.ROOT);
    }

    private RefreshToken resolveRefreshToken(String rawRefreshToken) {
        final String tokenHash = hashToken(StringUtils.strip(rawRefreshToken));
        return this.refreshTokenRepository.findByTokenHashAndDeletedAtIsNull(tokenHash)
                .orElseThrow(InvalidRefreshTokenException::new);
    }

    private void ensureRefreshTokenIsUsable(RefreshToken refreshToken) {
        // Reject refresh attempts for tokens that are no longer active.
        if (refreshToken.getTokenStatus() != RefreshTokenStatus.ACTIVE) {
            throw new InvalidRefreshTokenException();
        }
        // Keep active tokens usable until their expiration timestamp is reached.
        if (refreshToken.getExpiresAt().isAfter(Instant.now())) {
            return;
        }
        refreshToken.setTokenStatus(RefreshTokenStatus.EXPIRED);
        refreshToken.setRevokedAt(Instant.now());
        throw new InvalidRefreshTokenException();
    }

    private void rotateRefreshToken(RefreshToken refreshToken) {
        refreshToken.setTokenStatus(RefreshTokenStatus.ROTATED);
        refreshToken.setRevokedAt(Instant.now());
    }

    private String generateRefreshTokenValue() {
        return UUID.randomUUID() + "-" + UUID.randomUUID();
    }

    private String hashToken(String rawRefreshToken) {
        try {
            final MessageDigest messageDigest = MessageDigest.getInstance(HASH_ALGORITHM);
            final byte[] digest = messageDigest.digest(rawRefreshToken.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException(exception);
        }
    }
}
