package com.lumos.study.dto.request;

import jakarta.validation.constraints.NotNull;

public record StartStudySessionRequest(@NotNull Long deckId) {
}
