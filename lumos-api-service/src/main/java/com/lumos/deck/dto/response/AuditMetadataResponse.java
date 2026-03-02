package com.lumos.deck.dto.response;

import java.time.Instant;

public record AuditMetadataResponse(Instant createdAt, Instant updatedAt) {
}
