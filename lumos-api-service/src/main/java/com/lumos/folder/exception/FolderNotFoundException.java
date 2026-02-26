package com.lumos.folder.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class FolderNotFoundException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public FolderNotFoundException(Long folderId) {
        super(ErrorMessageKeys.FOLDER_NOT_FOUND, folderId);
    }
}
