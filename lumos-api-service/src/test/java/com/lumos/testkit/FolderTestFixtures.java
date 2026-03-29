package com.lumos.testkit;

import java.time.Instant;

import com.lumos.folder.dto.request.CreateFolderRequest;
import com.lumos.folder.dto.request.RenameFolderRequest;
import com.lumos.folder.dto.request.UpdateFolderRequest;
import com.lumos.folder.dto.response.AuditMetadataResponse;
import com.lumos.folder.dto.response.FolderResponse;

public final class FolderTestFixtures {

    private FolderTestFixtures() {
    }

    public static CreateFolderRequest createFolderRequest(String name, String description, Long parentId) {
        
        return new CreateFolderRequest(name, description, parentId);
    }

    public static RenameFolderRequest renameFolderRequest(String name) {
        
        return new RenameFolderRequest(name);
    }

    public static UpdateFolderRequest updateFolderRequest(String name, String description, Long parentId) {
        
        return new UpdateFolderRequest(name, description, parentId);
    }

    public static FolderResponse folderResponse(
            Long id,
            String name,
            String description,
            Long parentId,
            Integer depth,
            Integer childFolderCount,
            Integer deckCount) {
        
        return new FolderResponse(
                id,
                name,
                description,
                parentId,
                depth,
                childFolderCount,
                deckCount,
                new AuditMetadataResponse(
                        Instant.parse("2026-01-01T00:00:00Z"),
                        Instant.parse("2026-01-02T00:00:00Z")));
    }
}
