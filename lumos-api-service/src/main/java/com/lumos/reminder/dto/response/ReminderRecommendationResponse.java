package com.lumos.reminder.dto.response;

public record ReminderRecommendationResponse(
        Long deckId,
        String deckName,
        int dueCount,
        int overdueCount,
        int estimatedSessionMinutes,
        String recommendedSessionType) {
}
