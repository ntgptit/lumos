package com.lumos.study.entity;

import com.lumos.auth.entity.UserAccount;
import com.lumos.common.entity.AuditEntity;
import com.lumos.deck.entity.Deck;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudySessionType;

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
@Table(name = "study_sessions")
public class StudySession extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private UserAccount userAccount;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "deck_id", nullable = false)
    private Deck deck;

    @Enumerated(EnumType.STRING)
    @Column(name = "session_type", nullable = false, length = 32)
    private StudySessionType sessionType;

    @Column(name = "mode_plan", nullable = false, length = 120)
    private String modePlan;

    @Column(name = "current_mode_index", nullable = false)
    private Integer currentModeIndex;

    @Enumerated(EnumType.STRING)
    @Column(name = "active_mode", nullable = false, length = 32)
    private StudyMode activeMode;

    @Enumerated(EnumType.STRING)
    @Column(name = "mode_state", nullable = false, length = 32)
    private StudyModeLifecycleState modeState;

    @Column(name = "current_item_index", nullable = false)
    private Integer currentItemIndex;

    @Column(name = "session_completed", nullable = false)
    private Boolean sessionCompleted;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
