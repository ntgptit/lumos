package com.lumos.study.mapper;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;

@Component
public class StudyAnalyticsResponseMapper {

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
}
