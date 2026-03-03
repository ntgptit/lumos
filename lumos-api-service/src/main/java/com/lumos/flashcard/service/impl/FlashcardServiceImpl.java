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

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FlashcardServiceImpl implements FlashcardService {

    private static final int FLASHCARD_COUNT_DELTA_CREATE = 1;
    private static final int FLASHCARD_COUNT_DELTA_DELETE = -1;

    private final FlashcardRepository flashcardRepository;
    private final DeckRepository deckRepository;
    private final FlashcardMapper flashcardMapper;

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
        this.findActiveFlashcard(deckId, flashcardId);
        this.flashcardRepository.softDeleteFlashcard(deckId, flashcardId, Instant.now());
        this.deckRepository.adjustFlashcardCount(deckId, FLASHCARD_COUNT_DELTA_DELETE, Instant.now());
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
        final var items = page.getContent().stream().map(this.flashcardMapper::toFlashcardResponse).toList();
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
        return this.deckRepository.findByIdAndDeletedAtIsNull(deckId).orElseThrow(() -> new DeckNotFoundException(deckId));
    }

    private Flashcard findActiveFlashcard(Long deckId, Long flashcardId) {
        final var flashcard = this.flashcardRepository.findByIdAndDeletedAtIsNull(flashcardId)
                .orElseThrow(() -> new FlashcardNotFoundException(flashcardId));
        final var flashcardDeckId = flashcard.getDeck().getId();
        // Ensure flashcard belongs to the requested deck scope.
        if (flashcardDeckId != null && deckId != null && flashcardDeckId.longValue() == deckId.longValue()) {
            return flashcard;
        }
        throw new FlashcardNotFoundException(flashcardId);
    }

    private String normalizeRequiredText(String value) {
        return StringUtils.trim(value);
    }

    private String normalizeOptionalLanguageCode(String value) {
        // Persist null when optional language code is blank.
        if (StringUtils.isBlank(value)) {
            return null;
        }
        return StringUtils.trim(value);
    }
}
