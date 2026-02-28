package com.lumos.folder.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import com.lumos.folder.dto.response.AuditMetadataResponse;
import com.lumos.folder.dto.response.BreadcrumbItemResponse;
import com.lumos.folder.dto.response.BreadcrumbResponse;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.repository.projection.BreadcrumbRowProjection;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface FolderMapper {

    @Mapping(target = "parentId", source = "parent.id")
    @Mapping(target = "childFolderCount", expression = "java(defaultChildFolderCount())")
    @Mapping(target = "audit", expression = "java(toAuditMetadata(folder))")
    FolderResponse toFolderResponse(Folder folder);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "version", ignore = true)
    @Mapping(target = "name", source = "name")
    @Mapping(target = "parent", source = "parent")
    @Mapping(target = "depth", source = "depth")
    Folder toFolderEntity(String name, Folder parent, Integer depth);

    default BreadcrumbItemResponse toBreadcrumbItem(BreadcrumbRowProjection row) {
        return new BreadcrumbItemResponse(row.getId(), row.getName(), row.getDepth());
    }

    default BreadcrumbResponse toBreadcrumbResponse(Long folderId, List<BreadcrumbItemResponse> items) {
        return new BreadcrumbResponse(folderId, items);
    }

    default FolderResponse toFolderResponse(Folder folder, Integer childFolderCount) {
        final var response = toFolderResponse(folder);
        return new FolderResponse(
                response.id(),
                response.name(),
                response.parentId(),
                response.depth(),
                childFolderCount,
                response.audit()
        );
    }

    default AuditMetadataResponse toAuditMetadata(Folder folder) {
        return new AuditMetadataResponse(folder.getCreatedAt(), folder.getUpdatedAt());
    }

    default Integer defaultChildFolderCount() {
        return FolderConstants.DEFAULT_CHILD_FOLDER_COUNT;
    }
}
