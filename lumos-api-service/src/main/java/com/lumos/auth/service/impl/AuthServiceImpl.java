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
import com.lumos.auth.mapper.AuthMapper;
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
    private final AuthMapper authMapper;

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
        // Return the initial authenticated session for the account that has just been persisted.
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
            // Stop the login flow immediately so invalid credentials never issue tokens.
            throw new InvalidCredentialsException();
        }
        // Return a fresh authenticated session after the credentials have been verified.
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
        // Return the rotated session payload after replacing the consumed refresh token.
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
            // Return immediately because logout is already fully applied for this token.
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
        // Return the active account profile that matches the current authenticated principal.
        return this.authMapper.toCurrentUserResponse(userAccount);
    }

    private void validateUniqueness(String normalizedUsername, String normalizedEmail) {
        // Reject the registration when another active account already owns the username.
        if (this.userAccountRepository.existsByUsernameIgnoreCase(normalizedUsername)) {
            // Stop registration because usernames must remain globally unique among active accounts.
            throw new DuplicateUsernameException();
        }
        // Reject the registration when another active account already owns the email.
        if (this.userAccountRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            // Stop registration because emails must remain globally unique among active accounts.
            throw new DuplicateEmailException();
        }
    }

    private Optional<UserAccount> resolveUserByIdentifier(String normalizedIdentifier) {
        // Return the active account resolved by username-or-email so auth stays canonical in one query.
        return this.userAccountRepository.findActiveByIdentifier(normalizedIdentifier);
    }

    private void ensureAccountIsActive(UserAccount userAccount) {
        // Continue only when the account is currently allowed to sign in.
        if (userAccount.getAccountStatus() == AccountStatus.ACTIVE) {
            // Return immediately because active accounts may continue through the auth flow.
            return;
        }
        // Stop token issuance for accounts that have been disabled at the account-state level.
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
        // Return the full auth payload that the client needs to bootstrap or refresh the session.
        return this.authMapper.toAuthResponse(
                userAccount,
                accessToken,
                refreshTokenValue,
                this.jwtTokenService.getAccessTokenTtlSeconds());
    }

    private String normalizeUsername(String username) {
        // Return the canonical username format used for uniqueness checks and account lookup.
        return StringUtils.trimToEmpty(username).toLowerCase(Locale.ROOT);
    }

    private String normalizeEmail(String email) {
        // Return the canonical email format used for uniqueness checks and account lookup.
        return StringUtils.trimToEmpty(email).toLowerCase(Locale.ROOT);
    }

    private RefreshToken resolveRefreshToken(String rawRefreshToken) {
        final String tokenHash = hashToken(StringUtils.strip(rawRefreshToken));
        // Return the persisted refresh token record that matches the presented token hash.
        return this.refreshTokenRepository.findByTokenHashAndDeletedAtIsNull(tokenHash)
                .orElseThrow(InvalidRefreshTokenException::new);
    }

    private void ensureRefreshTokenIsUsable(RefreshToken refreshToken) {
        // Reject refresh attempts for tokens that are no longer active.
        if (refreshToken.getTokenStatus() != RefreshTokenStatus.ACTIVE) {
            // Stop refresh immediately because rotated, revoked, and expired tokens must not be reused.
            throw new InvalidRefreshTokenException();
        }
        // Keep active tokens usable until their expiration timestamp is reached.
        if (refreshToken.getExpiresAt().isAfter(Instant.now())) {
            // Return immediately because the active refresh token is still inside its valid lifetime.
            return;
        }
        refreshToken.setTokenStatus(RefreshTokenStatus.EXPIRED);
        refreshToken.setRevokedAt(Instant.now());
        // Stop refresh after marking the token expired so subsequent reuse is consistently rejected.
        throw new InvalidRefreshTokenException();
    }

    private void rotateRefreshToken(RefreshToken refreshToken) {
        refreshToken.setTokenStatus(RefreshTokenStatus.ROTATED);
        refreshToken.setRevokedAt(Instant.now());
    }

    private String generateRefreshTokenValue() {
        // Return a high-entropy opaque refresh token that is stored only as a hash in persistence.
        return UUID.randomUUID() + "-" + UUID.randomUUID();
    }

    private String hashToken(String rawRefreshToken) {
        try {
            final MessageDigest messageDigest = MessageDigest.getInstance(HASH_ALGORITHM);
            final byte[] digest = messageDigest.digest(rawRefreshToken.getBytes(StandardCharsets.UTF_8));
            // Return the deterministic token hash that the database uses for refresh-token lookup.
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException exception) {
            // Stop startup-time auth flows because refresh-token hashing cannot work without the algorithm.
            throw new IllegalStateException(exception);
        }
    }
}
