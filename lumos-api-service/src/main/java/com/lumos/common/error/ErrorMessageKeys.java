package com.lumos.common.error;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ErrorMessageKeys {

    public static final String COMMON_UNEXPECTED_ERROR = "common.unexpected-error";
    public static final String APP_VALIDATION_FAILED = "app.validation.failed";

    public static final String FOLDER_NOT_FOUND = "folder.not-found";
    public static final String FOLDER_NAME_CONFLICT = "folder.name-conflict";
    public static final String FOLDER_HAS_DECKS_CONFLICT = "folder.has-decks-conflict";

    public static final String DECK_NOT_FOUND = "deck.not-found";
    public static final String DECK_NAME_CONFLICT = "deck.name-conflict";
    public static final String DECK_PARENT_HAS_SUBFOLDERS = "deck.parent-has-subfolders";
}
