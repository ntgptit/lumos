package com.lumos.study.dto.response;

import java.util.Map;

public record StudyAnalyticsOverviewResponse(
        long totalLearnedItems,
        long dueCount,
        long overdueCount,
        long passedAttempts,
        long failedAttempts,
        Map<Integer, Long> boxDistribution) {
}
