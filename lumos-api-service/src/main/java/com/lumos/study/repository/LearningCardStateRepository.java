package com.lumos.study.repository;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.lumos.study.entity.LearningCardState;

public interface LearningCardStateRepository extends JpaRepository<LearningCardState, Long> {

    List<LearningCardState> findAllByUserAccountIdAndDeletedAtIsNull(Long userId);

    List<LearningCardState> findAllByUserAccountIdAndFlashcardIdInAndDeletedAtIsNull(Long userId,
            Collection<Long> flashcardIds);

    Optional<LearningCardState> findByUserAccountIdAndFlashcardIdAndDeletedAtIsNull(Long userId, Long flashcardId);

    long countByUserAccountIdAndNextReviewAtLessThanEqualAndDeletedAtIsNull(Long userId, Instant threshold);
}
