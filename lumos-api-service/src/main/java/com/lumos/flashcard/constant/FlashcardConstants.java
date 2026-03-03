package com.lumos.flashcard.constant;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FlashcardConstants {

    public static final int FRONT_TEXT_MAX_LENGTH = 300;
    public static final int BACK_TEXT_MAX_LENGTH = 2000;
    public static final int LANGUAGE_CODE_MAX_LENGTH = 16;
    public static final int PRONUNCIATION_MAX_LENGTH = 400;
    public static final int NOTE_MAX_LENGTH = 1000;

    public static final String EMPTY_TEXT = "";
    public static final boolean DEFAULT_IS_BOOKMARKED = false;
}
