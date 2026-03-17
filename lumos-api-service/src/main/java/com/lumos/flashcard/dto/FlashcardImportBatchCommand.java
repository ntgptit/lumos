package com.lumos.flashcard.dto;

public record FlashcardImportBatchCommand(
        Long deckId,
        String frontText,
        String backText,
        String frontLangCode,
        String backLangCode,
        String pronunciation,
        String note,
        Boolean isBookmarked) {
}
