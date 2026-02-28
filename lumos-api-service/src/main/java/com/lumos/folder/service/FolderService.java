package com.lumos.folder.service;

import org.springframework.data.domain.Pageable;
import java.util.List;

import com.lumos.common.dto.request.SearchRequest;
import com.lumos.folder.dto.request.CreateFolderRequest;
import com.lumos.folder.dto.request.RenameFolderRequest;
import com.lumos.folder.dto.response.FolderResponse;

public interface FolderService {

    /**
     * Create a folder with optional parent.
     *
     * @param request create folder payload
     * @return created folder response
     */
    FolderResponse createFolder(CreateFolderRequest request);

    /**
     * Rename an existing folder.
     *
     * @param folderId folder identifier
     * @param request  rename folder payload
     * @return updated folder response
     */
    FolderResponse renameFolder(Long folderId, RenameFolderRequest request);

    /**
     * Soft delete folder and all descendants.
     *
     * @param folderId folder identifier
     */
    void deleteFolder(Long folderId);

    /**
     * Get paginated folders.
     *
     * @param parentId      parent folder identifier, null for root
     * @param searchRequest common search request
     * @param pageable      pagination options
     * @return paged folder response
     */
    List<FolderResponse> getFolders(Long parentId, SearchRequest searchRequest, Pageable pageable);
}
