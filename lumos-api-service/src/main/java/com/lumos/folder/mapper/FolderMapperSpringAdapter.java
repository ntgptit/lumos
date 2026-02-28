package com.lumos.folder.mapper;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.entity.Folder;

@Primary
@Component
public class FolderMapperSpringAdapter implements FolderMapper {

    @Override
    public FolderResponse toFolderResponse(Folder folder) {
        final var parentId = resolveParentId(folder);
        final var audit = this.toAuditMetadata(folder);
        return new FolderResponse(
                folder.getId(),
                folder.getName(),
                parentId,
                folder.getDepth(),
                FolderConstants.DEFAULT_CHILD_FOLDER_COUNT,
                audit
        );
    }

    @Override
    public Folder toFolderEntity(String name, Folder parent, Integer depth) {
        final var folder = new Folder();
        folder.setName(name);
        folder.setParent(parent);
        folder.setDepth(depth);
        return folder;
    }

    private Long resolveParentId(Folder folder) {
        final var parent = folder.getParent();
        // Parent id is absent when folder belongs to root.
        if (parent == null) {
            return null;
        }
        return parent.getId();
    }
}
