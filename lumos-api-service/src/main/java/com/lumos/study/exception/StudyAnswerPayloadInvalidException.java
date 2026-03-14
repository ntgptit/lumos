package com.lumos.study.exception;

import com.lumos.common.error.BaseApiException;
import com.lumos.common.error.ErrorMessageKeys;

public class StudyAnswerPayloadInvalidException extends BaseApiException {

    private static final long serialVersionUID = 1L;

    public StudyAnswerPayloadInvalidException() {
        super(ErrorMessageKeys.STUDY_ANSWER_PAYLOAD_INVALID);
    }
}
