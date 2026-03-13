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

    public static final String FLASHCARD_NOT_FOUND = "flashcard.not-found";

    public static final String AUTH_DUPLICATE_USERNAME = "auth.duplicate-username";
    public static final String AUTH_DUPLICATE_EMAIL = "auth.duplicate-email";
    public static final String AUTH_INVALID_CREDENTIALS = "auth.invalid-credentials";
    public static final String AUTH_INVALID_REFRESH_TOKEN = "auth.invalid-refresh-token";
    public static final String AUTH_ACCOUNT_DISABLED = "auth.account-disabled";
    public static final String AUTH_UNAUTHORIZED = "auth.unauthorized";

    public static final String STUDY_SESSION_NOT_FOUND = "study.session-not-found";
    public static final String STUDY_SESSION_UNAVAILABLE = "study.session-unavailable";
    public static final String STUDY_COMMAND_NOT_ALLOWED = "study.command-not-allowed";
    public static final String STUDY_ANSWER_PAYLOAD_INVALID = "study.answer-payload-invalid";
}
