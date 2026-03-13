package com.lumos.folder.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static com.lumos.testkit.FolderTestFixtures.createFolderRequest;
import static com.lumos.testkit.FolderTestFixtures.updateFolderRequest;
import static com.lumos.testkit.FolderTestFixtures.renameFolderRequest;
import static com.lumos.testkit.SearchRequestFixtures.byNameAsc;
import static com.lumos.testkit.SearchRequestFixtures.empty;

import java.time.Instant;
import java.util.List;
import java.util.Map;
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

import com.lumos.deck.repository.DeckRepository;
import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.exception.FolderHasDecksConflictException;
import com.lumos.folder.exception.FolderNameConflictException;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.folder.mapper.FolderMapper;
import com.lumos.folder.repository.FolderRepository;
import com.lumos.folder.repository.projection.FolderChildCountProjection;

@ExtendWith(MockitoExtension.class)
class FolderServiceImplTest {

    private static final Long PARENT_ID = 9L;
    private static final Long FOLDER_ID = 10L;

    @Mock
    private FolderRepository folderRepository;

    @Mock
    private DeckRepository deckRepository;

    @Mock
    private FolderMapper folderMapper;

    @InjectMocks
    private FolderServiceImpl folderService;

    @Test
    void createFolder_createsRootFolderWithNormalizedFields() {
        final var request = createFolderRequest("  Folder A  ", "  Description  ", null);
        final var mappedFolder = folder(FOLDER_ID, null, 1, "Folder A", "Description");
        final var response = folderResponse(FOLDER_ID, null, 1, 0);
        when(this.folderRepository.existsActiveSiblingName(null, "Folder A", null)).thenReturn(false);
        when(this.folderMapper.toFolderEntity(
                "Folder A",
                "Description",
                FolderConstants.DEFAULT_COLOR_HEX,
                null,
                FolderConstants.ROOT_FOLDER_DEPTH)).thenReturn(mappedFolder);
        when(this.folderRepository.save(mappedFolder)).thenReturn(mappedFolder);
        when(this.folderMapper.toFolderResponse(mappedFolder)).thenReturn(response);

        final var result = this.folderService.createFolder(request);

        assertEquals(response, result);
    }

    @Test
    void createFolder_withNullDescription_usesDefaultDescription() {
        final var request = createFolderRequest(" Folder A ", null, null);
        final var mappedFolder = folder(FOLDER_ID, null, 1, "Folder A", FolderConstants.EMPTY_DESCRIPTION);
        when(this.folderRepository.existsActiveSiblingName(null, "Folder A", null)).thenReturn(false);
        when(this.folderMapper.toFolderEntity(
                "Folder A",
                FolderConstants.EMPTY_DESCRIPTION,
                FolderConstants.DEFAULT_COLOR_HEX,
                null,
                FolderConstants.ROOT_FOLDER_DEPTH)).thenReturn(mappedFolder);
        when(this.folderRepository.save(mappedFolder)).thenReturn(mappedFolder);
        when(this.folderMapper.toFolderResponse(mappedFolder)).thenReturn(folderResponse(FOLDER_ID, null, 1, 0));

        this.folderService.createFolder(request);

        verify(this.folderMapper).toFolderEntity(
                "Folder A",
                FolderConstants.EMPTY_DESCRIPTION,
                FolderConstants.DEFAULT_COLOR_HEX,
                null,
                FolderConstants.ROOT_FOLDER_DEPTH);
    }

    @Test
    void createFolder_withMissingParent_throwsFolderNotFoundException() {
        when(this.folderRepository.findByIdAndDeletedAtIsNull(PARENT_ID)).thenReturn(Optional.empty());
        final var request = createFolderRequest("Folder A", "Description", PARENT_ID);

        assertThrows(FolderNotFoundException.class, () -> this.folderService.createFolder(request));
    }

    @Test
    void createFolder_whenParentHasDecks_throwsFolderHasDecksConflictException() {
        final var parent = folder(PARENT_ID, null, 1, "Parent", "");
        when(this.folderRepository.findByIdAndDeletedAtIsNull(PARENT_ID)).thenReturn(Optional.of(parent));
        when(this.deckRepository.existsByFolderIdAndDeletedAtIsNull(PARENT_ID)).thenReturn(true);
        final var request = createFolderRequest("Folder A", "Description", PARENT_ID);

        assertThrows(FolderHasDecksConflictException.class, () -> this.folderService.createFolder(request));
    }

    @Test
    void createFolder_whenSiblingNameExists_throwsFolderNameConflictException() {
        final var parent = folder(PARENT_ID, null, 1, "Parent", "");
        when(this.folderRepository.findByIdAndDeletedAtIsNull(PARENT_ID)).thenReturn(Optional.of(parent));
        when(this.deckRepository.existsByFolderIdAndDeletedAtIsNull(PARENT_ID)).thenReturn(false);
        when(this.folderRepository.existsActiveSiblingName(PARENT_ID, "Folder A", null)).thenReturn(true);
        final var request = createFolderRequest("Folder A", "Description", PARENT_ID);

        assertThrows(FolderNameConflictException.class, () -> this.folderService.createFolder(request));
    }

    @Test
    void renameFolder_updatesName() {
        final var parent = folder(PARENT_ID, null, 1, "Parent", "");
        final var folder = folder(FOLDER_ID, parent, 2, "Old Name", "Description");
        final var request = renameFolderRequest("  New Name  ");
        final var response = folderResponse(FOLDER_ID, PARENT_ID, 2, 0);
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsActiveSiblingName(PARENT_ID, "New Name", FOLDER_ID)).thenReturn(false);
        when(this.folderMapper.toFolderResponse(folder)).thenReturn(response);

        this.folderService.renameFolder(FOLDER_ID, request);

        assertEquals("New Name", folder.getName());
    }

    @Test
    void updateFolder_updatesNameAndDescription() {
        final var parent = folder(PARENT_ID, null, 1, "Parent", "");
        final var folder = folder(FOLDER_ID, parent, 2, "Old Name", "Old Description");
        final var request = updateFolderRequest("  New Name  ", "  New Description  ", null);
        final var response = folderResponse(FOLDER_ID, PARENT_ID, 2, 0);
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));
        when(this.folderRepository.existsActiveSiblingName(PARENT_ID, "New Name", FOLDER_ID)).thenReturn(false);
        when(this.folderMapper.toFolderResponse(folder)).thenReturn(response);

        this.folderService.updateFolder(FOLDER_ID, request);

        assertEquals("New Name", folder.getName());
        assertEquals("New Description", folder.getDescription());
    }

    @Test
    void deleteFolder_softDeletesDecksAndFolders() {
        final var folder = folder(FOLDER_ID, null, 1, "Folder", "Description");
        when(this.folderRepository.findByIdAndDeletedAtIsNull(FOLDER_ID)).thenReturn(Optional.of(folder));

        this.folderService.deleteFolder(FOLDER_ID);

        final var instantCaptor = ArgumentCaptor.forClass(Instant.class);
        verify(this.deckRepository).softDeleteByFolderTree(eq(FOLDER_ID), instantCaptor.capture());
        verify(this.folderRepository).softDeleteFolderTree(eq(FOLDER_ID), any(Instant.class));
    }

    @Test
    void getFolders_returnsMappedFolderResponsesWithResolvedChildCount() {
        final var parent = folder(PARENT_ID, null, 1, "Parent", "");
        final var folderOne = folder(20L, parent, 2, "Folder One", "Description");
        final var folderTwo = folder(21L, parent, 2, "Folder Two", "Description");
        final var searchRequest = byNameAsc("folder");
        final var pageable = PageRequest.of(0, 20);
        final var folderPage = new PageImpl<>(List.of(folderOne, folderTwo));
        final var projection = projection(folderOne.getId(), 3L);
        final var responseOne = folderResponse(folderOne.getId(), PARENT_ID, 2, 3);
        final var responseTwo = folderResponse(folderTwo.getId(), PARENT_ID, 2, 0);
        when(this.folderRepository.findAll(any(Specification.class), any(PageRequest.class))).thenReturn(folderPage);
        when(this.folderRepository.findChildCountByParentIds(List.of(folderOne.getId(), folderTwo.getId())))
                .thenReturn(List.of(projection));
        when(this.folderMapper.toFolderResponse(folderOne, 3)).thenReturn(responseOne);
        when(this.folderMapper.toFolderResponse(folderTwo, 0)).thenReturn(responseTwo);

        final var result = this.folderService.getFolders(PARENT_ID, searchRequest, pageable);

        assertEquals(List.of(responseOne, responseTwo), result);
    }

    @Test
    void getFolders_whenPageIsEmpty_skipsChildCountQuery() {
        final var searchRequest = empty();
        final var pageable = PageRequest.of(0, 20);
        when(this.folderRepository.findAll(any(Specification.class), any(PageRequest.class)))
                .thenReturn(new PageImpl<>(List.of()));

        final var result = this.folderService.getFolders(null, searchRequest, pageable);

        assertEquals(List.of(), result);
        verify(this.folderRepository, never()).findChildCountByParentIds(any());
    }

    private Folder folder(Long id, Folder parent, Integer depth, String name, String description) {
        final var folder = new Folder();
        folder.setId(id);
        folder.setParent(parent);
        folder.setDepth(depth);
        folder.setName(name);
        folder.setDescription(description);
        folder.setColorHex(FolderConstants.DEFAULT_COLOR_HEX);
        
        return folder;
    }

    private FolderResponse folderResponse(Long id, Long parentId, Integer depth, Integer childFolderCount) {
        
        return com.lumos.testkit.FolderTestFixtures.folderResponse(
                id,
                "Folder A",
                "Description",
                FolderConstants.DEFAULT_COLOR_HEX,
                parentId,
                depth,
                childFolderCount);
    }

    private FolderChildCountProjection projection(Long parentId, Long childCount) {
        
        return new FolderChildCountProjection() {
            @Override
            public Long getParentId() {
                
                return parentId;
            }

            @Override
            public Long getChildFolderCount() {
                
                return childCount;
            }
        };
    }
}
