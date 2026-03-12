package com.lumos.auth.entity;

import java.time.Instant;

import com.lumos.auth.constant.AuthConstants;
import com.lumos.auth.enums.RefreshTokenStatus;
import com.lumos.common.entity.AuditEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "refresh_tokens")
public class RefreshToken extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private UserAccount userAccount;

    @Column(name = "token_hash", nullable = false, unique = true, length = AuthConstants.TOKEN_HASH_LENGTH)
    private String tokenHash;

    @Enumerated(EnumType.STRING)
    @Column(name = "token_status", nullable = false, length = 20)
    private RefreshTokenStatus tokenStatus;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    @Column(name = "revoked_at")
    private Instant revokedAt;

    @Column(name = "device_label", length = AuthConstants.DEVICE_LABEL_MAX_LENGTH)
    private String deviceLabel;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
