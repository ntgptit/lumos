package com.lumos.folder.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.time.Instant;

import org.junit.jupiter.api.Test;

import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.entity.Folder;

class FolderMapperSpringAdapterTest {

    private final FolderMapperSpringAdapter mapper = new FolderMapperSpringAdapter();

    @Test
    void toFolderResponse_mapsEntityFields() {
        final var parent = new Folder();
        parent.setId(3L);
        final var folder = new Folder();
        folder.setId(10L);
        folder.setName("Folder A");
        folder.setDescription("Description");
        folder.setDepth(2);
        folder.setParent(parent);
        folder.setCreatedAt(Instant.parse("2026-01-01T00:00:00Z"));
        folder.setUpdatedAt(Instant.parse("2026-01-02T00:00:00Z"));

        final var response = this.mapper.toFolderResponse(folder);

        assertEquals(10L, response.id());
        assertEquals("Folder A", response.name());
        assertEquals("Description", response.description());
        assertEquals(3L, response.parentId());
        assertEquals(2, response.depth());
        assertEquals(FolderConstants.DEFAULT_CHILD_FOLDER_COUNT, response.childFolderCount());
        assertEquals(FolderConstants.DEFAULT_DECK_COUNT, response.deckCount());
        assertNotNull(response.audit());
        assertEquals(folder.getCreatedAt(), response.audit().createdAt());
        assertEquals(folder.getUpdatedAt(), response.audit().updatedAt());
    }

    @Test
    void toFolderResponse_handlesNullParent() {
        final var folder = new Folder();
        folder.setId(12L);
        folder.setName("Folder B");
        folder.setDescription("Description");
        folder.setDepth(1);

        final var response = this.mapper.toFolderResponse(folder);

        assertNull(response.parentId());
    }

    @Test
    void toFolderEntity_mapsArgumentsToEntity() {
        final var parent = new Folder();
        parent.setId(5L);

        final var folder = this.mapper.toFolderEntity("Folder Name", "Folder Description", parent, 3);

        assertEquals("Folder Name", folder.getName());
        assertEquals("Folder Description", folder.getDescription());
        assertEquals(parent, folder.getParent());
        assertEquals(3, folder.getDepth());
    }
}
