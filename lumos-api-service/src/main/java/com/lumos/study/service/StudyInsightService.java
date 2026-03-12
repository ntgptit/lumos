package com.lumos.study.service;

import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;
import com.lumos.study.dto.response.StudyReminderSummaryResponse;

public interface StudyInsightService {

    StudyReminderSummaryResponse getReminderSummary();

    StudyAnalyticsOverviewResponse getAnalyticsOverview();
}
