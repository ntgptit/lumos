package com.lumos.flashcard.repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.lumos.flashcard.entity.Flashcard;

public interface FlashcardRepository extends JpaRepository<Flashcard, Long>, JpaSpecificationExecutor<Flashcard> {

    Optional<Flashcard> findByIdAndDeletedAtIsNull(Long id);

    List<Flashcard> findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(Long deckId);

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
