package com.lumos.study.support;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Strings;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.entity.StudyAttempt;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.exception.StudyAnswerPayloadInvalidException;
import com.lumos.study.exception.StudyCommandNotAllowedException;
import com.lumos.study.exception.StudySessionNotFoundException;
import com.lumos.study.mode.StudyModeStrategy;
import com.lumos.study.mode.StudyModeStrategyFactory;
import com.lumos.study.repository.StudyAttemptRepository;
import com.lumos.study.repository.StudySessionItemRepository;
import com.lumos.study.repository.StudySessionRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StudySessionFlowSupport {

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final StudySessionRepository studySessionRepository;
    private final StudySessionItemRepository studySessionItemRepository;
    private final StudyAttemptRepository studyAttemptRepository;
    private final StudyModeStrategyFactory studyModeStrategyFactory;

    public StudySession resolveSession(Long sessionId) {
        final StudySession session = this.studySessionRepository.findByIdAndDeletedAtIsNull(sessionId)
                .orElseThrow(() -> new StudySessionNotFoundException(sessionId));
        final Long currentUserId = this.authenticatedUserProvider.getCurrentUserId();
        if (session.getUserAccount() == null || !Objects.deepEquals(currentUserId, session.getUserAccount().getId())) {
            throw new StudySessionNotFoundException(sessionId);
        }
        return session;
    }

    public List<StudySessionItem> resolveSessionItems(StudySession session) {
        return this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(
                session.getId());
    }

    public StudySessionItem resolveCurrentItem(StudySession session) {
        return resolveCurrentItem(session, resolveSessionItems(session));
    }

    public StudySessionItem resolveCurrentItem(StudySession session, List<StudySessionItem> items) {
        return items.stream()
                .filter(item -> Objects.deepEquals(item.getSequenceIndex(), session.getCurrentItemIndex()))
                .findFirst()
                .orElseThrow(StudyCommandNotAllowedException::new);
    }

    public void applyOutcome(
            StudySession session,
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            ReviewOutcome outcome,
            String submittedAnswer) {
        final boolean isPassed = outcome == ReviewOutcome.PASSED;
        final List<StudySessionItem> affectedItems = resolveOutcomeItems(
                session,
                currentItem,
                items,
                outcome);
        for (StudySessionItem item : affectedItems) {
            item.setLastOutcome(outcome);
            item.setCurrentModeCompleted(isPassed);
            item.setRetryPending(!isPassed);
        }
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);
        saveAttempts(session, affectedItems, outcome, submittedAnswer);
    }

    public void applySkippedOutcome(StudySession session, StudySessionItem currentItem) {
        currentItem.setLastOutcome(ReviewOutcome.SKIPPED);
        currentItem.setCurrentModeCompleted(Boolean.TRUE);
        currentItem.setRetryPending(Boolean.FALSE);
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);
        saveAttempts(session, List.of(currentItem), ReviewOutcome.SKIPPED, null);
    }

    public Integer findNextSequenceIndex(List<StudySessionItem> items, int currentSequenceIndex) {
        return items.stream()
                .filter(item -> item.getSequenceIndex() > currentSequenceIndex)
                .filter(item -> !item.getCurrentModeCompleted())
                .map(StudySessionItem::getSequenceIndex)
                .findFirst()
                .orElse(null);
    }

    public boolean hasPendingRetry(List<StudySessionItem> items) {
        return items.stream().anyMatch(StudySessionItem::getRetryPending);
    }

    public boolean hasUnfinishedItem(List<StudySessionItem> items) {
        return items.stream().anyMatch(item -> !item.getCurrentModeCompleted());
    }

    public int findFirstRetrySequenceIndex(List<StudySessionItem> items) {
        return items.stream()
                .filter(StudySessionItem::getRetryPending)
                .map(StudySessionItem::getSequenceIndex)
                .findFirst()
                .orElseThrow(StudyCommandNotAllowedException::new);
    }

    public void moveToNextMode(StudySession session, List<StudySessionItem> items, StudyMode nextMode) {
        session.setCurrentModeIndex(session.getCurrentModeIndex() + 1);
        session.setActiveMode(nextMode);
        session.setCurrentItemIndex(0);
        session.setModeState(StudyModeLifecycleState.INITIALIZED);
        for (StudySessionItem item : items) {
            item.setCurrentModeCompleted(Boolean.FALSE);
            item.setRetryPending(Boolean.FALSE);
            item.setLastOutcome(null);
        }
    }

    public void resetCurrentMode(StudySession session, List<StudySessionItem> items) {
        session.setCurrentItemIndex(0);
        session.setModeState(StudyModeLifecycleState.INITIALIZED);
        session.setSessionCompleted(Boolean.FALSE);
        for (StudySessionItem item : items) {
            item.setCurrentModeCompleted(Boolean.FALSE);
            item.setRetryPending(Boolean.FALSE);
            item.setLastOutcome(null);
        }
    }

    public ReviewOutcome resolveSubmittedOutcome(
            StudySession session,
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            SubmitAnswerRequest request) {
        final StudyModeStrategy studyModeStrategy = resolveStudyModeStrategy(session.getActiveMode());
        if (session.getActiveMode() == StudyMode.MATCH) {
            if (CollectionUtils.isEmpty(request.matchedPairs())) {
                throw new StudyAnswerPayloadInvalidException();
            }
            return studyModeStrategy.evaluateMatchPairs(currentItem, items, request.matchedPairs());
        }
        if (StringUtils.isBlank(request.answer())) {
            throw new StudyAnswerPayloadInvalidException();
        }
        return studyModeStrategy.evaluateAnswer(currentItem, request.answer());
    }

    public String resolveSubmittedAnswerLog(StudySession session, SubmitAnswerRequest request) {
        if (session.getActiveMode() == StudyMode.MATCH) {
            return request.matchedPairs().stream()
                    .map(pair -> pair.leftId() + ":" + pair.rightId())
                    .collect(Collectors.joining(","));
        }
        return request.answer();
    }

    public void ensureActionAllowed(StudySession session, StudySessionItem currentItem, String actionId) {
        final List<String> allowedActions = resolveStudyModeStrategy(session.getActiveMode())
                .resolveAllowedActions(session, currentItem);
        if (allowedActions.stream().anyMatch(allowedAction -> Strings.CS.equals(allowedAction, actionId))) {
            return;
        }
        throw new StudyCommandNotAllowedException();
    }

    private StudyModeStrategy resolveStudyModeStrategy(StudyMode studyMode) {
        return this.studyModeStrategyFactory.getStrategy(studyMode);
    }

    private List<StudySessionItem> resolveOutcomeItems(
            StudySession session,
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            ReviewOutcome outcome) {
        if (outcome != ReviewOutcome.PASSED) {
            return List.of(currentItem);
        }
        return resolveStudyModeStrategy(session.getActiveMode()).resolvePassedItems(currentItem, items);
    }

    private void saveAttempts(
            StudySession session,
            List<StudySessionItem> items,
            ReviewOutcome outcome,
            String submittedAnswer) {
        for (StudySessionItem item : items) {
            final StudyAttempt attempt = new StudyAttempt();
            attempt.setStudySession(session);
            attempt.setFlashcard(item.getFlashcard());
            attempt.setStudyMode(session.getActiveMode());
            attempt.setReviewOutcome(outcome);
            attempt.setSubmittedAnswer(submittedAnswer);
            this.studyAttemptRepository.save(attempt);
        }
    }
}
