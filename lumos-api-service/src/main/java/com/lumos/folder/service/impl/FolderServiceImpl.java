package com.lumos.folder.service.impl;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.deck.repository.projection.DeckFolderCountProjection;
import com.lumos.folder.constant.FolderConstants;
import com.lumos.folder.dto.request.CreateFolderRequest;
import com.lumos.folder.dto.request.RenameFolderRequest;
import com.lumos.folder.dto.request.UpdateFolderRequest;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.entity.Folder;
import com.lumos.folder.exception.FolderHasDecksConflictException;
import com.lumos.folder.exception.FolderNameConflictException;
import com.lumos.folder.exception.FolderNotFoundException;
import com.lumos.folder.mapper.FolderMapper;
import com.lumos.folder.repository.FolderRepository;
import com.lumos.folder.repository.projection.FolderChildCountProjection;
import com.lumos.folder.repository.specification.FolderSpecifications;
import com.lumos.folder.service.FolderService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class FolderServiceImpl implements FolderService {

    private final FolderRepository folderRepository;
    private final DeckRepository deckRepository;
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
        final var normalizedName = StringUtils.strip(request.name());
        final var normalizedDescription = this.normalizeDescription(request.description());
        final var parent = this.resolveParent(request.parentId());
        final var depth = this.resolveDepth(parent);
        this.validateParentHasNoDecks(parent);
        this.validateSiblingName(parent, normalizedName, null);
        final var folder = this.folderMapper.toFolderEntity(
                normalizedName,
                normalizedDescription,
                parent,
                depth);
        final var savedFolder = this.folderRepository.save(folder);
        // Return the created folder DTO after the tree position and metadata have been persisted.
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
        final var folder = this.findActiveFolder(folderId);
        final var normalizedName = StringUtils.strip(request.name());
        this.validateSiblingName(folder.getParent(), normalizedName, folder.getId());
        folder.setName(normalizedName);
        // Return the renamed folder DTO so the client reflects the canonical sibling-safe name.
        return this.folderMapper.toFolderResponse(folder);
    }

    /**
     * Update folder metadata.
     *
     * @param folderId folder identifier
     * @param request  update folder payload
     * @return updated folder response
     */
    @Override
    @Transactional
    public FolderResponse updateFolder(Long folderId, UpdateFolderRequest request) {
        final var folder = this.findActiveFolder(folderId);
        final var normalizedName = StringUtils.strip(request.name());
        final var normalizedDescription = this.normalizeDescription(request.description());
        this.validateSiblingName(folder.getParent(), normalizedName, folder.getId());
        folder.setName(normalizedName);
        folder.setDescription(normalizedDescription);
        // Return the updated folder DTO after applying normalized metadata to the managed entity.
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
        this.findActiveFolder(folderId);
        final var deletedAt = Instant.now();
        this.deckRepository.softDeleteByFolderTree(folderId, deletedAt);
        this.folderRepository.softDeleteFolderTree(folderId, deletedAt);
    }

    /**
     * Get paginated folders.
     *
     * @param parentId      folder parent identifier
     * @param searchRequest common search request
     * @param pageable      pagination options
     * @return paged folder response
     */
    @Override
    @Transactional(readOnly = true)
    public List<FolderResponse> getFolders(Long parentId, SearchRequest searchRequest, Pageable pageable) {
        final var specification = FolderSpecifications.byParentAndKeyword(parentId, searchRequest.searchQuery());
        final var sortedPageable = FolderSpecifications.toSortedPageable(
                pageable,
                searchRequest.sortBy(),
                searchRequest.sortType());
        final var folders = this.folderRepository.findAll(specification, sortedPageable).getContent();
        final var childCountByParentId = this.resolveChildCountByParentId(folders);
        final var deckCountByFolderId = this.resolveDeckCountByFolderId(folders);
        // Return the page slice enriched with child counts so the tree view can render folder badges.
        return folders.stream()
                // Map each folder row with its precomputed child count so the list API stays O(1) per row.
                .map(folder -> {
                    final var childFolderCount = childCountByParentId.getOrDefault(
                            folder.getId(),
                            FolderConstants.DEFAULT_CHILD_FOLDER_COUNT);
                    final var deckCount = deckCountByFolderId.getOrDefault(
                            folder.getId(),
                            FolderConstants.DEFAULT_DECK_COUNT);
                    // Return the folder row enriched with its child count for tree-navigation rendering.
                    return this.folderMapper.toFolderResponse(folder, childFolderCount, deckCount);
                })
                .toList();
    }

    private Folder findActiveFolder(Long folderId) {
        // Return the active folder or fail so tree operations never target a deleted node.
        return this.folderRepository.findByIdAndDeletedAtIsNull(folderId)
                .orElseThrow(() -> new FolderNotFoundException(folderId));
    }

    private Folder resolveParent(Long parentId) {
        // Null parentId indicates root-level folder creation.
        if (parentId == null) {
            // Return null so the caller creates a root folder instead of attaching to a parent.
            return null;
        }
        // Return the resolved parent folder so child depth and sibling validation use canonical tree data.
        return this.findActiveFolder(parentId);
    }

    private int resolveDepth(Folder parent) {
        // Root folder starts at level 1 when parent is absent.
        if (parent == null) {
            // Return the root depth constant because folders without parent start a new tree branch.
            return FolderConstants.ROOT_FOLDER_DEPTH;
        }
        // Return the parent depth plus one so descendants maintain a consistent tree level.
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
            // Reject sibling name collisions because folder names must stay unique inside one parent.
            throw new FolderNameConflictException(name);
        }
    }

    private void validateParentHasNoDecks(Folder parent) {
        // Root-level folder creation has no parent constraint.
        if (parent == null) {
            // Return without validation because root folders do not inherit the no-deck parent rule.
            return;
        }
        final var hasDecks = this.deckRepository.existsByFolderIdAndDeletedAtIsNull(parent.getId());
        // Allow subfolder creation only when parent folder has no decks.
        if (!hasDecks) {
            // Return without error because the parent still behaves as a pure container folder.
            return;
        }
        // Block subfolder creation under a folder that already owns decks to preserve the tree invariant.
        throw new FolderHasDecksConflictException(parent.getId());
    }

    private String normalizeDescription(String description) {
        // Fallback to empty description when value is absent.
        if (description == null) {
            // Return the shared empty-description token so folder metadata remains null-safe.
            return FolderConstants.EMPTY_DESCRIPTION;
        }
        // Return the trimmed description so storage does not keep accidental outer whitespace.
        return StringUtils.strip(description);
    }

    private Map<Long, Integer> resolveChildCountByParentId(List<Folder> folders) {
        // Extract folder ids first so the aggregate child-count query runs once for the page.
        final var folderIds = folders.stream()
                .map(Folder::getId)
                .toList();
        // Return early when folder list is empty to avoid unnecessary query.
        if (folderIds.isEmpty()) {
            // Return an empty count map because no folder rows need child-count enrichment.
            return Map.of();
        }
        // Return the child-count lookup keyed by parent id for fast response mapping.
        // Re-index projection rows by parent id so response mapping can look up counts cheaply.
        return this.folderRepository.findChildCountByParentIds(folderIds).stream()
                .collect(Collectors.toMap(
                        FolderChildCountProjection::getParentId,
                        row -> row.getChildFolderCount().intValue()));
    }

    private Map<Long, Integer> resolveDeckCountByFolderId(List<Folder> folders) {
        final var folderIds = folders.stream()
                .map(Folder::getId)
                .toList();
        if (folderIds.isEmpty()) {
            
            return Map.of();
        }
        return this.deckRepository.findDeckCountByFolderIds(folderIds).stream()
                .collect(Collectors.toMap(
                        DeckFolderCountProjection::getFolderId,
                        row -> row.getDeckCount().intValue()));
    }
}
