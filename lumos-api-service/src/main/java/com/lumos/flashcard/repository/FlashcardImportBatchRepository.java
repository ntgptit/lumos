package com.lumos.flashcard.repository;

import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.flashcard.dto.FlashcardImportBatchCommand;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class FlashcardImportBatchRepository {

    private static final String INSERT_FLASHCARD_SQL = """
            INSERT INTO flashcards (
                deck_id,
                front_text,
                back_text,
                front_lang_code,
                back_lang_code,
                pronunciation,
                note,
                is_bookmarked,
                created_at,
                updated_at,
                version
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

    private static final int VERSION_DEFAULT = 0;

    private final JdbcTemplate jdbcTemplate;

    /**
     * Insert imported flashcards in batches.
     *
     * @param flashcardCommands normalized flashcard insert commands
     * @param timestamp canonical import timestamp
     * @return number of inserted flashcards
     */
    public int insertFlashcards(List<FlashcardImportBatchCommand> flashcardCommands, Instant timestamp) {
        // Return zero when the workbook contains no flashcard rows to persist.
        if (flashcardCommands.isEmpty()) {
            return 0;
        }
        int importedFlashcardCount = 0;
        for (int startIndex = 0; startIndex < flashcardCommands.size(); startIndex += DeckImportConstants.BATCH_SIZE) {
            final var endIndex = Math.min(startIndex + DeckImportConstants.BATCH_SIZE, flashcardCommands.size());
            final var chunk = flashcardCommands.subList(startIndex, endIndex);
            importedFlashcardCount += this.sumUpdatedRows(this.jdbcTemplate.batchUpdate(
                    INSERT_FLASHCARD_SQL,
                    new BatchPreparedStatementSetter() {
                        @Override
                        public void setValues(java.sql.PreparedStatement preparedStatement, int index)
                                throws java.sql.SQLException {
                            final var flashcardCommand = chunk.get(index);
                            preparedStatement.setLong(1, flashcardCommand.deckId());
                            preparedStatement.setString(2, flashcardCommand.frontText());
                            preparedStatement.setString(3, flashcardCommand.backText());
                            preparedStatement.setString(4, flashcardCommand.frontLangCode());
                            preparedStatement.setString(5, flashcardCommand.backLangCode());
                            preparedStatement.setString(6, flashcardCommand.pronunciation());
                            preparedStatement.setString(7, flashcardCommand.note());
                            preparedStatement.setBoolean(8, flashcardCommand.isBookmarked());
                            preparedStatement.setTimestamp(9, Timestamp.from(timestamp));
                            preparedStatement.setTimestamp(10, Timestamp.from(timestamp));
                            preparedStatement.setInt(11, VERSION_DEFAULT);
                        }

                        @Override
                        public int getBatchSize() {
                            return chunk.size();
                        }
                    }));
        }
        return importedFlashcardCount;
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
