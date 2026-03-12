package com.lumos.study.dto.response;

import java.util.List;

public record StudySessionResponse(
        Long sessionId,
        Long deckId,
        String deckName,
        String sessionType,
        String activeMode,
        String modeState,
        List<String> modePlan,
        List<String> allowedActions,
        ProgressSummaryResponse progress,
        StudySessionItemResponse currentItem,
        boolean sessionCompleted) {
}
