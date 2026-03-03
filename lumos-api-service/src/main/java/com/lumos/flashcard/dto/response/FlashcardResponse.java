package com.lumos.flashcard.dto.response;

public record FlashcardResponse(
        Long id,
        Long deckId,
        String frontText,
        String backText,
        String frontLangCode,
        String backLangCode,
        String pronunciation,
        String note,
        Boolean isBookmarked,
        AuditMetadataResponse audit) {
}
