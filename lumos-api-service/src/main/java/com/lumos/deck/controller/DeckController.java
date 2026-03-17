package com.lumos.deck.controller;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.DeckImportResponse;
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
        // Return the created deck payload so the folder screen can append the new deck immediately.
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
        // Return the updated deck payload so the client reflects the saved metadata.
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
        // Return no-content because the deck was deleted and no response body is needed.
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
        // Return the deck list page slice for the selected folder scope.
        return ResponseEntity.ok(decks);
    }

    /**
     * Import multiple decks from an Excel file into the target folder.
     *
     * @param folderId parent folder identifier
     * @param file     Excel import file
     * @return import summary response
     */
    @Operation(summary = "Import decks from Excel")
    @PostMapping(path = "/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<DeckImportResponse> importDecks(
            @PathVariable Long folderId,
            @RequestParam(DeckImportConstants.FILE_PARAM_NAME) MultipartFile file) {
        final var response = this.deckService.importDecks(folderId, file);
        // Return the synchronous import summary so the folder screen can refresh deck data afterward.
        return ResponseEntity.ok(response);
    }
}
