package com.lumos.study.dto.response;

import java.util.List;

public record StudyReminderSummaryResponse(
        long dueCount,
        long overdueCount,
        String escalationLevel,
        List<String> reminderTypes,
        ReminderRecommendationResponse recommendation) {
}
