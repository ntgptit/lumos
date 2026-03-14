package com.lumos.study.dto.response;

import java.util.List;

public record StudySessionItemResponse(
        Long flashcardId,
        String prompt,
        String answer,
        String note,
        String pronunciation,
        String instruction,
        String inputPlaceholder,
        List<StudyChoiceResponse> choices,
        List<StudyMatchPairResponse> matchPairs,
        SpeechCapabilityResponse speech) {
}
