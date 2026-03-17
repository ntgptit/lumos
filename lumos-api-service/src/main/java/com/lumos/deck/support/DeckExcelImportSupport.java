package com.lumos.deck.support;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Strings;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;
import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.DeckImportDeckDraft;
import com.lumos.deck.dto.DeckImportFlashcardDraft;
import com.lumos.deck.exception.DeckImportFileInvalidException;
import com.lumos.deck.exception.DeckImportPayloadTooLargeException;
import com.lumos.flashcard.constant.FlashcardConstants;

@Component
public class DeckExcelImportSupport {

    private final DataFormatter dataFormatter = new DataFormatter();

    /**
     * Parse the first sheet of the provided Excel file into normalized deck drafts.
     *
     * @param file Excel import file
     * @return normalized deck drafts with grouped flashcard rows
     */
    public List<DeckImportDeckDraft> parseExcelFile(MultipartFile file) {
        this.validateFile(file);
        try (var inputStream = file.getInputStream(); var workbook = WorkbookFactory.create(inputStream)) {
            final var sheet = workbook.getNumberOfSheets() > 0
                    ? workbook.getSheetAt(DeckImportConstants.FIRST_SHEET_INDEX)
                    : null;
            // Reject files without a usable first sheet because no deck rows can be read from them.
            if (sheet == null) {
                throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_FILE_EMPTY);
            }
            final var headerIndexByName = this.resolveHeaderIndexByName(sheet.getRow(DeckImportConstants.HEADER_ROW_INDEX));
            final Map<String, String> deckNameByNormalizedName = new LinkedHashMap<>();
            final Map<String, Integer> deckRowNumberByNormalizedName = new LinkedHashMap<>();
            final Map<String, List<DeckImportFlashcardDraft>> flashcardsByNormalizedDeckName = new LinkedHashMap<>();
            String currentDeckKey = null;
            final var lastRowIndex = Math.min(sheet.getLastRowNum(), DeckImportConstants.MAX_SCAN_ROW_INDEX);
            for (int rowIndex = DeckImportConstants.FIRST_DATA_ROW_INDEX; rowIndex <= lastRowIndex; rowIndex++) {
                final var row = sheet.getRow(rowIndex);
                // Skip sparse row indexes because Excel can omit physical row objects.
                if (row == null) {
                    continue;
                }
                final var term = this.readCellValue(row, headerIndexByName.get(DeckImportConstants.HEADER_TERM));
                final var meaning = this.readCellValue(row, headerIndexByName.get(DeckImportConstants.HEADER_MEANING));
                // Skip visually blank rows so empty spacing inside the sheet remains harmless.
                if (StringUtils.isBlank(term) && StringUtils.isBlank(meaning)) {
                    continue;
                }
                final var rowNumber = row.getRowNum() + DeckImportConstants.EXCEL_ROW_NUMBER_OFFSET;
                final var isDeckMarkerRow = this.containsDeckMarker(term) || this.containsDeckMarker(meaning);
                final var deckMarkerName = this.resolveDeckMarkerName(term, meaning);
                // Register the current deck section when the row starts a new deck marker block.
                if (isDeckMarkerRow) {
                    currentDeckKey = this.registerDeck(
                            deckMarkerName,
                            rowNumber,
                            deckNameByNormalizedName,
                            deckRowNumberByNormalizedName,
                            flashcardsByNormalizedDeckName);
                    continue;
                }
                // Reject flashcard rows that appear before any deck marker row.
                if (currentDeckKey == null) {
                    throw new DeckImportFileInvalidException(
                            ErrorMessageKeys.DECK_IMPORT_DECK_MARKER_REQUIRED_BEFORE_ROW,
                            rowNumber);
                }
                this.validateFlashcardRow(term, meaning, rowNumber);
                flashcardsByNormalizedDeckName.get(currentDeckKey).add(new DeckImportFlashcardDraft(
                        StringUtils.trim(term),
                        StringUtils.trim(meaning),
                        rowNumber));
            }
            // Reject files without any deck marker because the import cannot resolve deck ownership.
            if (deckNameByNormalizedName.isEmpty()) {
                throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_FILE_EMPTY);
            }
            return this.toDeckDrafts(
                    deckNameByNormalizedName,
                    deckRowNumberByNormalizedName,
                    flashcardsByNormalizedDeckName);
        } catch (BaseApiException exception) {
            throw exception;
        } catch (IOException | RuntimeException exception) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_READ_FAILED);
        }
    }

    private void validateFile(MultipartFile file) {
        // Reject missing multipart part because import requires one uploaded Excel file.
        if (file == null) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_FILE_REQUIRED);
        }
        // Reject zero-byte uploads because they cannot contain import rows.
        if (file.isEmpty()) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_FILE_EMPTY);
        }
        // Reject oversized uploads before parsing to avoid unnecessary workbook allocation.
        if (file.getSize() > DeckImportConstants.MAX_FILE_SIZE_BYTES) {
            throw new DeckImportPayloadTooLargeException(DeckImportConstants.MAX_FILE_SIZE_MB);
        }
        final var extension = this.resolveExtension(file.getOriginalFilename());
        final var isSupportedExtension = StringUtils.equalsAny(
                extension,
                DeckImportConstants.FILE_EXTENSION_XLSX,
                DeckImportConstants.FILE_EXTENSION_XLS);
        // Reject unsupported file formats because this import accepts Excel files only.
        if (!isSupportedExtension) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_UNSUPPORTED_FORMAT);
        }
    }

    private Map<String, Integer> resolveHeaderIndexByName(Row headerRow) {
        final Map<String, Integer> headerIndexByName = new HashMap<>();
        // Reject files without a header row because column lookup depends on it.
        if (headerRow == null) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_TERM_HEADER_REQUIRED);
        }
        for (int cellIndex = headerRow.getFirstCellNum(); cellIndex < headerRow.getLastCellNum(); cellIndex++) {
            final var normalizedHeader = this.normalizeHeader(this.readCellValue(headerRow, cellIndex));
            // Ignore blank header cells because they do not contribute import metadata.
            if (StringUtils.isBlank(normalizedHeader)) {
                continue;
            }
            headerIndexByName.putIfAbsent(normalizedHeader, cellIndex);
        }
        // Reject files without the required term column because flashcard parsing depends on it.
        if (!headerIndexByName.containsKey(DeckImportConstants.HEADER_TERM)) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_TERM_HEADER_REQUIRED);
        }
        // Reject files without the required meaning column because flashcard parsing depends on it.
        if (!headerIndexByName.containsKey(DeckImportConstants.HEADER_MEANING)) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_MEANING_HEADER_REQUIRED);
        }
        return headerIndexByName;
    }

    private String registerDeck(
            String rawDeckName,
            Integer rowNumber,
            Map<String, String> deckNameByNormalizedName,
            Map<String, Integer> deckRowNumberByNormalizedName,
            Map<String, List<DeckImportFlashcardDraft>> flashcardsByNormalizedDeckName) {
        final var deckName = this.normalizeDeckName(rawDeckName, rowNumber);
        final var normalizedDeckName = this.normalizeLookupKey(deckName);
        // Return the existing deck key when the workbook re-enters a previously declared deck section.
        if (deckNameByNormalizedName.containsKey(normalizedDeckName)) {
            return normalizedDeckName;
        }
        deckNameByNormalizedName.put(normalizedDeckName, deckName);
        deckRowNumberByNormalizedName.put(normalizedDeckName, rowNumber);
        flashcardsByNormalizedDeckName.put(normalizedDeckName, new ArrayList<>());
        return normalizedDeckName;
    }

    private void validateFlashcardRow(String term, String meaning, Integer rowNumber) {
        // Reject rows without a term because the flashcard front text is mandatory.
        if (StringUtils.isBlank(term)) {
            throw new DeckImportFileInvalidException(
                    ErrorMessageKeys.DECK_IMPORT_TERM_REQUIRED_AT_ROW,
                    rowNumber);
        }
        // Reject rows without a meaning because the flashcard back text is mandatory.
        if (StringUtils.isBlank(meaning)) {
            throw new DeckImportFileInvalidException(
                    ErrorMessageKeys.DECK_IMPORT_MEANING_REQUIRED_AT_ROW,
                    rowNumber);
        }
        final var normalizedTerm = StringUtils.trim(term);
        final var normalizedMeaning = StringUtils.trim(meaning);
        // Reject overlong term values before batching flashcard inserts.
        if (normalizedTerm.length() > FlashcardConstants.FRONT_TEXT_MAX_LENGTH) {
            throw new DeckImportFileInvalidException(
                    ErrorMessageKeys.DECK_IMPORT_TERM_MAX_LENGTH_AT_ROW,
                    rowNumber,
                    FlashcardConstants.FRONT_TEXT_MAX_LENGTH);
        }
        // Reject overlong meaning values before batching flashcard inserts.
        if (normalizedMeaning.length() > FlashcardConstants.BACK_TEXT_MAX_LENGTH) {
            throw new DeckImportFileInvalidException(
                    ErrorMessageKeys.DECK_IMPORT_MEANING_MAX_LENGTH_AT_ROW,
                    rowNumber,
                    FlashcardConstants.BACK_TEXT_MAX_LENGTH);
        }
    }

    private String readCellValue(Row row, Integer columnIndex) {
        // Return empty text when the target column is absent because the cell is optional or missing.
        if (columnIndex == null || columnIndex < 0) {
            return DeckConstants.EMPTY_DESCRIPTION;
        }
        final var cell = row.getCell(columnIndex);
        // Return empty text for missing cells so row validation can decide whether to skip or fail.
        if (cell == null) {
            return DeckConstants.EMPTY_DESCRIPTION;
        }
        return StringUtils.trim(this.dataFormatter.formatCellValue(cell));
    }

    private String normalizeHeader(String value) {
        // Return empty text for blank headers so header matching can ignore them.
        if (StringUtils.isBlank(value)) {
            return DeckConstants.EMPTY_DESCRIPTION;
        }
        return StringUtils.lowerCase(StringUtils.trim(value));
    }

    private String resolveDeckMarkerName(String term, String meaning) {
        // Return the term marker first because column A is the canonical deck-marker source.
        if (this.containsDeckMarker(term)) {
            return this.resolveMarkedValue(term);
        }
        // Return the meaning marker only when column A does not carry the deck section marker.
        if (this.containsDeckMarker(meaning)) {
            return this.resolveMarkedValue(meaning);
        }
        return null;
    }

    private boolean containsDeckMarker(String value) {
        // Return false when the cell is blank because blank cells cannot start a deck section.
        if (StringUtils.isBlank(value)) {
            return false;
        }
        final var trimmedValue = StringUtils.trim(value);
        return Strings.CS.startsWith(trimmedValue, DeckImportConstants.DECK_MARKER_PREFIX);
    }

    private String resolveMarkedValue(String value) {
        // Return null when the cell does not contain marker content.
        if (StringUtils.isBlank(value)) {
            return null;
        }
        final var trimmedValue = StringUtils.trim(value);
        // Return null when the cell does not start with the deck marker prefix.
        if (!Strings.CS.startsWith(trimmedValue, DeckImportConstants.DECK_MARKER_PREFIX)) {
            return null;
        }
        return StringUtils.trim(StringUtils.substringAfter(trimmedValue, DeckImportConstants.DECK_MARKER_PREFIX));
    }

    private String normalizeDeckName(String rawDeckName, Integer rowNumber) {
        // Reject marker rows without an actual deck name after the leading asterisk.
        if (StringUtils.isBlank(rawDeckName)) {
            throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_DECK_NAME_REQUIRED_AT_ROW, rowNumber);
        }
        final var normalizedDeckName = StringUtils.trim(rawDeckName);
        // Reject overlong deck names before the insert-or-ignore batch runs.
        if (normalizedDeckName.length() > DeckConstants.NAME_MAX_LENGTH) {
            throw new DeckImportFileInvalidException(
                    ErrorMessageKeys.DECK_IMPORT_DECK_NAME_MAX_LENGTH_AT_ROW,
                    rowNumber,
                    DeckConstants.NAME_MAX_LENGTH);
        }
        return normalizedDeckName;
    }

    private String normalizeLookupKey(String value) {
        // Return the lower-case lookup key so repeated deck markers merge into one logical deck.
        return StringUtils.lowerCase(value);
    }

    private List<DeckImportDeckDraft> toDeckDrafts(
            Map<String, String> deckNameByNormalizedName,
            Map<String, Integer> deckRowNumberByNormalizedName,
            Map<String, List<DeckImportFlashcardDraft>> flashcardsByNormalizedDeckName) {
        final List<DeckImportDeckDraft> deckDrafts = new ArrayList<>();
        for (Map.Entry<String, String> deckEntry : deckNameByNormalizedName.entrySet()) {
            final var normalizedDeckName = deckEntry.getKey();
            deckDrafts.add(new DeckImportDeckDraft(
                    deckEntry.getValue(),
                    deckRowNumberByNormalizedName.get(normalizedDeckName),
                    List.copyOf(flashcardsByNormalizedDeckName.get(normalizedDeckName))));
        }
        return deckDrafts;
    }

    private String resolveExtension(String originalFilename) {
        final var normalizedFilename = StringUtils.defaultString(originalFilename);
        final var extension = StringUtils.substringAfterLast(normalizedFilename, ".");
        return StringUtils.lowerCase(extension);
    }
}
