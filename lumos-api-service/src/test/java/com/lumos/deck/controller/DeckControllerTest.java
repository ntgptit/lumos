package com.lumos.deck.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static com.lumos.testkit.DeckTestFixtures.createDeckRequest;
import static com.lumos.testkit.DeckTestFixtures.deckImportResponse;
import static com.lumos.testkit.DeckTestFixtures.deckResponse;
import static com.lumos.testkit.DeckTestFixtures.updateDeckRequest;
import static com.lumos.testkit.SearchRequestFixtures.byNameAsc;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;
import org.springframework.mock.web.MockMultipartFile;

import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.response.DeckImportResponse;
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
        final var request = createDeckRequest("Deck A", "Description");
        final var response = sampleDeckResponse();
        when(this.deckService.createDeck(FOLDER_ID, request)).thenReturn(response);

        final var entity = this.deckController.createDeck(FOLDER_ID, request);

        assertEquals(201, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateDeck_returnsOkResponse() {
        final var request = updateDeckRequest("Deck B", "Description");
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
        final var searchRequest = byNameAsc("deck");
        final var pageable = PageRequest.of(0, 20);
        final var response = List.of(sampleDeckResponse());
        when(this.deckService.getDecks(FOLDER_ID, searchRequest, pageable)).thenReturn(response);

        final var entity = this.deckController.getDecks(FOLDER_ID, searchRequest, pageable);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void importDecks_returnsOkResponse() {
        final var file = new MockMultipartFile(
                DeckImportConstants.FILE_PARAM_NAME,
                "decks.xlsx",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                new byte[] { 1 });
        final DeckImportResponse response = deckImportResponse(FOLDER_ID, 2, 1, 5);
        when(this.deckService.importDecks(FOLDER_ID, file)).thenReturn(response);

        final var entity = this.deckController.importDecks(FOLDER_ID, file);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    private DeckResponse sampleDeckResponse() {
        
        return deckResponse(
                DECK_ID,
                FOLDER_ID,
                "Deck A",
                "Description",
                5);
    }
}
