package com.lumos.deck.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.AuditMetadataResponse;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.service.DeckService;

@ExtendWith(MockitoExtension.class)
class DeckControllerTest {

    private static final Long FOLDER_ID = 11L;
    private static final Long DECK_ID = 22L;

    @Mock
    private DeckService deckService;

    @InjectMocks
    private DeckController deckController;

    @Test
    void createDeck_returnsCreatedResponse() {
        final var request = new CreateDeckRequest("Deck A", "Description");
        final var response = sampleDeckResponse();
        when(this.deckService.createDeck(FOLDER_ID, request)).thenReturn(response);

        final var entity = this.deckController.createDeck(FOLDER_ID, request);

        assertEquals(201, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateDeck_returnsOkResponse() {
        final var request = new UpdateDeckRequest("Deck B", "Description");
        final var response = sampleDeckResponse();
        when(this.deckService.updateDeck(FOLDER_ID, DECK_ID, request)).thenReturn(response);

        final var entity = this.deckController.updateDeck(FOLDER_ID, DECK_ID, request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void deleteDeck_returnsNoContentResponse() {
        final var entity = this.deckController.deleteDeck(FOLDER_ID, DECK_ID);

        verify(this.deckService).deleteDeck(FOLDER_ID, DECK_ID);
        assertEquals(204, entity.getStatusCode().value());
        assertNull(entity.getBody());
    }

    @Test
    void getDecks_returnsDeckList() {
        final var searchRequest = new SearchRequest("deck", SortBy.NAME, SortType.ASC);
        final var pageable = PageRequest.of(0, 20);
        final var response = List.of(sampleDeckResponse());
        when(this.deckService.getDecks(FOLDER_ID, searchRequest, pageable)).thenReturn(response);

        final var entity = this.deckController.getDecks(FOLDER_ID, searchRequest, pageable);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    private DeckResponse sampleDeckResponse() {
        return new DeckResponse(
                DECK_ID,
                FOLDER_ID,
                "Deck A",
                "Description",
                5,
                new AuditMetadataResponse(
                        Instant.parse("2026-01-01T00:00:00Z"),
                        Instant.parse("2026-01-02T00:00:00Z")));
    }
}
