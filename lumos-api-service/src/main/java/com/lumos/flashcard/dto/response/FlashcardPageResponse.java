package com.lumos.flashcard.dto.response;

import java.util.List;

public record FlashcardPageResponse(
        List<FlashcardResponse> items,
        int page,
        int size,
        long totalElements,
        int totalPages,
        boolean hasNext,
        boolean hasPrevious) {
}
