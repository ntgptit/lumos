package com.lumos.folder.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.common.enums.SortBy;
import com.lumos.common.enums.SortType;
import com.lumos.folder.dto.request.CreateFolderRequest;
import com.lumos.folder.dto.request.RenameFolderRequest;
import com.lumos.folder.dto.request.UpdateFolderRequest;
import com.lumos.folder.dto.response.AuditMetadataResponse;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.service.FolderService;

@ExtendWith(MockitoExtension.class)
class FolderControllerTest {

    private static final Long FOLDER_ID = 30L;

    @Mock
    private FolderService folderService;

    @InjectMocks
    private FolderController folderController;

    @Test
    void createFolder_returnsCreatedResponse() {
        final var request = new CreateFolderRequest("Folder A", "Description", null);
        final var response = sampleFolderResponse();
        when(this.folderService.createFolder(request)).thenReturn(response);

        final var entity = this.folderController.createFolder(request);

        assertEquals(201, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void renameFolder_returnsOkResponse() {
        final var request = new RenameFolderRequest("Folder B");
        final var response = sampleFolderResponse();
        when(this.folderService.renameFolder(FOLDER_ID, request)).thenReturn(response);

        final var entity = this.folderController.renameFolder(FOLDER_ID, request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateFolder_returnsOkResponse() {
        final var request = new UpdateFolderRequest("Folder C", "Updated", null);
        final var response = sampleFolderResponse();
        when(this.folderService.updateFolder(FOLDER_ID, request)).thenReturn(response);

        final var entity = this.folderController.updateFolder(FOLDER_ID, request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void deleteFolder_returnsNoContentResponse() {
        final var entity = this.folderController.deleteFolder(FOLDER_ID);

        verify(this.folderService).deleteFolder(FOLDER_ID);
        assertEquals(204, entity.getStatusCode().value());
        assertNull(entity.getBody());
    }

    @Test
    void getFolders_returnsFolderList() {
        final var searchRequest = new SearchRequest("folder", SortBy.NAME, SortType.ASC);
        final var pageable = PageRequest.of(0, 20);
        final var response = List.of(sampleFolderResponse());
        when(this.folderService.getFolders(10L, searchRequest, pageable)).thenReturn(response);

        final var entity = this.folderController.getFolders(10L, searchRequest, pageable);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    private FolderResponse sampleFolderResponse() {
        return new FolderResponse(
                FOLDER_ID,
                "Folder A",
                "Description",
                "#112233",
                null,
                1,
                0,
                new AuditMetadataResponse(
                        Instant.parse("2026-01-01T00:00:00Z"),
                        Instant.parse("2026-01-02T00:00:00Z")));
    }
}
