package com.lumos.testkit;

import java.time.Instant;

import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.AuditMetadataResponse;
import com.lumos.deck.dto.response.DeckImportResponse;
import com.lumos.deck.dto.response.DeckResponse;

public final class DeckTestFixtures {

    private DeckTestFixtures() {
    }

    public static CreateDeckRequest createDeckRequest(String name, String description) {
        
        return new CreateDeckRequest(name, description);
    }

    public static UpdateDeckRequest updateDeckRequest(String name, String description) {
        
        return new UpdateDeckRequest(name, description);
    }

    public static DeckResponse deckResponse(
            Long deckId,
            Long folderId,
            String name,
            String description,
            Integer flashcardCount) {
        
        return new DeckResponse(
                deckId,
                folderId,
                name,
                description,
                flashcardCount,
                new AuditMetadataResponse(
                        Instant.parse("2026-01-01T00:00:00Z"),
                        Instant.parse("2026-01-02T00:00:00Z")));
    }

    public static DeckImportResponse deckImportResponse(
            Long folderId,
            Integer processedDeckCount,
            Integer createdDeckCount,
            Integer importedFlashcardCount) {

        return new DeckImportResponse(folderId, processedDeckCount, createdDeckCount, importedFlashcardCount);
    }
}
