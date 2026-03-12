package com.lumos.study.entity;

import com.lumos.auth.entity.UserAccount;
import com.lumos.common.entity.AuditEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "user_speech_preferences")
public class UserSpeechPreference extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private UserAccount userAccount;

    @Column(name = "enabled", nullable = false)
    private Boolean enabled;

    @Column(name = "auto_play", nullable = false)
    private Boolean autoPlay;

    @Column(name = "voice", nullable = false, length = 120)
    private String voice;

    @Column(name = "speed", nullable = false)
    private Double speed;

    @Column(name = "locale", nullable = false, length = 20)
    private String locale;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
