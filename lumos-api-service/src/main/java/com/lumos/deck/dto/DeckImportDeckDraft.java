package com.lumos.deck.dto;

import java.util.List;

public record DeckImportDeckDraft(
        String name,
        Integer rowNumber,
        List<DeckImportFlashcardDraft> flashcards) {
}
