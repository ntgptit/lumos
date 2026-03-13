package com.lumos.study.support;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Component;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.repository.LearningCardStateRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StudyLearningStateSyncSupport {

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final LearningCardStateRepository learningCardStateRepository;

    public void syncLearningStates(StudySession session, List<StudySessionItem> items) {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        for (StudySessionItem item : items) {
            final Optional<LearningCardState> existingStateOptional = this.learningCardStateRepository
                    .findByUserAccountIdAndFlashcardIdAndDeletedAtIsNull(userId, item.getFlashcard().getId());
            final LearningCardState state = existingStateOptional.orElseGet(LearningCardState::new);
            final boolean isNewState = existingStateOptional.isEmpty();
            if (isNewState) {
                state.setUserAccount(session.getUserAccount());
                state.setFlashcard(item.getFlashcard());
                state.setBoxIndex(StudyConstants.MIN_BOX_INDEX);
                state.setConsecutiveSuccessCount(0);
                state.setLapseCount(0);
                state.setLastReviewedAt(null);
                state.setLastResult(null);
                state.setNextReviewAt(Instant.now());
                this.learningCardStateRepository.save(state);
                continue;
            }

            final ReviewOutcome outcome = item.getLastOutcome();
            // Ignore legacy skipped outcomes so old rows do not mutate the current spaced-repetition state.
            if (outcome == null || outcome == ReviewOutcome.SKIPPED) {
                continue;
            }
            final int nextBoxIndex = resolveNextBoxIndex(state.getBoxIndex(), outcome);
            state.setBoxIndex(nextBoxIndex);
            state.setLastReviewedAt(Instant.now());
            state.setLastResult(outcome);
            state.setConsecutiveSuccessCount(resolveSuccessCount(state.getConsecutiveSuccessCount(), outcome));
            state.setLapseCount(resolveLapseCount(state.getLapseCount(), outcome));
            state.setNextReviewAt(resolveNextReviewAt(nextBoxIndex, outcome));
            this.learningCardStateRepository.save(state);
        }
    }

    private int resolveNextBoxIndex(int currentBoxIndex, ReviewOutcome outcome) {
        if (outcome == ReviewOutcome.PASSED) {
            return Math.min(StudyConstants.MAX_BOX_INDEX, currentBoxIndex + 1);
        }
        if (outcome == ReviewOutcome.FAILED) {
            return Math.max(StudyConstants.MIN_BOX_INDEX, currentBoxIndex - 1);
        }
        return currentBoxIndex;
    }

    private int resolveSuccessCount(int currentCount, ReviewOutcome outcome) {
        if (outcome == ReviewOutcome.PASSED) {
            return currentCount + 1;
        }
        return 0;
    }

    private int resolveLapseCount(int currentCount, ReviewOutcome outcome) {
        if (outcome == ReviewOutcome.FAILED) {
            return currentCount + 1;
        }
        return currentCount;
    }

    private Instant resolveNextReviewAt(int nextBoxIndex, ReviewOutcome outcome) {
        if (outcome == ReviewOutcome.FAILED) {
            return Instant.now();
        }
        return Instant.now().plus(StudyConstants.intervalForBox(nextBoxIndex));
    }
}
