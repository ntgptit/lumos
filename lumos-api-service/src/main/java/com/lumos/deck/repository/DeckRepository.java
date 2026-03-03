package com.lumos.deck.repository;

import java.time.Instant;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.lumos.deck.entity.Deck;

public interface DeckRepository extends JpaRepository<Deck, Long>, JpaSpecificationExecutor<Deck> {

    Optional<Deck> findByIdAndDeletedAtIsNull(Long id);

    boolean existsByFolderIdAndDeletedAtIsNull(Long folderId);

    @Query(value = """
            SELECT COUNT(1) > 0
            FROM decks d
            WHERE d.deleted_at IS NULL
              AND d.folder_id = :folderId
              AND (:excludeId IS NULL OR d.id <> :excludeId)
              AND LOWER(d.name) = LOWER(:name)
            """, nativeQuery = true)
    boolean existsActiveNameByFolderId(@Param("folderId") Long folderId, @Param("name") String name,
            @Param("excludeId") Long excludeId);

    @Modifying
    @Query(value = """
            UPDATE decks
            SET deleted_at = :deletedAt,
                updated_at = :deletedAt
            WHERE id = :deckId
              AND folder_id = :folderId
              AND deleted_at IS NULL
            """, nativeQuery = true)
    int softDeleteDeck(@Param("folderId") Long folderId, @Param("deckId") Long deckId, @Param("deletedAt") Instant deletedAt);

    @Modifying
    @Query(value = """
            UPDATE decks
            SET flashcard_count = GREATEST(flashcard_count + :delta, 0),
                updated_at = :updatedAt
            WHERE id = :deckId
              AND deleted_at IS NULL
            """, nativeQuery = true)
    int adjustFlashcardCount(
            @Param("deckId") Long deckId,
            @Param("delta") Integer delta,
            @Param("updatedAt") Instant updatedAt);

    @Modifying
    @Query(value = """
            WITH RECURSIVE folder_tree AS (
                SELECT f.id
                FROM folders f
                WHERE f.id = :folderId AND f.deleted_at IS NULL
                UNION ALL
                SELECT c.id
                FROM folders c
                JOIN folder_tree ft ON c.parent_id = ft.id
                WHERE c.deleted_at IS NULL
            )
            UPDATE decks
            SET deleted_at = :deletedAt,
                updated_at = :deletedAt
            WHERE folder_id IN (SELECT id FROM folder_tree)
              AND deleted_at IS NULL
            """, nativeQuery = true)
    int softDeleteByFolderTree(@Param("folderId") Long folderId, @Param("deletedAt") Instant deletedAt);
}
