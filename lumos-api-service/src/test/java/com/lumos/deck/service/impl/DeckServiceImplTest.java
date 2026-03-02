package com.lumos.deck.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

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

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.deck.constant.DeckConstants;
import com.lumos.deck.dto.request.CreateDeckRequest;
import com.lumos.deck.dto.request.UpdateDeckRequest;
import com.lumos.deck.dto.response.AuditMetadataResponse;
import com.lumos.deck.dto.response.DeckResponse;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckNameConflictException;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.exception.DeckParentHasSubfoldersException;
import com.lumos.deck.mapper.DeckMapper;
import com.lumos.deck.repository.DeckRepository;
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
    private FolderRepository folderRepository;

    @Mock
    private DeckMapper deckMapper;

    @InjectMocks
    private DeckServiceImpl deckService;

    @Test
    void createDeck_createsDeckWithNormalizedFields() {
        final var folder = folder(FOLDER_ID, 2);
        final var request = new CreateDeckRequest("  Deck A  ", "  Description  ");
        final var mappedDeck = deck(folder, DECK_ID, "Deck A", "Description");
        final var response = deckResponse();
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsByParentIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(false);
        when(this.deckRepository.existsActiveNameByFolderId(FOLDER_ID, "Deck A", null)).thenReturn(false);
        when(this.deckMapper.toDeckEntity(folder, "Deck A", "Description", DeckConstants.FLASHCARD_COUNT_DEFAULT))
                .thenReturn(mappedDeck);
        when(this.deckRepository.save(mappedDeck)).thenReturn(mappedDeck);
        when(this.deckMapper.toDeckResponse(mappedDeck)).thenReturn(response);

        final var result = this.deckService.createDeck(FOLDER_ID, request);

        assertEquals(response, result);
    }

    @Test
    void createDeck_withNullDescription_usesDefaultDescription() {
        final var folder = folder(FOLDER_ID, 1);
        final var request = new CreateDeckRequest(" Deck A ", null);
        final var mappedDeck = deck(folder, DECK_ID, "Deck A", DeckConstants.EMPTY_DESCRIPTION);
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsByParentIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(false);
        when(this.deckRepository.existsActiveNameByFolderId(FOLDER_ID, "Deck A", null)).thenReturn(false);
        when(this.deckMapper.toDeckEntity(
                folder,
                "Deck A",
                DeckConstants.EMPTY_DESCRIPTION,
                DeckConstants.FLASHCARD_COUNT_DEFAULT)).thenReturn(mappedDeck);
        when(this.deckRepository.save(mappedDeck)).thenReturn(mappedDeck);
        when(this.deckMapper.toDeckResponse(mappedDeck)).thenReturn(deckResponse());

        this.deckService.createDeck(FOLDER_ID, request);

        verify(this.deckMapper).toDeckEntity(
                folder,
                "Deck A",
                DeckConstants.EMPTY_DESCRIPTION,
                DeckConstants.FLASHCARD_COUNT_DEFAULT);
    }

    @Test
    void createDeck_whenFolderMissing_throwsFolderNotFoundException() {
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.empty());
        final var request = new CreateDeckRequest("Deck A", "Description");

        assertThrows(FolderNotFoundException.class, () -> this.deckService.createDeck(FOLDER_ID, request));
        verifyNoInteractions(this.deckRepository);
    }

    @Test
    void createDeck_whenFolderHasSubfolders_throwsDeckParentHasSubfoldersException() {
        final var folder = folder(FOLDER_ID, 2);
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsByParentIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(true);
        final var request = new CreateDeckRequest("Deck A", "Description");

        assertThrows(DeckParentHasSubfoldersException.class, () -> this.deckService.createDeck(FOLDER_ID, request));
    }

    @Test
    void createDeck_whenDeckNameAlreadyExists_throwsDeckNameConflictException() {
        final var folder = folder(FOLDER_ID, 2);
        final var request = new CreateDeckRequest("Deck A", "Description");
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsByParentIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(false);
        when(this.deckRepository.existsActiveNameByFolderId(FOLDER_ID, "Deck A", null)).thenReturn(true);

        assertThrows(DeckNameConflictException.class, () -> this.deckService.createDeck(FOLDER_ID, request));
    }

    @Test
    void updateDeck_updatesNormalizedFields() {
        final var folder = folder(FOLDER_ID, 2);
        final var deck = deck(folder, DECK_ID, "Deck A", "Description");
        final var request = new UpdateDeckRequest("  Deck Updated  ", "  New Description  ");
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.deckRepository.existsActiveNameByFolderId(FOLDER_ID, "Deck Updated", DECK_ID)).thenReturn(false);
        when(this.deckMapper.toDeckResponse(deck)).thenReturn(deckResponse());

        this.deckService.updateDeck(FOLDER_ID, DECK_ID, request);

        assertEquals("Deck Updated", deck.getName());
        assertEquals("New Description", deck.getDescription());
    }

    @Test
    void updateDeck_whenFolderScopeMismatch_throwsDeckNotFoundException() {
        final var folder = folder(99L, 2);
        final var deck = deck(folder, DECK_ID, "Deck A", "Description");
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        final var request = new UpdateDeckRequest("Deck B", "Description");

        assertThrows(DeckNotFoundException.class, () -> this.deckService.updateDeck(FOLDER_ID, DECK_ID, request));
    }

    @Test
    void updateDeck_whenDeckNameExists_throwsDeckNameConflictException() {
        final var folder = folder(FOLDER_ID, 1);
        final var deck = deck(folder, DECK_ID, "Deck A", "Description");
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.deckRepository.existsActiveNameByFolderId(FOLDER_ID, "Deck Updated", DECK_ID)).thenReturn(true);
        final var request = new UpdateDeckRequest("Deck Updated", "Description");

        assertThrows(DeckNameConflictException.class, () -> this.deckService.updateDeck(FOLDER_ID, DECK_ID, request));
    }

    @Test
    void deleteDeck_softDeletesDeckInFolderScope() {
        final var folder = folder(FOLDER_ID, 1);
        final var deck = deck(folder, DECK_ID, "Deck A", "Description");
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));

        this.deckService.deleteDeck(FOLDER_ID, DECK_ID);

        final var instantCaptor = ArgumentCaptor.forClass(Instant.class);
        verify(this.deckRepository).softDeleteDeck(eq(FOLDER_ID), eq(DECK_ID), instantCaptor.capture());
    }

    @Test
    void getDecks_returnsMappedDeckResponses() {
        final var folder = folder(FOLDER_ID, 1);
        final var deck = deck(folder, DECK_ID, "Deck A", "Description");
        final var searchRequest = new SearchRequest("deck", SortBy.NAME, SortType.ASC);
        final var pageable = PageRequest.of(0, 10);
        final var response = deckResponse();
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.deckRepository.findAll(any(Specification.class), any(PageRequest.class)))
                .thenReturn(new PageImpl<>(List.of(deck)));
        when(this.deckMapper.toDeckResponse(deck)).thenReturn(response);

        final var result = this.deckService.getDecks(FOLDER_ID, searchRequest, pageable);

        assertEquals(1, result.size());
        assertEquals(response, result.get(0));
    }

    @Test
    void getDecks_whenFolderMissing_throwsFolderNotFoundException() {
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.empty());
        final var searchRequest = new SearchRequest(null, null, null);
        final var pageable = PageRequest.of(0, 10);

        assertThrows(FolderNotFoundException.class, () -> this.deckService.getDecks(FOLDER_ID, searchRequest, pageable));
    }

    private Folder folder(Long id, Integer depth) {
        final var folder = new Folder();
        folder.setId(id);
        folder.setDepth(depth);
        return folder;
    }

    private Deck deck(Folder folder, Long id, String name, String description) {
        final var deck = new Deck();
        deck.setId(id);
        deck.setFolder(folder);
        deck.setName(name);
        deck.setDescription(description);
        deck.setFlashcardCount(0);
        return deck;
    }

    private DeckResponse deckResponse() {
        return new DeckResponse(
                DECK_ID,
                FOLDER_ID,
                "Deck A",
                "Description",
                0,
                new AuditMetadataResponse(
                        Instant.parse("2026-01-01T00:00:00Z"),
                        Instant.parse("2026-01-02T00:00:00Z")));
    }
}
