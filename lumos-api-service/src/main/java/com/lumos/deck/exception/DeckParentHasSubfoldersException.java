package com.lumos.deck.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class DeckParentHasSubfoldersException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public DeckParentHasSubfoldersException(Long folderId) {
        super(ErrorMessageKeys.DECK_PARENT_HAS_SUBFOLDERS, folderId);
    }
}
