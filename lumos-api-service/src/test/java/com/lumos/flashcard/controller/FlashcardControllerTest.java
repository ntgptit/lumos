package com.lumos.flashcard.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static com.lumos.testkit.FlashcardTestFixtures.createFlashcardRequest;
import static com.lumos.testkit.FlashcardTestFixtures.flashcardPageResponse;
import static com.lumos.testkit.FlashcardTestFixtures.flashcardResponse;
import static com.lumos.testkit.FlashcardTestFixtures.updateFlashcardRequest;
import static com.lumos.testkit.SearchRequestFixtures.byFrontTextAsc;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;

import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;
import com.lumos.flashcard.service.FlashcardService;

@ExtendWith(MockitoExtension.class)
class FlashcardControllerTest {

    private static final Long DECK_ID = 11L;
    private static final Long FLASHCARD_ID = 22L;

    @Mock
    private FlashcardService flashcardService;

    @InjectMocks
    private FlashcardController flashcardController;

    @Test
    void createFlashcard_returnsCreatedResponse() {
        final var request = createFlashcardRequest("Front", "Back", "en", "vi");
        final var response = sampleFlashcardResponse();
        when(this.flashcardService.createFlashcard(DECK_ID, request)).thenReturn(response);

        final var entity = this.flashcardController.createFlashcard(DECK_ID, request);

        assertEquals(201, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateFlashcard_returnsOkResponse() {
        final var request = updateFlashcardRequest("Front 2", "Back 2", null, null);
        final var response = sampleFlashcardResponse();
        when(this.flashcardService.updateFlashcard(DECK_ID, FLASHCARD_ID, request)).thenReturn(response);

        final var entity = this.flashcardController.updateFlashcard(DECK_ID, FLASHCARD_ID, request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void deleteFlashcard_returnsNoContentResponse() {
        final var entity = this.flashcardController.deleteFlashcard(DECK_ID, FLASHCARD_ID);

        verify(this.flashcardService).deleteFlashcard(DECK_ID, FLASHCARD_ID);
        assertEquals(204, entity.getStatusCode().value());
        assertNull(entity.getBody());
    }

    @Test
    void getFlashcards_returnsPagedResponse() {
        final var searchRequest = byFrontTextAsc("front");
        final var pageable = PageRequest.of(0, 20);
        final var response = flashcardPageResponse(
                List.of(sampleFlashcardResponse()),
                0,
                20,
                1,
                1,
                false,
                false);
        when(this.flashcardService.getFlashcards(DECK_ID, searchRequest, pageable)).thenReturn(response);

        final var entity = this.flashcardController.getFlashcards(DECK_ID, searchRequest, pageable);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    private FlashcardResponse sampleFlashcardResponse() {
        return flashcardResponse(
                FLASHCARD_ID,
                DECK_ID,
                "Front",
                "Back",
                "en",
                "vi",
                "",
                "",
                false);
    }
}
