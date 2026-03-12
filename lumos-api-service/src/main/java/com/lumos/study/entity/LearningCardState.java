package com.lumos.study.entity;

import java.time.Instant;

import com.lumos.auth.entity.UserAccount;
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
        name = "learning_card_states",
        uniqueConstraints = @UniqueConstraint(name = "uk_learning_card_state_user_flashcard", columnNames = {
                "user_id",
                "flashcard_id"
        }))
public class LearningCardState extends AuditEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private UserAccount userAccount;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "flashcard_id", nullable = false)
    private Flashcard flashcard;

    @Column(name = "box_index", nullable = false)
    private Integer boxIndex;

    @Column(name = "last_reviewed_at")
    private Instant lastReviewedAt;

    @Column(name = "next_review_at", nullable = false)
    private Instant nextReviewAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "last_result", nullable = false, length = 32)
    private ReviewOutcome lastResult;

    @Column(name = "consecutive_success_count", nullable = false)
    private Integer consecutiveSuccessCount;

    @Column(name = "lapse_count", nullable = false)
    private Integer lapseCount;

    @Version
    @Column(name = "version", nullable = false)
    private Long version;
}
