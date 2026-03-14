package com.lumos.auth.entity;

import com.lumos.auth.constant.AuthConstants;
import com.lumos.auth.enums.AccountStatus;
import com.lumos.common.entity.AuditEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "user_accounts")
public class UserAccount extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "username", nullable = false, unique = true, length = AuthConstants.USERNAME_MAX_LENGTH)
    private String username;

    @Column(name = "email", nullable = false, unique = true, length = AuthConstants.EMAIL_MAX_LENGTH)
    private String email;

    @Column(name = "password_hash", nullable = false, length = AuthConstants.PASSWORD_MAX_LENGTH * 2)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(name = "account_status", nullable = false, length = 20)
    private AccountStatus accountStatus;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
