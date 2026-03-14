package com.lumos.reminder.mapper;

import java.util.List;

import org.springframework.stereotype.Component;

import com.lumos.reminder.dto.response.ReminderRecommendationResponse;
import com.lumos.reminder.dto.response.ReminderSummaryResponse;
import com.lumos.reminder.enums.ReminderEscalationLevel;

@Component
public class ReminderResponseMapper {

    public ReminderSummaryResponse toReminderSummaryResponse(
            int dueCount,
            int overdueCount,
            ReminderEscalationLevel escalationLevel,
            List<String> reminderTypes,
            ReminderRecommendationResponse recommendation) {
        return new ReminderSummaryResponse(
                dueCount,
                overdueCount,
                escalationLevel.name(),
                reminderTypes,
                recommendation);
    }

    public ReminderRecommendationResponse toReminderRecommendationResponse(
            Long deckId,
            String deckName,
            int dueCount,
            int overdueCount,
            int estimatedSessionMinutes,
            String recommendedSessionType) {
        return new ReminderRecommendationResponse(
                deckId,
                deckName,
                dueCount,
                overdueCount,
                estimatedSessionMinutes,
                recommendedSessionType);
    }
}
