package com.lumos.study.entity;

import com.lumos.common.entity.AuditEntity;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.enums.ReviewOutcome;

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
import jakarta.persistence.UniqueConstraint;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(
        name = "study_session_items",
        uniqueConstraints = @UniqueConstraint(name = "uk_study_session_items_session_sequence", columnNames = {
                "study_session_id",
                "sequence_index"
        }))
public class StudySessionItem extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "study_session_id", nullable = false)
    private StudySession studySession;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "flashcard_id", nullable = false)
    private Flashcard flashcard;

    @Column(name = "sequence_index", nullable = false)
    private Integer sequenceIndex;

    @Column(name = "front_text_snapshot", nullable = false, length = 255)
    private String frontTextSnapshot;

    @Column(name = "back_text_snapshot", nullable = false, length = 255)
    private String backTextSnapshot;

    @Column(name = "note_snapshot", nullable = false, length = 255)
    private String noteSnapshot;

    @Column(name = "pronunciation_snapshot", nullable = false, length = 255)
    private String pronunciationSnapshot;

    @Enumerated(EnumType.STRING)
    @Column(name = "last_outcome", length = 32)
    private ReviewOutcome lastOutcome;

    @Column(name = "current_mode_completed", nullable = false)
    private Boolean currentModeCompleted;

    @Column(name = "retry_pending", nullable = false)
    private Boolean retryPending;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
