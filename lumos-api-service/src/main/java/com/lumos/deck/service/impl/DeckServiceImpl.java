package com.lumos.deck.service.impl;

import java.time.Instant;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckNameConflictException;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.exception.DeckParentHasSubfoldersException;
import com.lumos.deck.mapper.DeckMapper;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.deck.repository.specification.DeckSpecifications;
import com.lumos.deck.service.DeckService;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.folder.repository.FolderRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeckServiceImpl implements DeckService {

    private final DeckRepository deckRepository;
    private final FolderRepository folderRepository;
    private final DeckMapper deckMapper;

    /**
     * Create a deck in a folder.
     *
     * @param folderId folder identifier
     * @param request  create deck payload
     * @return created deck response
     */
    @Override
    @Transactional
    public DeckResponse createDeck(Long folderId, CreateDeckRequest request) {
        final var folder = this.findActiveFolder(folderId);
        this.validateFolderCanCreateDeck(folder.getId());

        final var normalizedName = StringUtils.trim(request.name());
        final var normalizedDescription = this.normalizeDescription(request.description());
        this.validateDeckName(folder.getId(), normalizedName, null);

        final var deck = this.deckMapper.toDeckEntity(
                folder,
                normalizedName,
                normalizedDescription,
                DeckConstants.FLASHCARD_COUNT_DEFAULT);
        final var savedDeck = this.deckRepository.save(deck);
        // Return the freshly created deck DTO after persistence has assigned its canonical state.
        return this.deckMapper.toDeckResponse(savedDeck);
    }

    /**
     * Update deck metadata.
     *
     * @param folderId folder identifier
     * @param deckId   deck identifier
     * @param request  update deck payload
     * @return updated deck response
     */
    @Override
    @Transactional
    public DeckResponse updateDeck(Long folderId, Long deckId, UpdateDeckRequest request) {
        final var deck = this.findActiveDeck(folderId, deckId);

        final var normalizedName = StringUtils.trim(request.name());
        final var normalizedDescription = this.normalizeDescription(request.description());
        this.validateDeckName(folderId, normalizedName, deck.getId());

        deck.setName(normalizedName);
        deck.setDescription(normalizedDescription);
        // Return the updated deck DTO so the client sees normalized values from the managed entity.
        return this.deckMapper.toDeckResponse(deck);
    }

    /**
     * Soft delete a deck.
     *
     * @param folderId folder identifier
     * @param deckId   deck identifier
     */
    @Override
    @Transactional
    public void deleteDeck(Long folderId, Long deckId) {
        this.findActiveDeck(folderId, deckId);
        this.deckRepository.softDeleteDeck(folderId, deckId, Instant.now());
    }

    /**
     * Get paginated decks in a folder.
     *
     * @param folderId      folder identifier
     * @param searchRequest common search request
     * @param pageable      pagination options
     * @return paged deck response
     */
    @Override
    @Transactional(readOnly = true)
    public List<DeckResponse> getDecks(Long folderId, SearchRequest searchRequest, Pageable pageable) {
        this.findActiveFolder(folderId);

        final var specification = DeckSpecifications.byFolderAndKeyword(folderId, searchRequest.searchQuery());
        final var sortedPageable = DeckSpecifications.toSortedPageable(pageable, searchRequest.sortBy(),
                searchRequest.sortType());
        final var page = this.deckRepository.findAll(specification, sortedPageable);
        
        // Convert page entities to API DTOs before returning them to the folder detail screen.
        return page.getContent().stream().map(this.deckMapper::toDeckResponse).toList();
    }

    private Folder findActiveFolder(Long folderId) {
        // Return the active folder or fail so deck operations never run against deleted or missing folders.
        return this.folderRepository.findByIdAndDeletedAtIsNull(folderId)
                .orElseThrow(() -> new FolderNotFoundException(folderId));
    }

    private Deck findActiveDeck(Long folderId, Long deckId) {
        final var deck = this.deckRepository.findByIdAndDeletedAtIsNull(deckId)
                .orElseThrow(() -> new DeckNotFoundException(deckId));
        final var deckFolderId = deck.getFolder().getId();
        // Ensure deck belongs to the requested folder scope.
        if (deckFolderId != null && folderId != null && deckFolderId.longValue() == folderId.longValue()) {
            // Return the deck only when the nested folder path matches the deck ownership.
            return deck;
        }
        // Hide decks outside the requested folder scope so callers cannot probe foreign deck ids.
        throw new DeckNotFoundException(deckId);
    }

    private void validateFolderCanCreateDeck(Long folderId) {
        final var hasChildFolders = this.folderRepository.existsByParentIdAndDeletedAtIsNull(folderId);
        // Deck creation is allowed only in leaf folders without subfolders.
        if (!hasChildFolders) {
            // Return without error because the folder is a valid leaf for deck creation.
            return;
        }
        // Prevent decks from being created in non-leaf folders because folders cannot mix decks and subfolders.
        throw new DeckParentHasSubfoldersException(folderId);
    }

    private void validateDeckName(Long folderId, String deckName, Long excludeDeckId) {
        final var exists = this.deckRepository.existsActiveNameByFolderId(folderId, deckName, excludeDeckId);
        // Reject duplicate deck name in the same folder scope.
        if (!exists) {
            // Return without error because the folder does not yet contain this deck name.
            return;
        }
        // Reject duplicate deck names inside the same folder to keep the deck list unambiguous.
        throw new DeckNameConflictException(deckName);
    }

    private String normalizeDescription(String description) {
        // Fallback to empty description when value is absent.
        if (description == null) {
            // Return the shared empty-description token so deck responses stay null-safe.
            return DeckConstants.EMPTY_DESCRIPTION;
        }
        // Return the trimmed description so storage does not preserve accidental outer whitespace.
        return StringUtils.trim(description);
    }
}
