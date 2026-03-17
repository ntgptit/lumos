package com.lumos.deck.dto;

public record DeckImportFlashcardDraft(
        String term,
        String meaning,
        Integer rowNumber) {
}
