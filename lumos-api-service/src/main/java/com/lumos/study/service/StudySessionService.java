package com.lumos.study.service;

import com.lumos.study.dto.request.StartStudySessionRequest;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.dto.response.StudySessionResponse;

public interface StudySessionService {

    StudySessionResponse startSession(StartStudySessionRequest request);

    StudySessionResponse resumeSession(Long sessionId);

    StudySessionResponse submitAnswer(Long sessionId, SubmitAnswerRequest request);

    StudySessionResponse revealAnswer(Long sessionId);

    StudySessionResponse markRemembered(Long sessionId);

    StudySessionResponse retryItem(Long sessionId);

    StudySessionResponse goNext(Long sessionId);

    StudySessionResponse completeMode(Long sessionId);
}
