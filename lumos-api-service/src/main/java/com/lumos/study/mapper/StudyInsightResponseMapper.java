package com.lumos.study.mapper;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.lumos.study.dto.response.ReminderRecommendationResponse;
import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;
import com.lumos.study.dto.response.StudyReminderSummaryResponse;
import com.lumos.study.enums.ReminderEscalationLevel;

@Component
public class StudyInsightResponseMapper {

    public StudyReminderSummaryResponse toStudyReminderSummaryResponse(
            int dueCount,
            int overdueCount,
            ReminderEscalationLevel escalationLevel,
            List<String> reminderTypes,
            ReminderRecommendationResponse recommendation) {
        return new StudyReminderSummaryResponse(
                dueCount,
                overdueCount,
                escalationLevel.name(),
                reminderTypes,
                recommendation);
    }

    public StudyAnalyticsOverviewResponse toStudyAnalyticsOverviewResponse(
            int totalLearnedItems,
            long dueCount,
            long overdueCount,
            long passedAttempts,
            long failedAttempts,
            Map<Integer, Long> boxDistribution) {
        return new StudyAnalyticsOverviewResponse(
                totalLearnedItems,
                dueCount,
                overdueCount,
                passedAttempts,
                failedAttempts,
                boxDistribution);
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
