package com.lumos.deck.dto.response;

public record DeckImportResponse(
        Long folderId,
        Integer processedDeckCount,
        Integer createdDeckCount,
        Integer importedFlashcardCount) {
}
