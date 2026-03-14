package com.lumos.study.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class StudySessionUnavailableException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public StudySessionUnavailableException() {
        super(ErrorMessageKeys.STUDY_SESSION_UNAVAILABLE);
    }
}
