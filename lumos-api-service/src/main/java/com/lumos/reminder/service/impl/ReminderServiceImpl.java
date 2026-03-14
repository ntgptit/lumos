package com.lumos.reminder.service.impl;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.reminder.dto.response.ReminderRecommendationResponse;
import com.lumos.reminder.dto.response.ReminderSummaryResponse;
import com.lumos.reminder.enums.ReminderEscalationLevel;
import com.lumos.reminder.enums.ReminderType;
import com.lumos.reminder.mapper.ReminderResponseMapper;
import com.lumos.reminder.service.ReminderService;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.repository.LearningCardStateRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReminderServiceImpl implements ReminderService {

    private static final long OVERDUE_THRESHOLD_SECONDS = 86400L;
    private static final int SESSION_MINUTES_DIVISOR = 4;

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final LearningCardStateRepository learningCardStateRepository;
    private final ReminderResponseMapper reminderResponseMapper;

    /**
     * Return reminder counts, escalation level, and the recommended review session.
     *
     * @return reminder summary response
     */
    @Override
    @Transactional(readOnly = true)
    public ReminderSummaryResponse getReminderSummary() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final Instant now = Instant.now();
        final List<LearningCardState> states = this.learningCardStateRepository
                .findAllByUserAccountIdAndDeletedAtIsNull(userId);
        final List<LearningCardState> dueStates = states
                // Filter the user's learning states down to cards that are already due for study.
                .stream()
                .filter(state -> !state.getNextReviewAt().isAfter(now))
                .toList();
        final List<LearningCardState> overdueStates = states
                // Filter the same learning states down to cards that are past the overdue threshold.
                .stream()
                .filter(state -> state.getNextReviewAt().isBefore(now.minusSeconds(OVERDUE_THRESHOLD_SECONDS)))
                .toList();
        final ReminderEscalationLevel escalationLevel = resolveEscalationLevel(overdueStates.size());
        final List<String> reminderTypes = resolveReminderTypes(dueStates.size(), overdueStates.size(), escalationLevel);
        final ReminderRecommendationResponse recommendation = resolveRecommendation(dueStates);
        // Return the reminder summary that drives badges, escalation level, and session recommendation.
        return this.reminderResponseMapper.toReminderSummaryResponse(
                dueStates.size(),
                overdueStates.size(),
                escalationLevel,
                reminderTypes,
                recommendation);
    }

    private ReminderEscalationLevel resolveEscalationLevel(int overdueCount) {
        // Use no escalation when there is no overdue backlog.
        if (overdueCount <= 0) {
            // Return no escalation when the learner has no overdue review debt.
            return ReminderEscalationLevel.NONE;
        }
        // Use level 1 escalation for a small overdue backlog.
        if (overdueCount < 5) {
            // Return the mildest escalation when the overdue backlog is still small.
            return ReminderEscalationLevel.LEVEL_1;
        }
        // Use level 2 escalation for a moderate overdue backlog.
        if (overdueCount < 10) {
            // Return medium escalation when the learner is beginning to accumulate debt.
            return ReminderEscalationLevel.LEVEL_2;
        }
        // Use level 3 escalation for a large overdue backlog.
        if (overdueCount < 20) {
            // Return strong escalation when the backlog is already large.
            return ReminderEscalationLevel.LEVEL_3;
        }
        // Return the highest escalation level when the overdue backlog is severe.
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
        // Return the reminder channels that the current due/overdue situation should surface.
        return reminderTypes;
    }

    private ReminderRecommendationResponse resolveRecommendation(List<LearningCardState> dueStates) {
        // Skip recommendation output when there is no due work to study.
        if (dueStates.isEmpty()) {
            // Return no recommendation when the learner has nothing due to review.
            return null;
        }
        final Map<Long, List<LearningCardState>> statesByDeckId = new HashMap<>();
        // Group due cards by deck so the recommendation can point to one concrete study target.
        for (LearningCardState state : dueStates) {
            final Long deckId = state.getFlashcard().getDeck().getId();
            statesByDeckId.computeIfAbsent(deckId, ignored -> new ArrayList<>()).add(state);
        }
        final Map.Entry<Long, List<LearningCardState>> bestEntry = statesByDeckId.entrySet()
                // Select the deck with the largest due backlog as the current recommendation target.
                .stream()
                .max(Comparator.comparingInt(entry -> entry.getValue().size()))
                .orElse(null);
        // Return no recommendation when no deck grouping can be selected.
        if (bestEntry == null) {
            // Return no recommendation when no due deck bucket can be resolved.
            return null;
        }
        final LearningCardState sample = bestEntry.getValue().get(0);
        final int estimatedSessionMinutes = Math.max(1, bestEntry.getValue().size() / SESSION_MINUTES_DIVISOR);
        // Return the deck-level recommendation used to steer the learner into the next review session.
        return this.reminderResponseMapper.toReminderRecommendationResponse(
                bestEntry.getKey(),
                sample.getFlashcard().getDeck().getName(),
                bestEntry.getValue().size(),
                // Count overdue cards inside the selected deck to show how urgent the recommendation is.
                (int) bestEntry.getValue().stream()
                        .filter(state -> state.getNextReviewAt().isBefore(Instant.now().minusSeconds(OVERDUE_THRESHOLD_SECONDS)))
                        .count(),
                estimatedSessionMinutes,
                "REVIEW");
    }
}
