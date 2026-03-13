package com.lumos.study.service.impl;

import java.time.Instant;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.exception.UnauthorizedAccessException;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.exception.DeckNotFoundException;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.flashcard.repository.FlashcardRepository;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.dto.request.StartStudySessionRequest;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.dto.response.ProgressSummaryResponse;
import com.lumos.study.dto.response.SpeechCapabilityResponse;
import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.dto.response.StudySessionItemResponse;
import com.lumos.study.dto.response.StudySessionResponse;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.entity.StudyAttempt;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.entity.UserSpeechPreference;
import com.lumos.study.mode.StudyModeStrategy;
import com.lumos.study.mode.StudyModeStrategyFactory;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudySessionType;
import com.lumos.study.exception.StudyCommandNotAllowedException;
import com.lumos.study.exception.StudySessionNotFoundException;
import com.lumos.study.exception.StudySessionUnavailableException;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudyAttemptRepository;
import com.lumos.study.repository.StudySessionItemRepository;
import com.lumos.study.repository.StudySessionRepository;
import com.lumos.study.repository.UserSpeechPreferenceRepository;
import com.lumos.study.service.StudySessionService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StudySessionServiceImpl implements StudySessionService {

    private static final int FIRST_MODE_INDEX = 0;
    private static final String MODE_PLAN_SEPARATOR = ",";

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final UserAccountRepository userAccountRepository;
    private final DeckRepository deckRepository;
    private final FlashcardRepository flashcardRepository;
    private final StudySessionRepository studySessionRepository;
    private final StudySessionItemRepository studySessionItemRepository;
    private final StudyAttemptRepository studyAttemptRepository;
    private final LearningCardStateRepository learningCardStateRepository;
    private final UserSpeechPreferenceRepository userSpeechPreferenceRepository;
    private final StudyModeStrategyFactory studyModeStrategyFactory;

    /**
     * Start a canonical study session for the requested deck.
     *
     * @param request session creation payload
     * @return created study session response
     */
    @Override
    @Transactional
    public StudySessionResponse startSession(StartStudySessionRequest request) {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final UserAccount userAccount = this.userAccountRepository.findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(UnauthorizedAccessException::new);
        final Deck deck = this.deckRepository.findByIdAndDeletedAtIsNull(request.deckId())
                .orElseThrow(() -> new DeckNotFoundException(request.deckId()));
        final List<Flashcard> flashcards = this.flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(
                request.deckId());
        // Reject session creation when the selected deck has no active flashcards.
        if (flashcards.isEmpty()) {
            throw new StudySessionUnavailableException();
        }

        final Map<Long, LearningCardState> learningStateByFlashcardId = resolveLearningStateByFlashcardId(
                userId,
                flashcards);
        final List<Flashcard> newFlashcards = flashcards.stream()
                .filter(flashcard -> !learningStateByFlashcardId.containsKey(flashcard.getId()))
                .toList();
        final List<Flashcard> dueFlashcards = flashcards.stream()
                .filter(flashcard -> isDue(learningStateByFlashcardId.get(flashcard.getId())))
                .sorted(Comparator.comparing(flashcard -> learningStateByFlashcardId.get(flashcard.getId()).getBoxIndex()))
                .toList();
        final StudySessionType sessionType = resolveSessionType(newFlashcards, dueFlashcards);
        final List<Flashcard> selectedFlashcards = resolveSelectedFlashcards(sessionType, newFlashcards, dueFlashcards);
        // Reject session creation when no flashcards match the selected session type.
        if (selectedFlashcards.isEmpty()) {
            throw new StudySessionUnavailableException();
        }

        final List<StudyMode> modePlan = resolveModePlan(sessionType);
        final StudySession session = new StudySession();
        session.setUserAccount(userAccount);
        session.setDeck(deck);
        session.setSessionType(sessionType);
        session.setModePlan(joinModePlan(modePlan));
        session.setCurrentModeIndex(FIRST_MODE_INDEX);
        session.setActiveMode(modePlan.get(FIRST_MODE_INDEX));
        session.setModeState(StudyModeLifecycleState.INITIALIZED);
        session.setCurrentItemIndex(FIRST_MODE_INDEX);
        session.setSessionCompleted(Boolean.FALSE);
        final StudySession savedSession = this.studySessionRepository.save(session);
        createSessionItems(savedSession, selectedFlashcards);
        return buildResponse(savedSession);
    }

    /**
     * Resume a previously created study session.
     *
     * @param sessionId study session identifier
     * @return resumed study session response
     */
    @Override
    @Transactional(readOnly = true)
    public StudySessionResponse resumeSession(Long sessionId) {
        final StudySession session = resolveSession(sessionId);
        return buildResponse(session);
    }

    /**
     * Submit an answer for the current study item.
     *
     * @param sessionId study session identifier
     * @param request   answer submission payload
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse submitAnswer(Long sessionId, SubmitAnswerRequest request) {
        final StudySession session = resolveSession(sessionId);
        final StudySessionItem currentItem = resolveCurrentItem(session);
        final StudyModeStrategy studyModeStrategy = resolveStudyModeStrategy(session.getActiveMode());
        final ReviewOutcome outcome = studyModeStrategy.evaluateAnswer(currentItem, request.answer());
        applyOutcome(session, currentItem, outcome, request.answer());
        return buildResponse(session);
    }

    /**
     * Reveal the answer for the current study item.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse revealAnswer(Long sessionId) {
        final StudySession session = resolveSession(sessionId);
        final StudySessionItem currentItem = resolveCurrentItem(session);
        currentItem.setLastOutcome(ReviewOutcome.REVEALED_WITHOUT_PASS);
        currentItem.setCurrentModeCompleted(Boolean.FALSE);
        currentItem.setRetryPending(Boolean.TRUE);
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);
        return buildResponse(session);
    }

    /**
     * Mark the current study item as remembered.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse markRemembered(Long sessionId) {
        final StudySession session = resolveSession(sessionId);
        final StudySessionItem currentItem = resolveCurrentItem(session);
        applyOutcome(session, currentItem, ReviewOutcome.PASSED, null);
        return buildResponse(session);
    }

    /**
     * Move the current study item into the retry queue.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse retryItem(Long sessionId) {
        final StudySession session = resolveSession(sessionId);
        final StudySessionItem currentItem = resolveCurrentItem(session);
        applyOutcome(session, currentItem, ReviewOutcome.FAILED, null);
        session.setModeState(StudyModeLifecycleState.RETRY_PENDING);
        return buildResponse(session);
    }

    /**
     * Advance the session to the next canonical item or mode.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse goNext(Long sessionId) {
        final StudySession session = resolveSession(sessionId);
        final StudySessionItem currentItem = resolveCurrentItem(session);
        // Persist the reveal-only outcome before moving away from the current item.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK
                && currentItem.getLastOutcome() == ReviewOutcome.REVEALED_WITHOUT_PASS) {
            saveAttempt(session, currentItem, ReviewOutcome.REVEALED_WITHOUT_PASS, null);
        }

        final List<StudySessionItem> items = resolveSessionItems(session);
        final Integer nextSequenceIndex = findNextSequenceIndex(items, currentItem.getSequenceIndex());
        // Continue with the next unfinished item when one is still available.
        if (nextSequenceIndex != null) {
            session.setCurrentItemIndex(nextSequenceIndex);
            session.setModeState(StudyModeLifecycleState.IN_PROGRESS);
            return buildResponse(session);
        }
        // Restart from the retry queue when at least one item still needs another pass.
        if (hasPendingRetry(items)) {
            session.setCurrentItemIndex(findFirstRetrySequenceIndex(items));
            session.setModeState(StudyModeLifecycleState.RETRY_PENDING);
            return buildResponse(session);
        }

        session.setModeState(StudyModeLifecycleState.COMPLETED);
        return completeMode(sessionId);
    }

    /**
     * Complete the current mode when all items satisfy the mode completion rule.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse completeMode(Long sessionId) {
        final StudySession session = resolveSession(sessionId);
        final List<StudySessionItem> items = resolveSessionItems(session);
        final boolean hasUnfinishedItem = items.stream().anyMatch(item -> !item.getCurrentModeCompleted());
        // Reject mode completion when unfinished items remain in the active mode.
        if (hasUnfinishedItem) {
            throw new StudyCommandNotAllowedException();
        }

        final List<StudyMode> modePlan = parseModePlan(session.getModePlan());
        final boolean isLastMode = session.getCurrentModeIndex() >= modePlan.size() - 1;
        // Finalize learning states when the session just completed the last mode.
        if (isLastMode) {
            syncLearningStates(session, items);
            session.setSessionCompleted(Boolean.TRUE);
            session.setModeState(StudyModeLifecycleState.COMPLETED);
            return buildResponse(session);
        }

        moveToNextMode(session, items, modePlan.get(session.getCurrentModeIndex() + 1));
        return buildResponse(session);
    }
    private Map<Long, LearningCardState> resolveLearningStateByFlashcardId(Long userId, List<Flashcard> flashcards) {
        final List<Long> flashcardIds = flashcards.stream().map(Flashcard::getId).toList();
        // Skip the repository lookup when the deck has no flashcard identifiers.
        if (flashcardIds.isEmpty()) {
            return Map.of();
        }
        return this.learningCardStateRepository
                .findAllByUserAccountIdAndFlashcardIdInAndDeletedAtIsNull(userId, flashcardIds)
                .stream()
                .collect(Collectors.toMap(state -> state.getFlashcard().getId(), state -> state));
    }

    private boolean isDue(LearningCardState learningCardState) {
        // Treat missing learning state as not due because the item is still new.
        if (learningCardState == null) {
            return false;
        }
        return !learningCardState.getNextReviewAt().isAfter(Instant.now());
    }

    private StudySessionType resolveSessionType(List<Flashcard> newFlashcards, List<Flashcard> dueFlashcards) {
        // Prefer the full first-learning session whenever the deck still has unseen items.
        if (!newFlashcards.isEmpty()) {
            return StudySessionType.FIRST_LEARNING;
        }
        // Fall back to a review session when only due items remain.
        if (!dueFlashcards.isEmpty()) {
            return StudySessionType.REVIEW;
        }
        throw new StudySessionUnavailableException();
    }

    private List<Flashcard> resolveSelectedFlashcards(
            StudySessionType sessionType,
            List<Flashcard> newFlashcards,
            List<Flashcard> dueFlashcards) {
        return switch (sessionType) {
            case FIRST_LEARNING -> newFlashcards;
            case REVIEW -> dueFlashcards;
        };
    }

    private List<StudyMode> resolveModePlan(StudySessionType sessionType) {
        return switch (sessionType) {
            case FIRST_LEARNING -> StudyConstants.FIRST_LEARNING_MODE_PLAN;
            case REVIEW -> StudyConstants.REVIEW_MODE_PLAN;
        };
    }

    private String joinModePlan(List<StudyMode> modePlan) {
        return modePlan.stream().map(Enum::name).collect(Collectors.joining(MODE_PLAN_SEPARATOR));
    }

    private List<StudyMode> parseModePlan(String rawModePlan) {
        return Arrays.stream(rawModePlan.split(MODE_PLAN_SEPARATOR))
                .map(StudyMode::valueOf)
                .toList();
    }

    private void createSessionItems(StudySession session, List<Flashcard> selectedFlashcards) {
        for (int index = 0; index < selectedFlashcards.size(); index++) {
            final Flashcard flashcard = selectedFlashcards.get(index);
            final StudySessionItem item = new StudySessionItem();
            item.setStudySession(session);
            item.setFlashcard(flashcard);
            item.setSequenceIndex(index);
            item.setFrontTextSnapshot(flashcard.getFrontText());
            item.setBackTextSnapshot(flashcard.getBackText());
            item.setNoteSnapshot(StringUtils.defaultString(flashcard.getNote()));
            item.setPronunciationSnapshot(StringUtils.defaultString(flashcard.getPronunciation()));
            item.setLastOutcome(ReviewOutcome.SKIPPED);
            item.setCurrentModeCompleted(Boolean.FALSE);
            item.setRetryPending(Boolean.FALSE);
            this.studySessionItemRepository.save(item);
        }
    }

    private StudySession resolveSession(Long sessionId) {
        final StudySession session = this.studySessionRepository.findByIdAndDeletedAtIsNull(sessionId)
                .orElseThrow(() -> new StudySessionNotFoundException(sessionId));
        final Long currentUserId = this.authenticatedUserProvider.getCurrentUserId();
        // Reject access to sessions that do not belong to the current authenticated user.
        if (session.getUserAccount() == null || !Objects.deepEquals(currentUserId, session.getUserAccount().getId())) {
            throw new StudySessionNotFoundException(sessionId);
        }
        return session;
    }

    private List<StudySessionItem> resolveSessionItems(StudySession session) {
        return this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(
                session.getId());
    }

    private StudySessionItem resolveCurrentItem(StudySession session) {
        final List<StudySessionItem> items = resolveSessionItems(session);
        return items.stream()
                .filter(item -> Objects.deepEquals(item.getSequenceIndex(), session.getCurrentItemIndex()))
                .findFirst()
                .orElseThrow(StudyCommandNotAllowedException::new);
    }

    private void applyOutcome(
            StudySession session,
            StudySessionItem currentItem,
            ReviewOutcome outcome,
            String submittedAnswer) {
        currentItem.setLastOutcome(outcome);
        final boolean isPassed = outcome == ReviewOutcome.PASSED;
        currentItem.setCurrentModeCompleted(isPassed);
        currentItem.setRetryPending(!isPassed);
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);
        saveAttempt(session, currentItem, outcome, submittedAnswer);
    }

    private void saveAttempt(
            StudySession session,
            StudySessionItem currentItem,
            ReviewOutcome outcome,
            String submittedAnswer) {
        final StudyAttempt attempt = new StudyAttempt();
        attempt.setStudySession(session);
        attempt.setFlashcard(currentItem.getFlashcard());
        attempt.setStudyMode(session.getActiveMode());
        attempt.setReviewOutcome(outcome);
        attempt.setSubmittedAnswer(submittedAnswer);
        this.studyAttemptRepository.save(attempt);
    }

    private Integer findNextSequenceIndex(List<StudySessionItem> items, int currentSequenceIndex) {
        return items.stream()
                .filter(item -> item.getSequenceIndex() > currentSequenceIndex)
                .filter(item -> !item.getCurrentModeCompleted())
                .map(StudySessionItem::getSequenceIndex)
                .findFirst()
                .orElse(null);
    }

    private boolean hasPendingRetry(List<StudySessionItem> items) {
        return items.stream().anyMatch(StudySessionItem::getRetryPending);
    }

    private int findFirstRetrySequenceIndex(List<StudySessionItem> items) {
        return items.stream()
                .filter(StudySessionItem::getRetryPending)
                .map(StudySessionItem::getSequenceIndex)
                .findFirst()
                .orElseThrow(StudyCommandNotAllowedException::new);
    }

    private void moveToNextMode(StudySession session, List<StudySessionItem> items, StudyMode nextMode) {
        session.setCurrentModeIndex(session.getCurrentModeIndex() + 1);
        session.setActiveMode(nextMode);
        session.setCurrentItemIndex(FIRST_MODE_INDEX);
        session.setModeState(StudyModeLifecycleState.INITIALIZED);
        for (StudySessionItem item : items) {
            item.setCurrentModeCompleted(Boolean.FALSE);
            item.setRetryPending(Boolean.FALSE);
            item.setLastOutcome(ReviewOutcome.SKIPPED);
        }
    }

    private void syncLearningStates(StudySession session, List<StudySessionItem> items) {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        for (StudySessionItem item : items) {
            final Optional<LearningCardState> existingStateOptional = this.learningCardStateRepository
                    .findByUserAccountIdAndFlashcardIdAndDeletedAtIsNull(userId, item.getFlashcard().getId());
            final LearningCardState state = existingStateOptional.orElseGet(LearningCardState::new);
            final boolean isNewState = existingStateOptional.isEmpty();
            // Initialize long-term learning state when the user completes the item for the first time.
            if (isNewState) {
                state.setUserAccount(session.getUserAccount());
                state.setFlashcard(item.getFlashcard());
                state.setBoxIndex(StudyConstants.MIN_BOX_INDEX);
                state.setConsecutiveSuccessCount(0);
                state.setLapseCount(0);
            }

            final ReviewOutcome outcome = item.getLastOutcome();
            final int nextBoxIndex = resolveNextBoxIndex(state.getBoxIndex(), outcome, isNewState);
            state.setBoxIndex(nextBoxIndex);
            state.setLastReviewedAt(Instant.now());
            state.setLastResult(outcome);
            state.setConsecutiveSuccessCount(resolveSuccessCount(state.getConsecutiveSuccessCount(), outcome));
            state.setLapseCount(resolveLapseCount(state.getLapseCount(), outcome));
            state.setNextReviewAt(resolveNextReviewAt(nextBoxIndex, outcome));
            this.learningCardStateRepository.save(state);
        }
    }

    private int resolveNextBoxIndex(int currentBoxIndex, ReviewOutcome outcome, boolean isNewState) {
        // Keep new learning states in box 1 until a later review can promote them.
        if (isNewState) {
            return StudyConstants.MIN_BOX_INDEX;
        }
        // Promote the item one box when the latest outcome is a pass.
        if (outcome == ReviewOutcome.PASSED) {
            return Math.min(StudyConstants.MAX_BOX_INDEX, currentBoxIndex + 1);
        }
        // Demote the item one box when the latest outcome is a fail.
        if (outcome == ReviewOutcome.FAILED) {
            return Math.max(StudyConstants.MIN_BOX_INDEX, currentBoxIndex - 1);
        }
        return currentBoxIndex;
    }

    private int resolveSuccessCount(int currentCount, ReviewOutcome outcome) {
        // Increase the consecutive success count only for passed outcomes.
        if (outcome == ReviewOutcome.PASSED) {
            return currentCount + 1;
        }
        return 0;
    }

    private int resolveLapseCount(int currentCount, ReviewOutcome outcome) {
        // Increase the lapse counter only when the latest review failed.
        if (outcome == ReviewOutcome.FAILED) {
            return currentCount + 1;
        }
        return currentCount;
    }

    private Instant resolveNextReviewAt(int nextBoxIndex, ReviewOutcome outcome) {
        // Schedule an immediate retry for failed or reveal-only outcomes.
        if (outcome == ReviewOutcome.FAILED || outcome == ReviewOutcome.REVEALED_WITHOUT_PASS) {
            return Instant.now();
        }
        return Instant.now().plus(StudyConstants.intervalForBox(nextBoxIndex));
    }

    private StudySessionResponse buildResponse(StudySession session) {
        final List<StudySessionItem> items = resolveSessionItems(session);
        final StudySessionItem currentItem = resolveCurrentResponseItem(session, items);
        return new StudySessionResponse(
                session.getId(),
                session.getDeck().getId(),
                session.getDeck().getName(),
                session.getSessionType().name(),
                session.getActiveMode().name(),
                session.getModeState().name(),
                parseModePlan(session.getModePlan()).stream().map(Enum::name).toList(),
                resolveStudyModeStrategy(session.getActiveMode()).resolveAllowedActions(session),
                buildProgress(session, items),
                currentItem == null ? null : buildCurrentItemResponse(session, currentItem, items),
                session.getSessionCompleted());
    }

    private StudySessionItem resolveCurrentResponseItem(StudySession session, List<StudySessionItem> items) {
        // Return no current item payload when the session contains no item snapshot.
        if (items.isEmpty()) {
            return null;
        }
        return items.stream()
                .filter(item -> Objects.deepEquals(item.getSequenceIndex(), session.getCurrentItemIndex()))
                .findFirst()
                .orElse(items.get(FIRST_MODE_INDEX));
    }

    private ProgressSummaryResponse buildProgress(StudySession session, List<StudySessionItem> items) {
        final int completedItems = (int) items.stream().filter(StudySessionItem::getCurrentModeCompleted).count();
        final int totalItems = items.size();
        final int completedModes = session.getCurrentModeIndex();
        final int totalModes = parseModePlan(session.getModePlan()).size();
        final double itemProgress = totalItems == 0 ? 0.0D : (double) completedItems / totalItems;
        final double modeProgress = totalModes == 0 ? 0.0D : (double) completedModes / totalModes;
        final double sessionProgress = totalModes == 0
                ? itemProgress
                : ((double) completedModes + itemProgress) / totalModes;
        return new ProgressSummaryResponse(
                completedItems,
                totalItems,
                completedModes,
                totalModes,
                itemProgress,
                modeProgress,
                sessionProgress);
    }

    private StudySessionItemResponse buildCurrentItemResponse(
            StudySession session,
            StudySessionItem currentItem,
            List<StudySessionItem> items) {
        final StudyModeStrategy studyModeStrategy = resolveStudyModeStrategy(session.getActiveMode());
        final String prompt = studyModeStrategy.resolvePrompt(currentItem);
        final String answer = studyModeStrategy.resolveExpectedAnswer(currentItem);
        final List<StudyChoiceResponse> choices = studyModeStrategy.resolveChoices(currentItem, items);
        final UserSpeechPreference speechPreference = resolveSpeechPreference();
        final SpeechCapabilityResponse speechCapability = new SpeechCapabilityResponse(
                speechPreference.getEnabled(),
                speechPreference.getAutoPlay(),
                speechPreference.getEnabled(),
                speechPreference.getLocale(),
                speechPreference.getVoice(),
                speechPreference.getSpeed(),
                prompt);
        return new StudySessionItemResponse(
                currentItem.getFlashcard().getId(),
                prompt,
                answer,
                currentItem.getNoteSnapshot(),
                currentItem.getPronunciationSnapshot(),
                studyModeStrategy.resolveInstruction(),
                studyModeStrategy.resolveInputPlaceholder(),
                choices,
                speechCapability);
    }

    private UserSpeechPreference resolveSpeechPreference() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        return this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(userId)
                .orElseGet(() -> {
                    final UserSpeechPreference preference = new UserSpeechPreference();
                    preference.setEnabled(Boolean.TRUE);
                    preference.setAutoPlay(Boolean.FALSE);
                    preference.setVoice(StudyConstants.DEFAULT_SPEECH_VOICE);
                    preference.setSpeed(StudyConstants.DEFAULT_SPEECH_SPEED);
                    preference.setLocale(StudyConstants.SPEECH_LOCALE);
                    return preference;
                });
    }

    private StudyModeStrategy resolveStudyModeStrategy(StudyMode studyMode) {
        return this.studyModeStrategyFactory.getStrategy(studyMode);
    }
}
