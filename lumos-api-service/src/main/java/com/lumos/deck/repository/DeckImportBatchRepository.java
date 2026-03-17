package com.lumos.deck.repository;

import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.DeckImportDeckDraft;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DeckImportBatchRepository {

    private static final String INSERT_DECK_SQL = """
            INSERT INTO decks (
                folder_id,
                name,
                description,
                flashcard_count,
                created_at,
                updated_at,
                version
            )
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT (folder_id, LOWER(name)) WHERE deleted_at IS NULL
            DO NOTHING
            """;

    private static final String UPDATE_FLASHCARD_COUNT_SQL = """
            UPDATE decks
            SET flashcard_count = flashcard_count + ?,
                updated_at = ?
            WHERE id = ?
              AND deleted_at IS NULL
            """;

    private static final int VERSION_DEFAULT = 0;

    private final JdbcTemplate jdbcTemplate;

    /**
     * Insert deck rows in batches while skipping active duplicate names in the same folder.
     *
     * @param folderId target folder identifier
     * @param deckDrafts normalized deck drafts
     * @param timestamp canonical import timestamp
     * @return number of newly created decks
     */
    public int insertDecksIgnoreConflicts(Long folderId, List<DeckImportDeckDraft> deckDrafts, Instant timestamp) {
        // Return zero when the parser resolved no deck drafts for insertion.
        if (deckDrafts.isEmpty()) {
            return 0;
        }
        int createdDeckCount = 0;
        for (int startIndex = 0; startIndex < deckDrafts.size(); startIndex += DeckImportConstants.BATCH_SIZE) {
            final var endIndex = Math.min(startIndex + DeckImportConstants.BATCH_SIZE, deckDrafts.size());
            final var chunk = deckDrafts.subList(startIndex, endIndex);
            createdDeckCount += this.sumUpdatedRows(this.jdbcTemplate.batchUpdate(
                    INSERT_DECK_SQL,
                    new BatchPreparedStatementSetter() {
                        @Override
                        public void setValues(java.sql.PreparedStatement preparedStatement, int index)
                                throws java.sql.SQLException {
                            final var deckDraft = chunk.get(index);
                            preparedStatement.setLong(1, folderId);
                            preparedStatement.setString(2, deckDraft.name());
                            preparedStatement.setString(3, DeckConstants.EMPTY_DESCRIPTION);
                            preparedStatement.setInt(4, DeckConstants.FLASHCARD_COUNT_DEFAULT);
                            preparedStatement.setTimestamp(5, Timestamp.from(timestamp));
                            preparedStatement.setTimestamp(6, Timestamp.from(timestamp));
                            preparedStatement.setInt(7, VERSION_DEFAULT);
                        }

                        @Override
                        public int getBatchSize() {
                            return chunk.size();
                        }
                    }));
        }
        return createdDeckCount;
    }

    /**
     * Increment deck flashcard counters in batches after flashcard import succeeds.
     *
     * @param flashcardCountByDeckId imported flashcard count by deck id
     * @param timestamp canonical import timestamp
     */
    public void incrementFlashcardCounts(Map<Long, Integer> flashcardCountByDeckId, Instant timestamp) {
        // Stop when no deck received imported flashcards.
        if (flashcardCountByDeckId.isEmpty()) {
            return;
        }
        final List<Map.Entry<Long, Integer>> countEntries = new ArrayList<>(flashcardCountByDeckId.entrySet());
        for (int startIndex = 0; startIndex < countEntries.size(); startIndex += DeckImportConstants.BATCH_SIZE) {
            final var endIndex = Math.min(startIndex + DeckImportConstants.BATCH_SIZE, countEntries.size());
            final var chunk = countEntries.subList(startIndex, endIndex);
            this.jdbcTemplate.batchUpdate(
                    UPDATE_FLASHCARD_COUNT_SQL,
                    new BatchPreparedStatementSetter() {
                        @Override
                        public void setValues(java.sql.PreparedStatement preparedStatement, int index)
                                throws java.sql.SQLException {
                            final var countEntry = chunk.get(index);
                            preparedStatement.setInt(1, countEntry.getValue());
                            preparedStatement.setTimestamp(2, Timestamp.from(timestamp));
                            preparedStatement.setLong(3, countEntry.getKey());
                        }

                        @Override
                        public int getBatchSize() {
                            return chunk.size();
                        }
                    });
        }
    }

    private int sumUpdatedRows(int[] updatedRows) {
        int updatedRowCount = 0;
        for (int updatedRow : updatedRows) {
            // Count one row when the JDBC driver reports batch success without a precise row count.
            if (updatedRow == Statement.SUCCESS_NO_INFO) {
                updatedRowCount += 1;
            }
            // Count concrete inserted rows when the driver returns an exact update count.
            if (updatedRow > 0) {
                updatedRowCount += updatedRow;
            }
        }
        return updatedRowCount;
    }
}
