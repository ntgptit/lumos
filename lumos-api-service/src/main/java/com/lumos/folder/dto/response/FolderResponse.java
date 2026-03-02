package com.lumos.folder.dto.response;

public record FolderResponse(
        Long id,
        String name,
        String description,
        String colorHex,
        Long parentId,
        Integer depth,
        Integer childFolderCount,
        AuditMetadataResponse audit
) {
}
