package com.lumos.study.service.impl;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.dto.response.ReminderRecommendationResponse;
import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;
import com.lumos.study.dto.response.StudyReminderSummaryResponse;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.enums.ReminderEscalationLevel;
import com.lumos.study.enums.ReminderType;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudyAttemptRepository;
import com.lumos.study.service.StudyInsightService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StudyInsightServiceImpl implements StudyInsightService {

    private static final long OVERDUE_THRESHOLD_SECONDS = 86400L;
    private static final int SESSION_MINUTES_DIVISOR = 4;

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final LearningCardStateRepository learningCardStateRepository;
    private final StudyAttemptRepository studyAttemptRepository;

    /**
     * Return reminder counts, escalation level, and the recommended review session.
     *
     * @return reminder summary response
     */
    @Override
    @Transactional(readOnly = true)
    public StudyReminderSummaryResponse getReminderSummary() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final Instant now = Instant.now();
        final List<LearningCardState> states = this.learningCardStateRepository
                .findAllByUserAccountIdAndDeletedAtIsNull(userId);
        final List<LearningCardState> dueStates = states
                .stream()
                .filter(state -> !state.getNextReviewAt().isAfter(now))
                .toList();
        final List<LearningCardState> overdueStates = states
                .stream()
                .filter(state -> state.getNextReviewAt().isBefore(now.minusSeconds(OVERDUE_THRESHOLD_SECONDS)))
                .toList();
        final ReminderEscalationLevel escalationLevel = resolveEscalationLevel(overdueStates.size());
        final List<String> reminderTypes = resolveReminderTypes(dueStates.size(), overdueStates.size(), escalationLevel);
        final ReminderRecommendationResponse recommendation = resolveRecommendation(dueStates);
        return new StudyReminderSummaryResponse(
                dueStates.size(),
                overdueStates.size(),
                escalationLevel.name(),
                reminderTypes,
                recommendation);
    }

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
        for (LearningCardState state : states) {
            boxDistribution.merge(state.getBoxIndex(), 1L, Long::sum);
        }
        final long dueCount = states.stream().filter(state -> !state.getNextReviewAt().isAfter(now)).count();
        final long overdueCount = states
                .stream()
                .filter(state -> state.getNextReviewAt().isBefore(now.minusSeconds(OVERDUE_THRESHOLD_SECONDS)))
                .count();
        return new StudyAnalyticsOverviewResponse(
                states.size(),
                dueCount,
                overdueCount,
                this.studyAttemptRepository.countByStudySessionUserAccountIdAndReviewOutcome(userId, ReviewOutcome.PASSED),
                this.studyAttemptRepository.countByStudySessionUserAccountIdAndReviewOutcome(userId, ReviewOutcome.FAILED),
                boxDistribution);
    }

    private ReminderEscalationLevel resolveEscalationLevel(int overdueCount) {
        // Use no escalation when there is no overdue backlog.
        if (overdueCount <= 0) {
            return ReminderEscalationLevel.NONE;
        }
        // Use level 1 escalation for a small overdue backlog.
        if (overdueCount < 5) {
            return ReminderEscalationLevel.LEVEL_1;
        }
        // Use level 2 escalation for a moderate overdue backlog.
        if (overdueCount < 10) {
            return ReminderEscalationLevel.LEVEL_2;
        }
        // Use level 3 escalation for a large overdue backlog.
        if (overdueCount < 20) {
            return ReminderEscalationLevel.LEVEL_3;
        }
        return ReminderEscalationLevel.LEVEL_4;
    }

    private List<String> resolveReminderTypes(int dueCount, int overdueCount, ReminderEscalationLevel escalationLevel) {
        final List<String> reminderTypes = new ArrayList<>();
        // Always surface in-app reminder cues when due or overdue work exists.
        if (dueCount > 0 || overdueCount > 0) {
            reminderTypes.add(ReminderType.IN_APP_BADGE_DUE_LIST.name());
            reminderTypes.add(ReminderType.DUE_BASED_SESSION_RECOMMENDATION.name());
        }
        // Add overdue escalation only when the user actually has overdue backlog.
        if (overdueCount > 0 && escalationLevel != ReminderEscalationLevel.NONE) {
            reminderTypes.add(ReminderType.OVERDUE_ESCALATION.name());
        }
        return reminderTypes;
    }

    private ReminderRecommendationResponse resolveRecommendation(List<LearningCardState> dueStates) {
        // Skip recommendation output when there is no due work to study.
        if (dueStates.isEmpty()) {
            return null;
        }
        final Map<Long, List<LearningCardState>> statesByDeckId = new HashMap<>();
        for (LearningCardState state : dueStates) {
            final Long deckId = state.getFlashcard().getDeck().getId();
            statesByDeckId.computeIfAbsent(deckId, ignored -> new ArrayList<>()).add(state);
        }
        final Map.Entry<Long, List<LearningCardState>> bestEntry = statesByDeckId.entrySet()
                .stream()
                .max(Comparator.comparingInt(entry -> entry.getValue().size()))
                .orElse(null);
        // Return no recommendation when no deck grouping can be selected.
        if (bestEntry == null) {
            return null;
        }
        final LearningCardState sample = bestEntry.getValue().get(0);
        final int estimatedSessionMinutes = Math.max(1, bestEntry.getValue().size() / SESSION_MINUTES_DIVISOR);
        return new ReminderRecommendationResponse(
                bestEntry.getKey(),
                sample.getFlashcard().getDeck().getName(),
                bestEntry.getValue().size(),
                (int) bestEntry.getValue().stream()
                        .filter(state -> state.getNextReviewAt().isBefore(Instant.now().minusSeconds(OVERDUE_THRESHOLD_SECONDS)))
                        .count(),
                estimatedSessionMinutes,
                "REVIEW");
    }
}
