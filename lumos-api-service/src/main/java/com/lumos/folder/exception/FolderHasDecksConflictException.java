package com.lumos.folder.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class FolderHasDecksConflictException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public FolderHasDecksConflictException(Long folderId) {
        super(ErrorMessageKeys.FOLDER_HAS_DECKS_CONFLICT, folderId);
    }
}
