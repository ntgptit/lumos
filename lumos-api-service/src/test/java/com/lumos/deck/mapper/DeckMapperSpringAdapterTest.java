package com.lumos.deck.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.time.Instant;

import org.junit.jupiter.api.Test;

import com.lumos.deck.entity.Deck;
import com.lumos.folder.entity.Folder;

class DeckMapperSpringAdapterTest {

    private final DeckMapperSpringAdapter mapper = new DeckMapperSpringAdapter();

    @Test
    void toDeckResponse_mapsEntityFields() {
        final var folder = new Folder();
        folder.setId(9L);
        final var deck = new Deck();
        deck.setId(5L);
        deck.setFolder(folder);
        deck.setName("Deck Name");
        deck.setDescription("Deck Description");
        deck.setFlashcardCount(15);
        deck.setCreatedAt(Instant.parse("2026-01-01T00:00:00Z"));
        deck.setUpdatedAt(Instant.parse("2026-01-02T00:00:00Z"));

        final var response = this.mapper.toDeckResponse(deck);

        assertEquals(5L, response.id());
        assertEquals(9L, response.folderId());
        assertEquals("Deck Name", response.name());
        assertEquals("Deck Description", response.description());
        assertEquals(15, response.flashcardCount());
        assertNotNull(response.audit());
        assertEquals(deck.getCreatedAt(), response.audit().createdAt());
        assertEquals(deck.getUpdatedAt(), response.audit().updatedAt());
    }

    @Test
    void toDeckResponse_handlesNullFolder() {
        final var deck = new Deck();
        deck.setId(5L);
        deck.setName("Deck Name");
        deck.setDescription("Deck Description");
        deck.setFlashcardCount(10);

        final var response = this.mapper.toDeckResponse(deck);

        assertNull(response.folderId());
    }

    @Test
    void toDeckEntity_mapsArgumentsToEntity() {
        final var folder = new Folder();
        folder.setId(10L);

        final var deck = this.mapper.toDeckEntity(folder, "Deck A", "Description", 0);

        assertEquals(folder, deck.getFolder());
        assertEquals("Deck A", deck.getName());
        assertEquals("Description", deck.getDescription());
        assertEquals(0, deck.getFlashcardCount());
    }
}
