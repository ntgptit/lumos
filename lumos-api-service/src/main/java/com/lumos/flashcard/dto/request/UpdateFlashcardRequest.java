package com.lumos.flashcard.dto.request;

import com.lumos.flashcard.constant.FlashcardConstants;
import com.lumos.flashcard.constant.ValidationMessageKeys;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateFlashcardRequest(
        @NotBlank(message = ValidationMessageKeys.FLASHCARD_FRONT_TEXT_REQUIRED)
        @Size(max = FlashcardConstants.FRONT_TEXT_MAX_LENGTH, message = ValidationMessageKeys.FLASHCARD_FRONT_TEXT_MAX_LENGTH)
        String frontText,
        @NotBlank(message = ValidationMessageKeys.FLASHCARD_BACK_TEXT_REQUIRED)
        @Size(max = FlashcardConstants.BACK_TEXT_MAX_LENGTH, message = ValidationMessageKeys.FLASHCARD_BACK_TEXT_MAX_LENGTH)
        String backText,
        @Size(max = FlashcardConstants.LANGUAGE_CODE_MAX_LENGTH, message = ValidationMessageKeys.FLASHCARD_FRONT_LANG_CODE_MAX_LENGTH)
        String frontLangCode,
        @Size(max = FlashcardConstants.LANGUAGE_CODE_MAX_LENGTH, message = ValidationMessageKeys.FLASHCARD_BACK_LANG_CODE_MAX_LENGTH)
        String backLangCode) {
}

