package com.lumos.study.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;
import com.lumos.study.service.StudyAnalyticsService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

/**
 * Study analytics endpoints.
 */
@Validated
@RestController
@RequiredArgsConstructor
@Tag(name = "Study Analytics", description = "Study analytics APIs")
public class StudyAnalyticsController {

    private final StudyAnalyticsService studyAnalyticsService;

    /**
     * Return the spaced repetition analytics overview for the current user.
     *
     * @return analytics overview response
     */
    @Operation(summary = "Get analytics overview")
    @GetMapping("/api/v1/study/analytics/overview")
    public ResponseEntity<StudyAnalyticsOverviewResponse> getAnalyticsOverview() {
        final var response = this.studyAnalyticsService.getAnalyticsOverview();
        // Return the analytics overview so the progress UI can render SRS metrics.
        return ResponseEntity.ok(response);
    }
}
