package com.lumos.flashcard.controller;

import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.flashcard.dto.request.CreateFlashcardRequest;
import com.lumos.flashcard.dto.request.UpdateFlashcardRequest;
import com.lumos.flashcard.dto.response.FlashcardPageResponse;
import com.lumos.flashcard.dto.response.FlashcardResponse;
import com.lumos.flashcard.service.FlashcardService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

/**
 * Flashcard management endpoints.
 */
@Validated
@RestController
@Tag(name = "Flashcards", description = "Flashcard management APIs")
@RequiredArgsConstructor
@RequestMapping("/api/v1/decks/{deckId}/flashcards")
public class FlashcardController {

    private final FlashcardService flashcardService;

    /**
     * Create a flashcard in the target deck.
     *
     * @param deckId  parent deck identifier
     * @param request create flashcard payload
     * @return created flashcard response
     */
    @Operation(summary = "Create flashcard")
    @PostMapping
    public ResponseEntity<FlashcardResponse> createFlashcard(@PathVariable Long deckId,
            @Valid @RequestBody CreateFlashcardRequest request) {
        final var flashcard = this.flashcardService.createFlashcard(deckId, request);
        // Return the created flashcard payload so the deck detail screen can append it immediately.
        return ResponseEntity.status(HttpStatus.CREATED).body(flashcard);
    }

    /**
     * Update flashcard metadata.
     *
     * @param deckId      parent deck identifier
     * @param flashcardId flashcard identifier
     * @param request     update flashcard payload
     * @return updated flashcard response
     */
    @Operation(summary = "Update flashcard")
    @PutMapping("/{flashcardId}")
    public ResponseEntity<FlashcardResponse> updateFlashcard(
            @PathVariable Long deckId,
            @PathVariable Long flashcardId,
            @Valid @RequestBody UpdateFlashcardRequest request) {
        final var flashcard = this.flashcardService.updateFlashcard(deckId, flashcardId, request);
        // Return the updated flashcard payload so the editor reflects the saved card.
        return ResponseEntity.ok(flashcard);
    }

    /**
     * Soft delete a flashcard.
     *
     * @param deckId      parent deck identifier
     * @param flashcardId flashcard identifier
     * @return empty response
     */
    @Operation(summary = "Soft delete flashcard")
    @DeleteMapping("/{flashcardId}")
    public ResponseEntity<Void> deleteFlashcard(@PathVariable Long deckId, @PathVariable Long flashcardId) {
        this.flashcardService.deleteFlashcard(deckId, flashcardId);
        // Return no-content because the flashcard was removed and no body is required.
        return ResponseEntity.noContent().build();
    }

    /**
     * Get paginated flashcards by deck.
     *
     * @param deckId        parent deck identifier
     * @param searchRequest common search request
     * @param pageable      pagination options
     * @return paged flashcard response
     */
    @Operation(summary = "Get flashcards by deck")
    @GetMapping
    public ResponseEntity<FlashcardPageResponse> getFlashcards(
            @PathVariable Long deckId,
            @ModelAttribute SearchRequest searchRequest,
            Pageable pageable) {
        final var page = this.flashcardService.getFlashcards(deckId, searchRequest, pageable);
        // Return the paged flashcard payload for the selected deck.
        return ResponseEntity.ok(page);
    }
}
