package com.lumos.flashcard.service.impl;

import java.time.Instant;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.flashcard.constant.FlashcardConstants;
import com.lumos.flashcard.dto.request.CreateFlashcardRequest;
import com.lumos.flashcard.dto.request.UpdateFlashcardRequest;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.flashcard.exception.FlashcardNotFoundException;
import com.lumos.flashcard.mapper.FlashcardMapper;
import com.lumos.flashcard.repository.FlashcardRepository;
import com.lumos.flashcard.repository.specification.FlashcardSpecifications;
import com.lumos.flashcard.service.FlashcardService;
import com.lumos.study.support.StudySessionFlashcardCleanupSupport;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashcardServiceImpl implements FlashcardService {

    private static final int FLASHCARD_COUNT_DELTA_CREATE = 1;
    private static final int FLASHCARD_COUNT_DELTA_DELETE = -1;

    private final FlashcardRepository flashcardRepository;
    private final DeckRepository deckRepository;
    private final FlashcardMapper flashcardMapper;
    private final StudySessionFlashcardCleanupSupport studySessionFlashcardCleanupSupport;

    /**
     * Create a flashcard in the target deck.
     *
     * @param deckId  parent deck identifier
     * @param request create payload
     * @return created flashcard response
     */
    @Override
    @Transactional
    public FlashcardResponse createFlashcard(Long deckId, CreateFlashcardRequest request) {
        final var deck = this.findActiveDeck(deckId);

        final var normalizedFrontText = this.normalizeRequiredText(request.frontText());
        final var normalizedBackText = this.normalizeRequiredText(request.backText());
        final var normalizedFrontLangCode = this.normalizeOptionalLanguageCode(request.frontLangCode());
        final var normalizedBackLangCode = this.normalizeOptionalLanguageCode(request.backLangCode());

        final var flashcard = this.flashcardMapper.toFlashcardEntity(
                deck,
                normalizedFrontText,
                normalizedBackText,
                normalizedFrontLangCode,
                normalizedBackLangCode,
                FlashcardConstants.EMPTY_TEXT,
                FlashcardConstants.EMPTY_TEXT,
                FlashcardConstants.DEFAULT_IS_BOOKMARKED);
        final var savedFlashcard = this.flashcardRepository.save(flashcard);
        this.deckRepository.adjustFlashcardCount(deckId, FLASHCARD_COUNT_DELTA_CREATE, Instant.now());
        // Return the created flashcard DTO after the deck count has been incremented.
        return this.flashcardMapper.toFlashcardResponse(savedFlashcard);
    }

    /**
     * Update flashcard payload.
     *
     * @param deckId     parent deck identifier
     * @param flashcardId flashcard identifier
     * @param request    update payload
     * @return updated flashcard response
     */
    @Override
    @Transactional
    public FlashcardResponse updateFlashcard(Long deckId, Long flashcardId, UpdateFlashcardRequest request) {
        final var flashcard = this.findActiveFlashcard(deckId, flashcardId);

        final var normalizedFrontText = this.normalizeRequiredText(request.frontText());
        final var normalizedBackText = this.normalizeRequiredText(request.backText());
        final var normalizedFrontLangCode = this.normalizeOptionalLanguageCode(request.frontLangCode());
        final var normalizedBackLangCode = this.normalizeOptionalLanguageCode(request.backLangCode());

        flashcard.setFrontText(normalizedFrontText);
        flashcard.setBackText(normalizedBackText);
        flashcard.setFrontLangCode(normalizedFrontLangCode);
        flashcard.setBackLangCode(normalizedBackLangCode);
        // Return the updated flashcard DTO so the client sees normalized multilingual fields.
        return this.flashcardMapper.toFlashcardResponse(flashcard);
    }

    /**
     * Soft delete flashcard in deck scope.
     *
     * @param deckId      parent deck identifier
     * @param flashcardId flashcard identifier
     */
    @Override
    @Transactional
    public void deleteFlashcard(Long deckId, Long flashcardId) {
        final Instant deletedAt = Instant.now();
        this.findActiveFlashcard(deckId, flashcardId);
        this.studySessionFlashcardCleanupSupport.removeFlashcardFromAllModes(flashcardId, deletedAt);
        this.flashcardRepository.softDeleteFlashcard(deckId, flashcardId, deletedAt);
        this.deckRepository.adjustFlashcardCount(deckId, FLASHCARD_COUNT_DELTA_DELETE, deletedAt);
    }

    /**
     * Get paginated flashcards by deck.
     *
     * @param deckId        parent deck identifier
     * @param searchRequest common search request
     * @param pageable      pagination options
     * @return paged flashcard response
     */
    @Override
    @Transactional(readOnly = true)
    public FlashcardPageResponse getFlashcards(Long deckId, SearchRequest searchRequest, Pageable pageable) {
        this.findActiveDeck(deckId);

        final var specification = FlashcardSpecifications.byDeckAndKeyword(deckId, searchRequest.searchQuery());
        final var sortedPageable = FlashcardSpecifications.toSortedPageable(
                pageable,
                searchRequest.sortBy(),
                searchRequest.sortType());
        final var page = this.flashcardRepository.findAll(specification, sortedPageable);
        // Map the requested page to DTOs before attaching paging metadata for the flashcard screen.
        final var items = page.getContent().stream().map(this.flashcardMapper::toFlashcardResponse).toList();
        // Return the paged flashcard payload that combines mapped items with repository paging metadata.
        return this.flashcardMapper.toFlashcardPageResponse(
                items,
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages(),
                page.hasNext(),
                page.hasPrevious());
    }

    private Deck findActiveDeck(Long deckId) {
        // Return the active deck or fail so flashcard mutations stay scoped to an existing deck.
        return this.deckRepository.findByIdAndDeletedAtIsNull(deckId).orElseThrow(() -> new DeckNotFoundException(deckId));
    }

    private Flashcard findActiveFlashcard(Long deckId, Long flashcardId) {
        final var flashcard = this.flashcardRepository.findByIdAndDeletedAtIsNull(flashcardId)
                .orElseThrow(() -> new FlashcardNotFoundException(flashcardId));
        final var flashcardDeckId = flashcard.getDeck().getId();
        // Ensure flashcard belongs to the requested deck scope.
        if (flashcardDeckId != null && deckId != null && flashcardDeckId.longValue() == deckId.longValue()) {
            // Return the flashcard only when it belongs to the deck selected by the request path.
            return flashcard;
        }
        // Hide flashcards outside the requested deck scope so ids cannot be resolved across decks.
        throw new FlashcardNotFoundException(flashcardId);
    }

    private String normalizeRequiredText(String value) {
        // Return the trimmed study text so answer matching ignores accidental outer whitespace.
        return StringUtils.trim(value);
    }

    private String normalizeOptionalLanguageCode(String value) {
        // Persist null when optional language code is blank.
        if (StringUtils.isBlank(value)) {
            // Return null so optional language metadata is omitted instead of stored as blank text.
            return null;
        }
        // Return the trimmed language code so locale metadata stays normalized.
        return StringUtils.trim(value);
    }
}
