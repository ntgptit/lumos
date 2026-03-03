package com.lumos.flashcard.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.time.Instant;

import org.junit.jupiter.api.Test;

import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.entity.Flashcard;

class FlashcardMapperSpringAdapterTest {

    private final FlashcardMapperSpringAdapter mapper = new FlashcardMapperSpringAdapter();

    @Test
    void toFlashcardResponse_mapsEntityFields() {
        final var deck = new Deck();
        deck.setId(9L);
        final var flashcard = new Flashcard();
        flashcard.setId(5L);
        flashcard.setDeck(deck);
        flashcard.setFrontText("Front");
        flashcard.setBackText("Back");
        flashcard.setFrontLangCode("en");
        flashcard.setBackLangCode("vi");
        flashcard.setPronunciation("/front/");
        flashcard.setNote("note");
        flashcard.setIsBookmarked(true);
        flashcard.setCreatedAt(Instant.parse("2026-01-01T00:00:00Z"));
        flashcard.setUpdatedAt(Instant.parse("2026-01-02T00:00:00Z"));

        final var response = this.mapper.toFlashcardResponse(flashcard);

        assertEquals(5L, response.id());
        assertEquals(9L, response.deckId());
        assertEquals("Front", response.frontText());
        assertEquals("Back", response.backText());
        assertEquals("en", response.frontLangCode());
        assertEquals("vi", response.backLangCode());
        assertEquals("/front/", response.pronunciation());
        assertEquals("note", response.note());
        assertEquals(true, response.isBookmarked());
        assertNotNull(response.audit());
        assertEquals(flashcard.getCreatedAt(), response.audit().createdAt());
        assertEquals(flashcard.getUpdatedAt(), response.audit().updatedAt());
    }

    @Test
    void toFlashcardResponse_handlesNullDeck() {
        final var flashcard = new Flashcard();
        flashcard.setId(5L);
        flashcard.setFrontText("Front");
        flashcard.setBackText("Back");
        flashcard.setPronunciation("");
        flashcard.setNote("");
        flashcard.setIsBookmarked(false);

        final var response = this.mapper.toFlashcardResponse(flashcard);

        assertNull(response.deckId());
    }

    @Test
    void toFlashcardEntity_mapsArgumentsToEntity() {
        final var deck = new Deck();
        deck.setId(10L);

        final var flashcard = this.mapper.toFlashcardEntity(
                deck,
                "Front A",
                "Back A",
                "en",
                "vi",
                "",
                "",
                false);

        assertEquals(deck, flashcard.getDeck());
        assertEquals("Front A", flashcard.getFrontText());
        assertEquals("Back A", flashcard.getBackText());
        assertEquals("en", flashcard.getFrontLangCode());
        assertEquals("vi", flashcard.getBackLangCode());
        assertEquals("", flashcard.getPronunciation());
        assertEquals("", flashcard.getNote());
        assertEquals(false, flashcard.getIsBookmarked());
    }
}
