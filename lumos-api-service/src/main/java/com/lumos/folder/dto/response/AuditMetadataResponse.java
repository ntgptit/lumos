package com.lumos.folder.dto.response;

import java.time.Instant;

public record AuditMetadataResponse(
        Instant createdAt,
        Instant updatedAt
) {
}
