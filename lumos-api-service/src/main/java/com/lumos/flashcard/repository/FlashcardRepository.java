package com.lumos.flashcard.repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.lumos.flashcard.entity.Flashcard;

public interface FlashcardRepository extends JpaRepository<Flashcard, Long>, JpaSpecificationExecutor<Flashcard> {

    Optional<Flashcard> findByIdAndDeletedAtIsNull(Long id);

    List<Flashcard> findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(Long deckId);

    @Query(value = """
            SELECT f.*
            FROM flashcards f
            WHERE f.deck_id = :deckId
              AND f.deleted_at IS NULL
              AND NOT EXISTS (
                  SELECT 1
                  FROM learning_card_states lcs
                  WHERE lcs.user_id = :userId
                    AND lcs.flashcard_id = f.id
                    AND lcs.deleted_at IS NULL
              )
            ORDER BY f.id ASC
            """, nativeQuery = true)
    List<Flashcard> findFirstLearningFlashcards(
            @Param("userId") Long userId,
            @Param("deckId") Long deckId,
            Pageable pageable);

    @Query(value = """
            SELECT f.*
            FROM flashcards f
            INNER JOIN learning_card_states lcs
                ON lcs.flashcard_id = f.id
            WHERE f.deck_id = :deckId
              AND f.deleted_at IS NULL
              AND lcs.user_id = :userId
              AND lcs.deleted_at IS NULL
              AND lcs.next_review_at <= :threshold
            ORDER BY lcs.box_index ASC, f.id ASC
            """, nativeQuery = true)
    List<Flashcard> findDueReviewFlashcards(
            @Param("userId") Long userId,
            @Param("deckId") Long deckId,
            @Param("threshold") Instant threshold);

    @Modifying
    @Query(value = """
            UPDATE flashcards
            SET deleted_at = :deletedAt,
                updated_at = :deletedAt
            WHERE id = :flashcardId
              AND deck_id = :deckId
              AND deleted_at IS NULL
            """, nativeQuery = true)
    int softDeleteFlashcard(
            @Param("deckId") Long deckId,
            @Param("flashcardId") Long flashcardId,
            @Param("deletedAt") Instant deletedAt);
}
