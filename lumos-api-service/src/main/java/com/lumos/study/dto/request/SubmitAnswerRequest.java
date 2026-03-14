package com.lumos.study.dto.request;

import java.util.List;

import jakarta.validation.Valid;

public record SubmitAnswerRequest(
        String answer,
        @Valid List<StudyMatchPairRequest> matchedPairs) {

    public SubmitAnswerRequest(String answer) {
        this(answer, List.of());
    }
}
