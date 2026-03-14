package com.lumos.study.entity;

import com.lumos.common.entity.AuditEntity;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;

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
@Table(name = "study_attempts")
public class StudyAttempt extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "study_session_id", nullable = false)
    private StudySession studySession;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "flashcard_id", nullable = false)
    private Flashcard flashcard;

    @Enumerated(EnumType.STRING)
    @Column(name = "study_mode", nullable = false, length = 32)
    private StudyMode studyMode;

    @Enumerated(EnumType.STRING)
    @Column(name = "review_outcome", nullable = false, length = 32)
    private ReviewOutcome reviewOutcome;

    @Column(name = "submitted_answer", length = 255)
    private String submittedAnswer;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
