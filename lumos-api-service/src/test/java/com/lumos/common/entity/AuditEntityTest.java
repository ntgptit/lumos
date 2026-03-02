package com.lumos.common.entity;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Instant;

import org.junit.jupiter.api.Test;

class AuditEntityTest {

    @Test
    void prePersistAudit_setsCreatedAtAndUpdatedAt() {
        final var entity = new TestAuditEntity();

        entity.prePersistAudit();

        assertNotNull(entity.getCreatedAt());
        assertNotNull(entity.getUpdatedAt());
    }

    @Test
    void preUpdateAudit_updatesUpdatedAt() {
        final var entity = new TestAuditEntity();
        final var initialUpdatedAt = Instant.parse("2025-01-01T00:00:00Z");
        entity.setUpdatedAt(initialUpdatedAt);

        entity.preUpdateAudit();

        assertNotNull(entity.getUpdatedAt());
        assertTrue(entity.getUpdatedAt().isAfter(initialUpdatedAt));
    }

    private static final class TestAuditEntity extends AuditEntity {
    }
}
