package com.lumos.study.dto.response;

public record ReminderRecommendationResponse(
        Long deckId,
        String deckName,
        int dueCount,
        int overdueCount,
        int estimatedSessionMinutes,
        String recommendedSessionType) {
}
