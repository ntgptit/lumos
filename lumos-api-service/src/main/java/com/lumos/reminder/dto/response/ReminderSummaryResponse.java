package com.lumos.reminder.dto.response;

import java.util.List;

public record ReminderSummaryResponse(
        long dueCount,
        long overdueCount,
        String escalationLevel,
        List<String> reminderTypes,
        ReminderRecommendationResponse recommendation) {
}
