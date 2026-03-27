package com.lumos.deck.service.impl;

import static com.lumos.testkit.DeckTestFixtures.createDeckRequest;
import static com.lumos.testkit.DeckTestFixtures.deckImportResponse;
import static com.lumos.testkit.DeckTestFixtures.updateDeckRequest;
import static com.lumos.testkit.SearchRequestFixtures.byNameAsc;
import static com.lumos.testkit.SearchRequestFixtures.empty;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.mock.web.MockMultipartFile;

import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.constant.DeckImportConstants;
import com.lumos.deck.dto.DeckImportDeckDraft;
import com.lumos.deck.dto.DeckImportFlashcardDraft;
import com.lumos.deck.dto.response.DeckImportResponse;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckNameConflictException;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.exception.DeckParentHasSubfoldersException;
import com.lumos.deck.mapper.DeckMapper;
import com.lumos.deck.repository.DeckImportBatchRepository;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.deck.support.DeckExcelImportSupport;
import com.lumos.flashcard.repository.FlashcardImportBatchRepository;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.folder.repository.FolderRepository;

@ExtendWith(MockitoExtension.class)
class DeckServiceImplTest {

    private static final Long FOLDER_ID = 10L;
    private static final Long DECK_ID = 11L;

    @Mock
    private DeckRepository deckRepository;

    @Mock
    private DeckImportBatchRepository deckImportBatchRepository;

    @Mock
    private FolderRepository folderRepository;

    @Mock
    private FlashcardImportBatchRepository flashcardImportBatchRepository;

    @Mock
    private DeckMapper deckMapper;

    @Mock
    private DeckExcelImportSupport deckExcelImportSupport;

    @InjectMocks
    private DeckServiceImpl deckService;

    @Test
    void createDeck_createsDeckWithNormalizedFields() {
        final var folder = this
                .folder(FOLDER_ID, 2);
        final var request = createDeckRequest("  Deck A  ", "  Description  ");
        final var mappedDeck = this
                .deck(folder, DECK_ID, "Deck A", "Description");
        final var response = this
                .deckResponse();
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .of(folder));
        when(this.folderRepository
                .existsByParentIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(false);
        when(this.deckRepository
                .existsActiveNameByFolderId(FOLDER_ID, "Deck A", null))
                .thenReturn(false);
        when(this.deckMapper
                .toDeckEntity(folder, "Deck A", "Description", DeckConstants.FLASHCARD_COUNT_DEFAULT))
                .thenReturn(mappedDeck);
        when(this.deckRepository
                .save(mappedDeck))
                .thenReturn(mappedDeck);
        when(this.deckMapper
                .toDeckResponse(mappedDeck))
                .thenReturn(response);

        final var result = this.deckService
                .createDeck(FOLDER_ID, request);

        assertEquals(response, result);
    }

    @Test
    void createDeck_withNullDescription_usesDefaultDescription() {
        final var folder = this
                .folder(FOLDER_ID, 1);
        final var request = createDeckRequest(" Deck A ", null);
        final var mappedDeck = this
                .deck(folder, DECK_ID, "Deck A", DeckConstants.EMPTY_DESCRIPTION);
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .of(folder));
        when(this.folderRepository
                .existsByParentIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(false);
        when(this.deckRepository
                .existsActiveNameByFolderId(FOLDER_ID, "Deck A", null))
                .thenReturn(false);
        when(this.deckMapper
                .toDeckEntity(
                        folder,
                        "Deck A",
                        DeckConstants.EMPTY_DESCRIPTION,
                        DeckConstants.FLASHCARD_COUNT_DEFAULT))
                .thenReturn(mappedDeck);
        when(this.deckRepository
                .save(mappedDeck))
                .thenReturn(mappedDeck);
        when(this.deckMapper
                .toDeckResponse(mappedDeck))
                .thenReturn(this
                        .deckResponse());

        this.deckService
                .createDeck(FOLDER_ID, request);

        verify(this.deckMapper)
                .toDeckEntity(
                        folder,
                        "Deck A",
                        DeckConstants.EMPTY_DESCRIPTION,
                        DeckConstants.FLASHCARD_COUNT_DEFAULT);
    }

    @Test
    void createDeck_whenFolderMissing_throwsFolderNotFoundException() {
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .empty());
        final var request = createDeckRequest("Deck A", "Description");

        assertThrows(FolderNotFoundException.class, () -> this.deckService
                .createDeck(FOLDER_ID, request));
        verifyNoInteractions(this.deckRepository);
    }

    @Test
    void createDeck_whenFolderHasSubfolders_throwsDeckParentHasSubfoldersException() {
        final var folder = this
                .folder(FOLDER_ID, 2);
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .of(folder));
        when(this.folderRepository
                .existsByParentIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(true);
        final var request = createDeckRequest("Deck A", "Description");

        assertThrows(DeckParentHasSubfoldersException.class, () -> this.deckService
                .createDeck(FOLDER_ID, request));
    }

    @Test
    void createDeck_whenDeckNameAlreadyExists_throwsDeckNameConflictException() {
        final var folder = this
                .folder(FOLDER_ID, 2);
        final var request = createDeckRequest("Deck A", "Description");
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .of(folder));
        when(this.folderRepository
                .existsByParentIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(false);
        when(this.deckRepository
                .existsActiveNameByFolderId(FOLDER_ID, "Deck A", null))
                .thenReturn(true);

        assertThrows(DeckNameConflictException.class, () -> this.deckService
                .createDeck(FOLDER_ID, request));
    }

    @Test
    void updateDeck_updatesNormalizedFields() {
        final var folder = this
                .folder(FOLDER_ID, 2);
        final var deck = this
                .deck(folder, DECK_ID, "Deck A", "Description");
        final var request = updateDeckRequest("  Deck Updated  ", "  New Description  ");
        when(this.deckRepository
                .findByIdAndDeletedAtIsNull(DECK_ID))
                .thenReturn(Optional
                        .of(deck));
        when(this.deckRepository
                .existsActiveNameByFolderId(FOLDER_ID, "Deck Updated", DECK_ID))
                .thenReturn(false);
        when(this.deckMapper
                .toDeckResponse(deck))
                .thenReturn(this
                        .deckResponse());

        this.deckService
                .updateDeck(FOLDER_ID, DECK_ID, request);

        assertEquals("Deck Updated", deck
                .getName());
        assertEquals("New Description", deck
                .getDescription());
    }

    @Test
    void updateDeck_whenFolderScopeMismatch_throwsDeckNotFoundException() {
        final var folder = this
                .folder(99L, 2);
        final var deck = this
                .deck(folder, DECK_ID, "Deck A", "Description");
        when(this.deckRepository
                .findByIdAndDeletedAtIsNull(DECK_ID))
                .thenReturn(Optional
                        .of(deck));
        final var request = updateDeckRequest("Deck B", "Description");

        assertThrows(DeckNotFoundException.class, () -> this.deckService
                .updateDeck(FOLDER_ID, DECK_ID, request));
    }

    @Test
    void updateDeck_whenDeckNameExists_throwsDeckNameConflictException() {
        final var folder = this
                .folder(FOLDER_ID, 1);
        final var deck = this
                .deck(folder, DECK_ID, "Deck A", "Description");
        when(this.deckRepository
                .findByIdAndDeletedAtIsNull(DECK_ID))
                .thenReturn(Optional
                        .of(deck));
        when(this.deckRepository
                .existsActiveNameByFolderId(FOLDER_ID, "Deck Updated", DECK_ID))
                .thenReturn(true);
        final var request = updateDeckRequest("Deck Updated", "Description");

        assertThrows(DeckNameConflictException.class, () -> this.deckService
                .updateDeck(FOLDER_ID, DECK_ID, request));
    }

    @Test
    void deleteDeck_softDeletesDeckInFolderScope() {
        final var folder = this
                .folder(FOLDER_ID, 1);
        final var deck = this
                .deck(folder, DECK_ID, "Deck A", "Description");
        when(this.deckRepository
                .findByIdAndDeletedAtIsNull(DECK_ID))
                .thenReturn(Optional
                        .of(deck));

        this.deckService
                .deleteDeck(FOLDER_ID, DECK_ID);

        final var instantCaptor = ArgumentCaptor
                .forClass(Instant.class);
        verify(this.deckRepository)
                .softDeleteDeck(eq(FOLDER_ID), eq(DECK_ID), instantCaptor
                        .capture());
    }

    @Test
    void getDecks_returnsMappedDeckResponses() {
        final var folder = this
                .folder(FOLDER_ID, 1);
        final var deck = this
                .deck(folder, DECK_ID, "Deck A", "Description");
        final var searchRequest = byNameAsc("deck");
        final var pageable = PageRequest
                .of(0, 10);
        final var response = this
                .deckResponse();
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .of(folder));
        when(this.deckRepository
                .findAll(any(Specification.class), any(PageRequest.class)))
                .thenReturn(new PageImpl<>(List
                        .of(deck)));
        when(this.deckMapper
                .toDeckResponse(deck))
                .thenReturn(response);

        final var result = this.deckService
                .getDecks(FOLDER_ID, searchRequest, pageable);

        assertEquals(1, result
                .size());
        assertEquals(response, result
                .get(0));
    }

    @Test
    void getDecks_whenFolderMissing_throwsFolderNotFoundException() {
        when(this.folderRepository
                .findByIdAndDeletedAtIsNull(FOLDER_ID))
                .thenReturn(Optional
                        .empty());
        final var searchRequest = empty();
        final var pageable = PageRequest
                .of(0, 10);

        assertThrows(FolderNotFoundException.class, () -> this.deckService
                .getDecks(FOLDER_ID, searchRequest, pageable));
    }

    @Test
    void importDecks_importsParsedDecks() {
        final var folder = this.folder(FOLDER_ID, 1);
        final var file = this.importFile();
        final var drafts = List.of(
                new DeckImportDeckDraft(
                        "Deck A",
                        2,
                        List.of(new DeckImportFlashcardDraft("Term A", "Meaning A", 3))),
                new DeckImportDeckDraft(
                        "Deck B",
                        4,
                        List.of(
                                new DeckImportFlashcardDraft("Term B", "Meaning B", 5),
                                new DeckImportFlashcardDraft("Term C", "Meaning C", 6))));
        final var firstDeck = this.deck(folder, DECK_ID, "Deck A", DeckConstants.EMPTY_DESCRIPTION);
        final var secondDeck = this.deck(folder, 12L, "Deck B", DeckConstants.EMPTY_DESCRIPTION);
        final DeckImportResponse response = deckImportResponse(FOLDER_ID, 2, 2, 3);
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsByParentIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(false);
        when(this.deckExcelImportSupport.parseExcelFile(file)).thenReturn(drafts);
        when(this.deckImportBatchRepository.insertDecksIgnoreConflicts(eq(FOLDER_ID), eq(drafts), any(Instant.class)))
                .thenReturn(2);
        when(this.deckRepository.findAllActiveByFolderIdAndNormalizedNames(
                eq(FOLDER_ID),
                argThat(names -> names.size() == 2
                        && names.stream().allMatch(name -> StringUtils.equals(name, "deck a")
                                || StringUtils.equals(name, "deck b")))))
                .thenReturn(List.of(firstDeck, secondDeck));
        when(this.flashcardImportBatchRepository.insertFlashcards(any(), any(Instant.class))).thenReturn(3);
        when(this.deckMapper.toDeckImportResponse(FOLDER_ID, 2, 2, 3)).thenReturn(response);

        final var result = this.deckService.importDecks(FOLDER_ID, file);

        assertEquals(response, result);
        verify(this.deckImportBatchRepository).incrementFlashcardCounts(
                argThat(countMap -> countMap.size() == 2
                        && countMap.get(DECK_ID) == 1
                        && countMap.get(12L) == 2),
                any(Instant.class));
    }

    @Test
    void importDecks_whenDeckAlreadyExists_reusesExistingDeckAndStillImportsFlashcards() {
        final var folder = this.folder(FOLDER_ID, 1);
        final var file = this.importFile();
        final var drafts = List.of(
                new DeckImportDeckDraft(
                        "Deck A",
                        2,
                        List.of(new DeckImportFlashcardDraft("Term A", "Meaning A", 3))));
        final var existingDeck = this.deck(folder, DECK_ID, "Deck A", DeckConstants.EMPTY_DESCRIPTION);
        final DeckImportResponse response = deckImportResponse(FOLDER_ID, 1, 0, 1);
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsByParentIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(false);
        when(this.deckExcelImportSupport.parseExcelFile(file)).thenReturn(drafts);
        when(this.deckImportBatchRepository.insertDecksIgnoreConflicts(eq(FOLDER_ID), eq(drafts), any(Instant.class)))
                .thenReturn(0);
        when(this.deckRepository.findAllActiveByFolderIdAndNormalizedNames(
                eq(FOLDER_ID),
                argThat(names -> names.size() == 1
                        && names.stream().allMatch(name -> StringUtils.equals(name, "deck a")))))
                .thenReturn(List.of(existingDeck));
        when(this.flashcardImportBatchRepository.insertFlashcards(any(), any(Instant.class))).thenReturn(1);
        when(this.deckMapper.toDeckImportResponse(FOLDER_ID, 1, 0, 1)).thenReturn(response);

        final var result = this.deckService.importDecks(FOLDER_ID, file);

        assertEquals(response, result);
    }

    private Folder folder(Long id, Integer depth) {
        final var folder = new Folder();
        folder
                .setId(id);
        folder
                .setDepth(depth);

        return folder;
    }

    private Deck deck(Folder folder, Long id, String name, String description) {
        final var deck = new Deck();
        deck
                .setId(id);
        deck
                .setFolder(folder);
        deck
                .setName(name);
        deck
                .setDescription(description);
        deck
                .setFlashcardCount(0);

        return deck;
    }

    private DeckResponse deckResponse() {

        return com.lumos.testkit.DeckTestFixtures
                .deckResponse(
                        DECK_ID,
                        FOLDER_ID,
                        "Deck A",
                        "Description",
                        0);
    }

    private MockMultipartFile importFile() {
        return new MockMultipartFile(
                DeckImportConstants.FILE_PARAM_NAME,
                "decks.xlsx",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                new byte[] { 1 });
    }
}
