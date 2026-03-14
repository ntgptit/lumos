package com.lumos.study.controller;

import static com.lumos.testkit.StudyTestFixtures.studyAnalyticsOverviewResponse;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.study.service.StudyAnalyticsService;

@ExtendWith(MockitoExtension.class)
class StudyAnalyticsControllerTest {

    @Mock
    private StudyAnalyticsService studyAnalyticsService;

    @InjectMocks
    private StudyAnalyticsController studyAnalyticsController;

    @Test
    void getAnalyticsOverview_returnsOkResponse() {
        final var response = studyAnalyticsOverviewResponse();
        when(this.studyAnalyticsService.getAnalyticsOverview()).thenReturn(response);

        final var entity = this.studyAnalyticsController.getAnalyticsOverview();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }
}
