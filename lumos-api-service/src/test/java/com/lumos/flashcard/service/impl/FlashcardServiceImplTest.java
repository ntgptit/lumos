package com.lumos.flashcard.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static com.lumos.testkit.FlashcardTestFixtures.createFlashcardRequest;
import static com.lumos.testkit.FlashcardTestFixtures.flashcardResponse;
import static com.lumos.testkit.FlashcardTestFixtures.updateFlashcardRequest;
import static com.lumos.testkit.SearchRequestFixtures.byFrontTextAsc;
import static com.lumos.testkit.SearchRequestFixtures.empty;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;

import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.flashcard.constant.FlashcardConstants;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.flashcard.exception.FlashcardNotFoundException;
import com.lumos.flashcard.mapper.FlashcardMapper;
import com.lumos.flashcard.repository.FlashcardRepository;

@ExtendWith(MockitoExtension.class)
class FlashcardServiceImplTest {

    private static final Long DECK_ID = 10L;
    private static final Long FLASHCARD_ID = 11L;

    @Mock
    private FlashcardRepository flashcardRepository;

    @Mock
    private DeckRepository deckRepository;

    @Mock
    private FlashcardMapper flashcardMapper;

    @InjectMocks
    private FlashcardServiceImpl flashcardService;

    @Test
    void createFlashcard_createsFlashcardWithNormalizedFields() {
        final var deck = deck(DECK_ID);
        final var request = createFlashcardRequest("  Front A  ", "  Back A  ", "  en  ", "  vi  ");
        final var mappedFlashcard = flashcard(deck, FLASHCARD_ID, "Front A", "Back A");
        final var response = flashcardResponse();
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.flashcardMapper.toFlashcardEntity(
                deck,
                "Front A",
                "Back A",
                "en",
                "vi",
                FlashcardConstants.EMPTY_TEXT,
                FlashcardConstants.EMPTY_TEXT,
                FlashcardConstants.DEFAULT_IS_BOOKMARKED)).thenReturn(mappedFlashcard);
        when(this.flashcardRepository.save(mappedFlashcard)).thenReturn(mappedFlashcard);
        when(this.flashcardMapper.toFlashcardResponse(mappedFlashcard)).thenReturn(response);

        final var result = this.flashcardService.createFlashcard(DECK_ID, request);

        assertEquals(response, result);
        final var instantCaptor = ArgumentCaptor.forClass(Instant.class);
        verify(this.deckRepository).adjustFlashcardCount(eq(DECK_ID), eq(1), instantCaptor.capture());
    }

    @Test
    void createFlashcard_whenDeckMissing_throwsDeckNotFoundException() {
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.empty());
        final var request = createFlashcardRequest("Front A", "Back A", null, null);

        assertThrows(DeckNotFoundException.class, () -> this.flashcardService.createFlashcard(DECK_ID, request));
        verifyNoInteractions(this.flashcardRepository);
    }

    @Test
    void updateFlashcard_updatesNormalizedFields() {
        final var deck = deck(DECK_ID);
        final var flashcard = flashcard(deck, FLASHCARD_ID, "Front A", "Back A");
        final var request = updateFlashcardRequest("  Front B  ", "  Back B  ", "  en  ", "  vi  ");
        when(this.flashcardRepository.findByIdAndDeletedAtIsNull(FLASHCARD_ID)).thenReturn(Optional.of(flashcard));
        when(this.flashcardMapper.toFlashcardResponse(flashcard)).thenReturn(flashcardResponse());

        this.flashcardService.updateFlashcard(DECK_ID, FLASHCARD_ID, request);

        assertEquals("Front B", flashcard.getFrontText());
        assertEquals("Back B", flashcard.getBackText());
        assertEquals("en", flashcard.getFrontLangCode());
        assertEquals("vi", flashcard.getBackLangCode());
    }

    @Test
    void updateFlashcard_whenScopeMismatch_throwsFlashcardNotFoundException() {
        final var otherDeck = deck(99L);
        final var flashcard = flashcard(otherDeck, FLASHCARD_ID, "Front A", "Back A");
        when(this.flashcardRepository.findByIdAndDeletedAtIsNull(FLASHCARD_ID)).thenReturn(Optional.of(flashcard));
        final var request = updateFlashcardRequest("Front B", "Back B", null, null);

        assertThrows(
                FlashcardNotFoundException.class,
                () -> this.flashcardService.updateFlashcard(DECK_ID, FLASHCARD_ID, request));
    }

    @Test
    void deleteFlashcard_softDeletesFlashcardAndDecrementsCount() {
        final var deck = deck(DECK_ID);
        final var flashcard = flashcard(deck, FLASHCARD_ID, "Front A", "Back A");
        when(this.flashcardRepository.findByIdAndDeletedAtIsNull(FLASHCARD_ID)).thenReturn(Optional.of(flashcard));

        this.flashcardService.deleteFlashcard(DECK_ID, FLASHCARD_ID);

        final var instantCaptor = ArgumentCaptor.forClass(Instant.class);
        verify(this.flashcardRepository).softDeleteFlashcard(eq(DECK_ID), eq(FLASHCARD_ID), instantCaptor.capture());
        verify(this.deckRepository).adjustFlashcardCount(eq(DECK_ID), eq(-1), any(Instant.class));
    }

    @Test
    void getFlashcards_returnsPagedResponse() {
        final var deck = deck(DECK_ID);
        final var flashcard = flashcard(deck, FLASHCARD_ID, "Front A", "Back A");
        final var searchRequest = byFrontTextAsc("front");
        final var pageable = PageRequest.of(0, 10);
        final var response = flashcardResponse();
        final var pageResponse = com.lumos.testkit.FlashcardTestFixtures.flashcardPageResponse(
                List.of(response),
                0,
                10,
                1,
                1,
                false,
                false);
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.flashcardRepository.findAll(any(Specification.class), any(PageRequest.class)))
                .thenReturn(new PageImpl<>(List.of(flashcard), pageable, 1));
        when(this.flashcardMapper.toFlashcardResponse(flashcard)).thenReturn(response);
        when(this.flashcardMapper.toFlashcardPageResponse(List.of(response), 0, 10, 1, 1, false, false))
                .thenReturn(pageResponse);

        final FlashcardPageResponse result = this.flashcardService.getFlashcards(DECK_ID, searchRequest, pageable);

        assertEquals(1, result.items().size());
        assertEquals(response, result.items().get(0));
        assertEquals(1, result.totalElements());
    }

    @Test
    void getFlashcards_whenDeckMissing_throwsDeckNotFoundException() {
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.empty());
        final var searchRequest = empty();
        final var pageable = PageRequest.of(0, 10);

        assertThrows(
                DeckNotFoundException.class,
                () -> this.flashcardService.getFlashcards(DECK_ID, searchRequest, pageable));
    }

    private Deck deck(Long deckId) {
        final var deck = new Deck();
        deck.setId(deckId);
        return deck;
    }

    private Flashcard flashcard(Deck deck, Long id, String frontText, String backText) {
        final var flashcard = new Flashcard();
        flashcard.setId(id);
        flashcard.setDeck(deck);
        flashcard.setFrontText(frontText);
        flashcard.setBackText(backText);
        flashcard.setFrontLangCode(null);
        flashcard.setBackLangCode(null);
        flashcard.setPronunciation("");
        flashcard.setNote("");
        flashcard.setIsBookmarked(false);
        return flashcard;
    }

    private FlashcardResponse flashcardResponse() {
        return com.lumos.testkit.FlashcardTestFixtures.flashcardResponse(
                FLASHCARD_ID,
                DECK_ID,
                "Front A",
                "Back A",
                null,
                null,
                "",
                "",
                false);
    }
}
