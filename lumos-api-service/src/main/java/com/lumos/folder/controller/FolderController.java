package com.lumos.folder.controller;

import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.folder.dto.request.CreateFolderRequest;
import com.lumos.folder.dto.request.RenameFolderRequest;
import com.lumos.folder.dto.response.BreadcrumbResponse;
import com.lumos.folder.dto.response.FolderResponse;
import com.lumos.folder.service.FolderService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import java.util.List;

/**
 * Folder management endpoints.
 */
@Validated
@RestController
@Tag(name = "Folders", description = "Folder management APIs")
@RequiredArgsConstructor
@RequestMapping("/api/v1/folders")
public class FolderController {

	private final FolderService folderService;

	/**
	 * Create a folder under the provided parent.
	 */
	@Operation(summary = "Create folder")
	@PostMapping
	public ResponseEntity<FolderResponse> createFolder(@Valid @RequestBody CreateFolderRequest request) {
		final var folder = this.folderService.createFolder(request);
		return ResponseEntity.status(HttpStatus.CREATED).body(folder);
	}

	/**
	 * Rename an existing folder.
	 */
	@Operation(summary = "Rename folder")
	@PatchMapping("/{folderId}/rename")
	public ResponseEntity<FolderResponse> renameFolder(@PathVariable Long folderId,
			@Valid @RequestBody RenameFolderRequest request) {
		final var folder = this.folderService.renameFolder(folderId, request);
		return ResponseEntity.ok(folder);
	}

	/**
	 * Soft delete a folder and its subtree.
	 */
	@Operation(summary = "Soft delete folder")
	@DeleteMapping("/{folderId}")
	public ResponseEntity<Void> deleteFolder(@PathVariable Long folderId) {
		this.folderService.deleteFolder(folderId);
		return ResponseEntity.noContent().build();
	}

	/**
	 * Get breadcrumb from root to current folder.
	 */
	@Operation(summary = "Get folder breadcrumb")
	@GetMapping("/{folderId}/breadcrumb")
	public ResponseEntity<BreadcrumbResponse> getBreadcrumb(@PathVariable Long folderId) {
		final var breadcrumb = this.folderService.getBreadcrumb(folderId);
		return ResponseEntity.ok(breadcrumb);
	}

	/**
	 * Get paginated folders.
	 */
	@Operation(summary = "Get folders")
	@GetMapping
	public ResponseEntity<List<FolderResponse>> getFolders(Pageable pageable) {
		final var folders = this.folderService.getFolders(pageable);
		return ResponseEntity.ok(folders);
	}
}
