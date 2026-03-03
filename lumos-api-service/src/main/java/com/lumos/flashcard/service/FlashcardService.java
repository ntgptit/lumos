package com.lumos.flashcard.service;

import org.springframework.data.domain.Pageable;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.flashcard.dto.request.CreateFlashcardRequest;
import com.lumos.flashcard.dto.request.UpdateFlashcardRequest;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;

public interface FlashcardService {

    FlashcardResponse createFlashcard(Long deckId, CreateFlashcardRequest request);

    FlashcardResponse updateFlashcard(Long deckId, Long flashcardId, UpdateFlashcardRequest request);

    void deleteFlashcard(Long deckId, Long flashcardId);

    FlashcardPageResponse getFlashcards(Long deckId, SearchRequest searchRequest, Pageable pageable);
}
