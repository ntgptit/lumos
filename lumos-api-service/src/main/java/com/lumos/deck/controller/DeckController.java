package com.lumos.deck.controller;

import java.util.List;

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
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.service.DeckService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

/**
 * Deck management endpoints.
 */
@Validated
@RestController
@Tag(name = "Decks", description = "Deck management APIs")
@RequiredArgsConstructor
@RequestMapping("/api/v1/folders/{folderId}/decks")
public class DeckController {

    private final DeckService deckService;

    /**
     * Create a deck in the target folder.
     *
     * @param folderId parent folder identifier
     * @param request  create deck payload
     * @return created deck response
     */
    @Operation(summary = "Create deck")
    @PostMapping
    public ResponseEntity<DeckResponse> createDeck(@PathVariable Long folderId,
            @Valid @RequestBody CreateDeckRequest request) {
        final var deck = this.deckService.createDeck(folderId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(deck);
    }

    /**
     * Update deck metadata.
     *
     * @param folderId parent folder identifier
     * @param deckId   deck identifier
     * @param request  update deck payload
     * @return updated deck response
     */
    @Operation(summary = "Update deck")
    @PutMapping("/{deckId}")
    public ResponseEntity<DeckResponse> updateDeck(@PathVariable Long folderId, @PathVariable Long deckId,
            @Valid @RequestBody UpdateDeckRequest request) {
        final var deck = this.deckService.updateDeck(folderId, deckId, request);
        return ResponseEntity.ok(deck);
    }

    /**
     * Soft delete a deck.
     *
     * @param folderId parent folder identifier
     * @param deckId   deck identifier
     * @return empty response
     */
    @Operation(summary = "Soft delete deck")
    @DeleteMapping("/{deckId}")
    public ResponseEntity<Void> deleteDeck(@PathVariable Long folderId, @PathVariable Long deckId) {
        this.deckService.deleteDeck(folderId, deckId);
        return ResponseEntity.noContent().build();
    }

    /**
     * Get paginated decks in a folder.
     *
     * @param folderId      parent folder identifier
     * @param searchRequest common search request
     * @param pageable      pagination options
     * @return paged deck response
     */
    @Operation(summary = "Get decks by folder")
    @GetMapping
    public ResponseEntity<List<DeckResponse>> getDecks(@PathVariable Long folderId, @ModelAttribute SearchRequest searchRequest,
            Pageable pageable) {
        final var decks = this.deckService.getDecks(folderId, searchRequest, pageable);
        return ResponseEntity.ok(decks);
    }
}
