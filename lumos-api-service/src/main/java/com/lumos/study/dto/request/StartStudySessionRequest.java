package com.lumos.study.dto.request;

import com.lumos.study.enums.StudySessionType;

import jakarta.validation.constraints.NotNull;

public record StartStudySessionRequest(@NotNull Long deckId, StudySessionType preferredSessionType) {
}
