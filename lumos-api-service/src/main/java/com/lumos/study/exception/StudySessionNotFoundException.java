package com.lumos.study.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class StudySessionNotFoundException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public StudySessionNotFoundException(Long sessionId) {
        super(ErrorMessageKeys.STUDY_SESSION_NOT_FOUND, sessionId);
    }
}
