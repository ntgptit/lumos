package com.lumos.deck.support;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.stream.IntStream;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.DeckImportDeckDraft;
import com.lumos.deck.dto.DeckImportFlashcardDraft;
import com.lumos.deck.exception.DeckImportFileInvalidException;
import com.lumos.deck.exception.DeckImportPayloadTooLargeException;

class DeckExcelImportSupportTest {

    private final DeckExcelImportSupport deckExcelImportSupport = new DeckExcelImportSupport();

    @Test
    void parseExcelFile_returnsNormalizedDrafts() throws IOException {
        final var file = this.excelFile(List.of(
                new String[] { "Term", "Meaning" },
                new String[] { " *TOPIK MASTER 1 ", " *TOPIK MASTER 1 " },
                new String[] { "가다", "Đi" },
                new String[] { "먹다", "Ăn" },
                new String[] { "*TOPIK MASTER 2", "*TOPIK MASTER 2" },
                new String[] { "보다", "Xem" },
                new String[] { "*TOPIK MASTER 1", "*TOPIK MASTER 1" },
                new String[] { "듣다", "Nghe" }));

        final var result = this.deckExcelImportSupport.parseExcelFile(file);

        assertEquals(
                List.of(
                        new DeckImportDeckDraft(
                                "TOPIK MASTER 1",
                                2,
                                List.of(
                                        new DeckImportFlashcardDraft("가다", "Đi", 3),
                                        new DeckImportFlashcardDraft("먹다", "Ăn", 4),
                                        new DeckImportFlashcardDraft("듣다", "Nghe", 8))),
                        new DeckImportDeckDraft(
                                "TOPIK MASTER 2",
                                5,
                                List.of(new DeckImportFlashcardDraft("보다", "Xem", 6)))),
                result);
    }

    @Test
    void parseExcelFile_whenMissingTermHeader_throwsDeckImportFileInvalidException() throws IOException {
        final var file = this.excelFile(List.of(
                new String[] { "Name", "Meaning" },
                new String[] { "*TOPIK MASTER 1", "*TOPIK MASTER 1" }));

        assertThrows(DeckImportFileInvalidException.class, () -> this.deckExcelImportSupport.parseExcelFile(file));
    }

    @Test
    void parseExcelFile_whenFlashcardAppearsBeforeDeckMarker_throwsDeckImportFileInvalidException() throws IOException {
        final var file = this.excelFile(List.of(
                new String[] { "Term", "Meaning" },
                new String[] { "가다", "Đi" }));

        assertThrows(DeckImportFileInvalidException.class, () -> this.deckExcelImportSupport.parseExcelFile(file));
    }

    @Test
    void parseExcelFile_whenFileTooLarge_throwsDeckImportPayloadTooLargeException() {
        final var file = new MockMultipartFile(
                DeckImportConstants.FILE_PARAM_NAME,
                "decks.xlsx",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                new byte[0]) {
            @Override
            public boolean isEmpty() {
                return false;
            }

            @Override
            public long getSize() {
                return DeckImportConstants.MAX_FILE_SIZE_BYTES + 1;
            }
        };

        assertThrows(DeckImportPayloadTooLargeException.class, () -> this.deckExcelImportSupport.parseExcelFile(file));
    }

    private MockMultipartFile excelFile(List<String[]> rows) throws IOException {
        try (var workbook = new XSSFWorkbook(); var outputStream = new ByteArrayOutputStream()) {
            final var sheet = workbook.createSheet("Decks");
            for (int rowIndex = 0; rowIndex < rows.size(); rowIndex++) {
                final var row = sheet.createRow(rowIndex);
                final var cells = rows.get(rowIndex);
                IntStream.range(0, cells.length)
                        .forEach(cellIndex -> row.createCell(cellIndex).setCellValue(cells[cellIndex]));
            }
            workbook.write(outputStream);
            return new MockMultipartFile(
                    DeckImportConstants.FILE_PARAM_NAME,
                    "decks.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    outputStream.toByteArray());
        }
    }
}
