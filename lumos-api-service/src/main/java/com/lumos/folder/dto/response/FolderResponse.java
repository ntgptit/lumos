package com.lumos.folder.dto.response;

public record FolderResponse(
        Long id,
        String name,
        Long parentId,
        Integer depth,
        AuditMetadataResponse audit
) {
}
