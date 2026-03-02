package com.lumos.deck.dto.response;

public record DeckResponse(
        Long id,
        Long folderId,
        String name,
        String description,
        Integer flashcardCount,
        AuditMetadataResponse audit
) {
}
