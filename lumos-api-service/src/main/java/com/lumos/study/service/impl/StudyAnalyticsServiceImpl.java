package com.lumos.study.service.impl;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.mapper.StudyAnalyticsResponseMapper;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudyAttemptRepository;
import com.lumos.study.service.StudyAnalyticsService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StudyAnalyticsServiceImpl implements StudyAnalyticsService {

    private static final long OVERDUE_THRESHOLD_SECONDS = 86400L;

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final LearningCardStateRepository learningCardStateRepository;
    private final StudyAttemptRepository studyAttemptRepository;
    private final StudyAnalyticsResponseMapper studyAnalyticsResponseMapper;

    /**
     * Return the long-term spaced repetition analytics overview.
     *
     * @return analytics overview response
     */
    @Override
    @Transactional(readOnly = true)
    public StudyAnalyticsOverviewResponse getAnalyticsOverview() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final Instant now = Instant.now();
        final List<LearningCardState> states = this.learningCardStateRepository
                .findAllByUserAccountIdAndDeletedAtIsNull(userId);
        final Map<Integer, Long> boxDistribution = new HashMap<>();
        // Count how many learned cards currently sit in each SRS box.
        for (LearningCardState state : states) {
            boxDistribution.merge(state.getBoxIndex(), 1L, Long::sum);
        }
        // Count cards that are already due according to their next-review timestamp.
        final long dueCount = states.stream().filter(state -> !state.getNextReviewAt().isAfter(now)).count();
        final long overdueCount = states
                // Count cards that crossed the overdue threshold to measure backlog severity.
                .stream()
                .filter(state -> state.getNextReviewAt().isBefore(now.minusSeconds(OVERDUE_THRESHOLD_SECONDS)))
                .count();
        // Return the analytics overview consumed by the progress screen.
        return this.studyAnalyticsResponseMapper.toStudyAnalyticsOverviewResponse(
                states.size(),
                dueCount,
                overdueCount,
                this.studyAttemptRepository.countByStudySessionUserAccountIdAndReviewOutcome(userId, ReviewOutcome.PASSED),
                this.studyAttemptRepository.countByStudySessionUserAccountIdAndReviewOutcome(userId, ReviewOutcome.FAILED),
                boxDistribution);
    }
}
