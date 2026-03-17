package com.lumos.deck.service.impl;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.common.error.ErrorMessageKeys;
import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.DeckImportDeckDraft;
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.DeckImportResponse;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckImportFileInvalidException;
import com.lumos.deck.exception.DeckNameConflictException;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.exception.DeckParentHasSubfoldersException;
import com.lumos.deck.mapper.DeckMapper;
import com.lumos.deck.repository.DeckImportBatchRepository;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.deck.repository.specification.DeckSpecifications;
import com.lumos.deck.service.DeckService;
import com.lumos.deck.support.DeckExcelImportSupport;
import com.lumos.flashcard.constant.FlashcardConstants;
import com.lumos.flashcard.dto.FlashcardImportBatchCommand;
import com.lumos.flashcard.repository.FlashcardImportBatchRepository;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.folder.repository.FolderRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeckServiceImpl implements DeckService {

    private final DeckRepository deckRepository;
    private final DeckImportBatchRepository deckImportBatchRepository;
    private final FlashcardImportBatchRepository flashcardImportBatchRepository;
    private final FolderRepository folderRepository;
    private final DeckMapper deckMapper;
    private final DeckExcelImportSupport deckExcelImportSupport;

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

    /**
     * Import multiple decks from the provided Excel file into the target folder.
     *
     * @param folderId folder identifier
     * @param file     Excel import file
     * @return import summary response
     */
    @Override
    @Transactional
    public DeckImportResponse importDecks(Long folderId, MultipartFile file) {
        final var folder = this.findActiveFolder(folderId);
        this.validateFolderCanCreateDeck(folder.getId());
        final var deckDrafts = this.deckExcelImportSupport.parseExcelFile(file);
        final var importTimestamp = Instant.now();
        final var createdDeckCount = this.deckImportBatchRepository
                .insertDecksIgnoreConflicts(folderId, deckDrafts, importTimestamp);
        final var deckByNormalizedName = this.resolveDeckByNormalizedName(folderId, deckDrafts);
        final var flashcardCommands = this.toFlashcardImportBatchCommands(deckDrafts, deckByNormalizedName);
        final var importedFlashcardCount = this.flashcardImportBatchRepository
                .insertFlashcards(flashcardCommands, importTimestamp);
        final var flashcardCountByDeckId = this.resolveFlashcardCountByDeckId(flashcardCommands);
        this.deckImportBatchRepository.incrementFlashcardCounts(flashcardCountByDeckId, importTimestamp);
        // Return the import summary so the client can refresh deck and flashcard counts together.
        return this.deckMapper.toDeckImportResponse(
                folderId,
                deckDrafts.size(),
                createdDeckCount,
                importedFlashcardCount);
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

    private String normalizeLookupKey(String value) {
        // Return the lower-case lookup key so deck-name conflict checks stay case-insensitive.
        return StringUtils.lowerCase(value);
    }

    private Map<String, Deck> resolveDeckByNormalizedName(Long folderId, List<DeckImportDeckDraft> deckDrafts) {
        final var normalizedNames = new java.util.ArrayList<String>();
        // Collect normalized deck names so the follow-up lookup resolves both new and existing decks.
        for (DeckImportDeckDraft deckDraft : deckDrafts) {
            normalizedNames.add(this.normalizeLookupKey(deckDraft.name()));
        }
        final var decks = this.deckRepository.findAllActiveByFolderIdAndNormalizedNames(folderId, normalizedNames);
        final Map<String, Deck> deckByNormalizedName = new LinkedHashMap<>();
        // Re-index resolved deck entities by normalized name so flashcard rows can attach to deck ids quickly.
        for (Deck deck : decks) {
            deckByNormalizedName.put(this.normalizeLookupKey(deck.getName()), deck);
        }
        // Return the resolved deck map when every imported deck name exists after the insert-or-ignore step.
        if (deckByNormalizedName.size() == deckDrafts.size()) {
            // Return the resolved deck map so downstream flashcard batching can use stable deck ids.
            return deckByNormalizedName;
        }
        // Stop immediately because flashcard rows cannot be assigned when any deck id is unresolved.
        throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_READ_FAILED);
    }

    private List<FlashcardImportBatchCommand> toFlashcardImportBatchCommands(
            List<DeckImportDeckDraft> deckDrafts,
            Map<String, Deck> deckByNormalizedName) {
        final var flashcardCommands = new java.util.ArrayList<FlashcardImportBatchCommand>();
        // Walk each imported deck section to turn grouped flashcard rows into batch-insert commands.
        for (DeckImportDeckDraft deckDraft : deckDrafts) {
            final var normalizedDeckName = this.normalizeLookupKey(deckDraft.name());
            final var deck = deckByNormalizedName.get(normalizedDeckName);
            // Stop immediately because every flashcard row must resolve to a persisted deck id.
            if (deck == null) {
                // Reject the import because the deck resolution step did not yield a deck id for this section.
                throw new DeckImportFileInvalidException(ErrorMessageKeys.DECK_IMPORT_READ_FAILED);
            }
            this.addFlashcardImportCommands(flashcardCommands, deck, deckDraft);
        }
        // Return the flattened flashcard batch commands so JDBC batching can persist them efficiently.
        return flashcardCommands;
    }

    private Map<Long, Integer> resolveFlashcardCountByDeckId(List<FlashcardImportBatchCommand> flashcardCommands) {
        final Map<Long, Integer> flashcardCountByDeckId = new LinkedHashMap<>();
        // Aggregate imported flashcard counts by deck id so deck counters update once per deck.
        for (FlashcardImportBatchCommand flashcardCommand : flashcardCommands) {
            final var currentCount = flashcardCountByDeckId.getOrDefault(
                    flashcardCommand.deckId(),
                    DeckConstants.FLASHCARD_COUNT_DEFAULT);
            flashcardCountByDeckId.put(flashcardCommand.deckId(), currentCount + 1);
        }
        // Return the aggregated deck counts so deck counter updates stay batched and deterministic.
        return flashcardCountByDeckId;
    }

    private void addFlashcardImportCommands(
            List<FlashcardImportBatchCommand> flashcardCommands,
            Deck deck,
            DeckImportDeckDraft deckDraft) {
        // Append every flashcard row in the current deck section as one JDBC batch command.
        for (var flashcardDraft : deckDraft.flashcards()) {
            flashcardCommands.add(new FlashcardImportBatchCommand(
                    deck.getId(),
                    flashcardDraft.term(),
                    flashcardDraft.meaning(),
                    DeckImportConstants.TERM_LANGUAGE_CODE_DEFAULT.name(),
                    DeckImportConstants.MEANING_LANGUAGE_CODE_DEFAULT.name(),
                    FlashcardConstants.EMPTY_TEXT,
                    FlashcardConstants.EMPTY_TEXT,
                    FlashcardConstants.DEFAULT_IS_BOOKMARKED));
        }
    }
}
