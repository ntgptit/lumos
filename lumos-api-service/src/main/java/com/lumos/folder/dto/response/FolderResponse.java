package com.lumos.folder.dto.response;

public record FolderResponse(
        Long id,
        String name,
        String description,
        Long parentId,
        Integer depth,
        Integer childFolderCount,
        Integer deckCount,
        AuditMetadataResponse audit
) {
}
