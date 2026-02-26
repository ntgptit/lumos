package com.lumos.folder.service.impl;

import java.time.Instant;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.dto.request.CreateFolderRequest;
import com.lumos.folder.dto.request.RenameFolderRequest;
import com.lumos.folder.dto.response.BreadcrumbResponse;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.exception.FolderNameConflictException;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.folder.mapper.FolderMapper;
import com.lumos.folder.repository.FolderRepository;
import com.lumos.folder.service.FolderService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FolderServiceImpl implements FolderService {

    private final FolderRepository folderRepository;
    private final FolderMapper folderMapper;

    /**
     * Create a folder with optional parent.
     *
     * @param request create folder payload
     * @return created folder response
     */
    @Override
    @Transactional
    public FolderResponse createFolder(CreateFolderRequest request) {

        final var normalizedName = StringUtils.trim(request.name());
        final var parent = resolveParent(request.parentId());
        final var depth = resolveDepth(parent);

        validateSiblingName(parent, normalizedName, null);

        final var folder = this.folderMapper.toFolderEntity(normalizedName, parent, depth);
        final var savedFolder = this.folderRepository.save(folder);
        return this.folderMapper.toFolderResponse(savedFolder);
    }

    /**
     * Rename an existing folder.
     *
     * @param folderId folder identifier
     * @param request  rename folder payload
     * @return updated folder response
     */
    @Override
    @Transactional
    public FolderResponse renameFolder(Long folderId, RenameFolderRequest request) {

        final var folder = findActiveFolder(folderId);
        final var normalizedName = StringUtils.trim(request.name());

        validateSiblingName(folder.getParent(), normalizedName, folder.getId());
        folder.setName(normalizedName);

        return this.folderMapper.toFolderResponse(folder);
    }

    /**
     * Soft delete folder and its subtree.
     *
     * @param folderId folder identifier
     */
    @Override
    @Transactional
    public void deleteFolder(Long folderId) {

        findActiveFolder(folderId);
        final var deletedAt = Instant.now();

        this.folderRepository.softDeleteFolderTree(folderId, deletedAt);
    }

    /**
     * Get breadcrumb from root to target folder.
     *
     * @param folderId folder identifier
     * @return breadcrumb response
     */
    @Override
    @Transactional(readOnly = true)
    public BreadcrumbResponse getBreadcrumb(Long folderId) {

        final var items = this.folderRepository.findBreadcrumbRows(folderId)
                .stream()
                .map(this.folderMapper::toBreadcrumbItem)
                .toList();

        // Empty breadcrumb means folder does not exist or is soft-deleted.
        if (items.isEmpty()) {
            throw new FolderNotFoundException(folderId);
        }

        return this.folderMapper.toBreadcrumbResponse(folderId, items);
    }

    /**
     * Get paginated folders.
     *
     * @param pageable pagination options
     * @return paged folder response
     */
    @Override
    @Transactional(readOnly = true)
    public Page<FolderResponse> getFolders(Pageable pageable) {
        return this.folderRepository.findAllByDeletedAtIsNull(pageable).map(this.folderMapper::toFolderResponse);
    }

    private Folder findActiveFolder(Long folderId) {
        return this.folderRepository.findByIdAndDeletedAtIsNull(folderId)
                .orElseThrow(() -> new FolderNotFoundException(folderId));
    }

    private Folder resolveParent(Long parentId) {
        // Null parentId indicates root-level folder creation.
        if (parentId == null) {
            return null;
        }
        return findActiveFolder(parentId);
    }

    private int resolveDepth(Folder parent) {
        // Root folder starts at level 1 when parent is absent.
        if (parent == null) {
            return FolderConstants.ROOT_FOLDER_DEPTH;
        }
        return parent.getDepth() + 1;
    }

    private void validateSiblingName(Folder parent, String name, Long excludeId) {
        Long parentId = null;
        // Use parent id scope only when a parent folder exists.
        if (parent != null) {
            parentId = parent.getId();
        }
        final var exists = this.folderRepository.existsActiveSiblingName(parentId, name, excludeId);
        // Reject duplicate folder name within the same parent scope.
        if (exists) {
            throw new FolderNameConflictException(name);
        }
    }

}
