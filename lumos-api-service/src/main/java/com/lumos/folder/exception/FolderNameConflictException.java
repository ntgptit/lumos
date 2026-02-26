package com.lumos.folder.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class FolderNameConflictException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public FolderNameConflictException(String name) {
        super(ErrorMessageKeys.FOLDER_NAME_CONFLICT, name);
    }
}
