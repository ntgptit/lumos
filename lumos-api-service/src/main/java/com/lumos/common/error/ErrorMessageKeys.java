package com.lumos.common.error;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ErrorMessageKeys {

    public static final String COMMON_UNEXPECTED_ERROR = "common.unexpected-error";
    public static final String COMMON_RESOURCE_NOT_FOUND = "common.resource-not-found";
    public static final String APP_VALIDATION_FAILED = "app.validation.failed";

    public static final String FOLDER_NOT_FOUND = "folder.not-found";
    public static final String FOLDER_NAME_CONFLICT = "folder.name-conflict";
    public static final String FOLDER_HAS_DECKS_CONFLICT = "folder.has-decks-conflict";

    public static final String DECK_NOT_FOUND = "deck.not-found";
    public static final String DECK_NAME_CONFLICT = "deck.name-conflict";
    public static final String DECK_PARENT_HAS_SUBFOLDERS = "deck.parent-has-subfolders";
    public static final String DECK_IMPORT_FILE_REQUIRED = "deck.import.file.required";
    public static final String DECK_IMPORT_UNSUPPORTED_FORMAT = "deck.import.unsupported-format";
    public static final String DECK_IMPORT_FILE_EMPTY = "deck.import.file-empty";
    public static final String DECK_IMPORT_FILE_TOO_LARGE = "deck.import.file-too-large";
    public static final String DECK_IMPORT_TERM_HEADER_REQUIRED = "deck.import.term-header.required";
    public static final String DECK_IMPORT_MEANING_HEADER_REQUIRED = "deck.import.meaning-header.required";
    public static final String DECK_IMPORT_READ_FAILED = "deck.import.read-failed";
    public static final String DECK_IMPORT_DECK_NAME_REQUIRED_AT_ROW = "deck.import.deck-name.required-at-row";
    public static final String DECK_IMPORT_DECK_NAME_MAX_LENGTH_AT_ROW = "deck.import.deck-name.max-length-at-row";
    public static final String DECK_IMPORT_DECK_MARKER_REQUIRED_BEFORE_ROW = "deck.import.deck-marker.required-before-row";
    public static final String DECK_IMPORT_TERM_REQUIRED_AT_ROW = "deck.import.term.required-at-row";
    public static final String DECK_IMPORT_MEANING_REQUIRED_AT_ROW = "deck.import.meaning.required-at-row";
    public static final String DECK_IMPORT_TERM_MAX_LENGTH_AT_ROW = "deck.import.term.max-length-at-row";
    public static final String DECK_IMPORT_MEANING_MAX_LENGTH_AT_ROW = "deck.import.meaning.max-length-at-row";

    public static final String FLASHCARD_NOT_FOUND = "flashcard.not-found";

    public static final String AUTH_DUPLICATE_USERNAME = "auth.duplicate-username";
    public static final String AUTH_DUPLICATE_EMAIL = "auth.duplicate-email";
    public static final String AUTH_INVALID_CREDENTIALS = "auth.invalid-credentials";
    public static final String AUTH_INVALID_REFRESH_TOKEN = "auth.invalid-refresh-token";
    public static final String AUTH_ACCOUNT_DISABLED = "auth.account-disabled";
    public static final String AUTH_FORBIDDEN = "auth.forbidden";
    public static final String AUTH_UNAUTHORIZED = "auth.unauthorized";

    public static final String STUDY_SESSION_NOT_FOUND = "study.session-not-found";
    public static final String STUDY_SESSION_UNAVAILABLE = "study.session-unavailable";
    public static final String STUDY_COMMAND_NOT_ALLOWED = "study.command-not-allowed";
    public static final String STUDY_ANSWER_PAYLOAD_INVALID = "study.answer-payload-invalid";
}
