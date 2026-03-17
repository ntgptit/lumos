package com.lumos.deck.constant;

import com.lumos.common.enums.LanguageCode;

import lombok.experimental.UtilityClass;

@UtilityClass
public class DeckImportConstants {

    public static final String FILE_PARAM_NAME = "file";
    public static final String HEADER_TERM = "term";
    public static final String HEADER_MEANING = "meaning";
    public static final String DECK_MARKER_PREFIX = "*";
    public static final String FILE_EXTENSION_XLSX = "xlsx";
    public static final String FILE_EXTENSION_XLS = "xls";
    public static final LanguageCode TERM_LANGUAGE_CODE_DEFAULT = LanguageCode.KR;
    public static final LanguageCode MEANING_LANGUAGE_CODE_DEFAULT = LanguageCode.VN;
    public static final int FIRST_SHEET_INDEX = 0;
    public static final int HEADER_ROW_INDEX = 0;
    public static final int FIRST_DATA_ROW_INDEX = 1;
    public static final int EXCEL_ROW_NUMBER_OFFSET = 1;
    public static final int MAX_SCAN_ROW_NUMBER = 10_000;
    public static final int MAX_SCAN_ROW_INDEX = MAX_SCAN_ROW_NUMBER - EXCEL_ROW_NUMBER_OFFSET;
    public static final int BATCH_SIZE = 1_000;
    public static final int MAX_FILE_SIZE_MB = 50;
    public static final long BYTES_PER_MEGABYTE = 1024L * 1024L;
    public static final long MAX_FILE_SIZE_BYTES = MAX_FILE_SIZE_MB * BYTES_PER_MEGABYTE;
}
