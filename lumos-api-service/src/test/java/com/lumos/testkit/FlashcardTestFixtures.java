package com.lumos.testkit;

import java.time.Instant;
import java.util.List;

import com.lumos.flashcard.dto.request.CreateFlashcardRequest;
import com.lumos.flashcard.dto.request.UpdateFlashcardRequest;
import com.lumos.flashcard.dto.response.AuditMetadataResponse;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;

public final class FlashcardTestFixtures {

    private FlashcardTestFixtures() {
    }

    public static CreateFlashcardRequest createFlashcardRequest(
            String frontText,
            String backText,
            String frontLangCode,
            String backLangCode) {
        return new CreateFlashcardRequest(frontText, backText, frontLangCode, backLangCode);
    }

    public static UpdateFlashcardRequest updateFlashcardRequest(
            String frontText,
            String backText,
            String frontLangCode,
            String backLangCode) {
        return new UpdateFlashcardRequest(frontText, backText, frontLangCode, backLangCode);
    }

    public static FlashcardResponse flashcardResponse(
            Long flashcardId,
            Long deckId,
            String frontText,
            String backText,
            String frontLangCode,
            String backLangCode,
            String pronunciation,
            String note,
            Boolean isBookmarked) {
        return new FlashcardResponse(
                flashcardId,
                deckId,
                frontText,
                backText,
                frontLangCode,
                backLangCode,
                pronunciation,
                note,
                isBookmarked,
                new AuditMetadataResponse(
                        Instant.parse("2026-01-01T00:00:00Z"),
                        Instant.parse("2026-01-02T00:00:00Z")));
    }

    public static FlashcardPageResponse flashcardPageResponse(
            List<FlashcardResponse> items,
            int page,
            int size,
            long totalElements,
            int totalPages,
            boolean hasNext,
            boolean hasPrevious) {
        return new FlashcardPageResponse(items, page, size, totalElements, totalPages, hasNext, hasPrevious);
    }
}
