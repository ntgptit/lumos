package com.lumos.study.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class StudyCommandNotAllowedException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public StudyCommandNotAllowedException() {
        super(ErrorMessageKeys.STUDY_COMMAND_NOT_ALLOWED);
    }
}
