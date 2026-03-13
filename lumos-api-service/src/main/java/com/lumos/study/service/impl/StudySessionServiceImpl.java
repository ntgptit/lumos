package com.lumos.study.service.impl;

import java.time.Instant;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import org.apache.commons.lang3.Strings;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

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
import com.lumos.study.dto.request.StudyMatchPairRequest;
import com.lumos.study.dto.response.ProgressSummaryResponse;
import com.lumos.study.dto.response.SpeechCapabilityResponse;
import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.dto.response.StudyMatchPairResponse;
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
import com.lumos.study.exception.StudyAnswerPayloadInvalidException;
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
    private static final String SPEECH_ACTION_PLAY = "play_speech";
    private static final String SPEECH_ACTION_REPLAY = "replay_speech";
    private static final String SPEECH_FIELD_PROMPT = "prompt";
    private static final String SPEECH_SOURCE_TEXT = "text";

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
            // Stop session creation because an empty deck cannot produce any meaningful study flow.
            throw new StudySessionUnavailableException();
        }

        final Map<Long, LearningCardState> learningStateByFlashcardId = resolveLearningStateByFlashcardId(
                userId,
                flashcards);
        // Separate unseen cards so first-learning sessions can traverse the full five-mode pipeline.
        final List<Flashcard> newFlashcards = flashcards.stream()
                .filter(flashcard -> !learningStateByFlashcardId.containsKey(flashcard.getId()))
                .toList();
        // Sort due cards by box so lower-retention items are reviewed before more stable ones.
        final List<Flashcard> dueFlashcards = flashcards.stream()
                .filter(flashcard -> isDue(learningStateByFlashcardId.get(flashcard.getId())))
                .sorted(Comparator.comparing(flashcard -> learningStateByFlashcardId.get(flashcard.getId()).getBoxIndex()))
                .toList();
        final StudySessionType sessionType = resolveSessionType(newFlashcards, dueFlashcards);
        final List<Flashcard> selectedFlashcards = resolveSelectedFlashcards(sessionType, newFlashcards, dueFlashcards);
        // Reject session creation when no flashcards match the selected session type.
        if (selectedFlashcards.isEmpty()) {
            // Stop session creation because neither first-learning nor review found a usable item set.
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

        // Return the freshly created session snapshot after persisting the canonical session and item state.
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

        // Return the current canonical snapshot so the client can resume from backend-owned state.
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
        final List<StudySessionItem> items = resolveSessionItems(session);
        final StudySessionItem currentItem = resolveCurrentItem(session, items);
        final StudyModeStrategy studyModeStrategy = resolveStudyModeStrategy(session.getActiveMode());
        ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_SUBMIT_ANSWER);
        final ReviewOutcome outcome = resolveSubmittedOutcome(studyModeStrategy, session, currentItem, items, request);
        applyOutcome(session, currentItem, outcome, resolveSubmittedAnswerLog(session, request));

        // Return the updated session snapshot after recording the submitted answer outcome.
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
        ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_REVEAL_ANSWER);
        currentItem.setLastOutcome(null);
        currentItem.setCurrentModeCompleted(Boolean.FALSE);
        currentItem.setRetryPending(Boolean.FALSE);
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);

        // Return the waiting-feedback snapshot after exposing the answer for the current item.
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
        ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_MARK_REMEMBERED);
        applyOutcome(session, currentItem, ReviewOutcome.PASSED, null);

        // Return the updated session snapshot after marking the current item as remembered.
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
        ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_RETRY_ITEM);
        applyOutcome(session, currentItem, ReviewOutcome.FAILED, null);

        // Return the updated session snapshot after sending the item into the retry path.
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
        ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_GO_NEXT);

        final List<StudySessionItem> items = resolveSessionItems(session);
        final Integer nextSequenceIndex = findNextSequenceIndex(items, currentItem.getSequenceIndex());
        // Continue with the next unfinished item when one is still available.
        if (nextSequenceIndex != null) {
            session.setCurrentItemIndex(nextSequenceIndex);
            session.setModeState(StudyModeLifecycleState.IN_PROGRESS);

            // Return the session positioned on the next unfinished item in the current mode.
            return buildResponse(session);
        }
        // Restart from the retry queue when at least one item still needs another pass.
        if (hasPendingRetry(items)) {
            session.setCurrentItemIndex(findFirstRetrySequenceIndex(items));
            session.setModeState(StudyModeLifecycleState.RETRY_PENDING);

            // Return the retry snapshot when failed items still need another pass in the same mode.
            return buildResponse(session);
        }

        session.setModeState(StudyModeLifecycleState.COMPLETED);

        // Return the mode-completion transition when the current mode has no more pending items.
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
        // Detect unfinished items before allowing the mode cursor to advance.
        final boolean hasUnfinishedItem = items.stream().anyMatch(item -> !item.getCurrentModeCompleted());
        // Reject mode completion when unfinished items remain in the active mode.
        if (hasUnfinishedItem) {
            // Stop mode completion because at least one item has not satisfied the active-mode rule yet.
            throw new StudyCommandNotAllowedException();
        }

        final List<StudyMode> modePlan = parseModePlan(session.getModePlan());
        final boolean isLastMode = session.getCurrentModeIndex() >= modePlan.size() - 1;
        // Finalize learning states when the session just completed the last mode.
        if (isLastMode) {
            syncLearningStates(session, items);
            session.setSessionCompleted(Boolean.TRUE);
            session.setModeState(StudyModeLifecycleState.COMPLETED);

            // Return the fully completed session snapshot after syncing long-term learning state.
            return buildResponse(session);
        }

        moveToNextMode(session, items, modePlan.get(session.getCurrentModeIndex() + 1));

        // Return the reset session snapshot for the next mode in the canonical mode plan.
        return buildResponse(session);
    }
    private Map<Long, LearningCardState> resolveLearningStateByFlashcardId(Long userId, List<Flashcard> flashcards) {
        // Collect the flashcard ids so the repository can load existing learning state in one query.
        final List<Long> flashcardIds = flashcards.stream().map(Flashcard::getId).toList();
        // Skip the repository lookup when the deck has no flashcard identifiers.
        if (flashcardIds.isEmpty()) {

            // Return an empty lookup map when the deck currently has no flashcards to resolve.
            return Map.of();
        }

        // Return the learning-state map keyed by flashcard id for due/new classification during session creation.
        return this.learningCardStateRepository
                .findAllByUserAccountIdAndFlashcardIdInAndDeletedAtIsNull(userId, flashcardIds)
                // Index the fetched learning states by flashcard id for constant-time lookup.
                .stream()
                .collect(Collectors.toMap(state -> state.getFlashcard().getId(), state -> state));
    }

    private boolean isDue(LearningCardState learningCardState) {
        // Treat missing learning state as not due because the item is still new.
        if (learningCardState == null) {

            // Return false so unseen cards are classified as first-learning candidates instead of due review.
            return false;
        }

        // Return whether the existing learning state has already reached its next-review timestamp.
        return !learningCardState.getNextReviewAt().isAfter(Instant.now());
    }

    private StudySessionType resolveSessionType(List<Flashcard> newFlashcards, List<Flashcard> dueFlashcards) {
        // Prefer the full first-learning session whenever the deck still has unseen items.
        if (!newFlashcards.isEmpty()) {

            // Return the first-learning flow so new cards traverse the full five-mode plan.
            return StudySessionType.FIRST_LEARNING;
        }
        // Fall back to a review session when only due items remain.
        if (!dueFlashcards.isEmpty()) {

            // Return the review flow so due cards go straight into the review-specific mode plan.
            return StudySessionType.REVIEW;
        }
        // Stop session creation because the deck has neither unseen cards nor cards due for review.
        throw new StudySessionUnavailableException();
    }

    private List<Flashcard> resolveSelectedFlashcards(
            StudySessionType sessionType,
            List<Flashcard> newFlashcards,
            List<Flashcard> dueFlashcards) {

        // Return the flashcard slice that matches the chosen session type.
        return switch (sessionType) {
            case FIRST_LEARNING -> newFlashcards;
            case REVIEW -> dueFlashcards;
        };
    }

    private List<StudyMode> resolveModePlan(StudySessionType sessionType) {

        // Return the canonical mode plan that belongs to the resolved session type.
        return switch (sessionType) {
            case FIRST_LEARNING -> StudyConstants.FIRST_LEARNING_MODE_PLAN;
            case REVIEW -> StudyConstants.REVIEW_MODE_PLAN;
        };
    }

    private String joinModePlan(List<StudyMode> modePlan) {
        // Serialize the mode plan into the compact database representation stored on the session row.
        return modePlan.stream().map(Enum::name).collect(Collectors.joining(MODE_PLAN_SEPARATOR));
    }

    private List<StudyMode> parseModePlan(String rawModePlan) {
        // Parse the stored mode-plan string back into the ordered enum list used at runtime.
        return Arrays.stream(rawModePlan.split(MODE_PLAN_SEPARATOR))
                .map(StudyMode::valueOf)
                .toList();
    }

    private void createSessionItems(StudySession session, List<Flashcard> selectedFlashcards) {
        // Create a snapshot item row for every flashcard selected into the canonical session order.
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
            item.setLastOutcome(null);
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
            // Stop access because users must not observe or mutate sessions owned by another account.
            throw new StudySessionNotFoundException(sessionId);
        }

        // Return the session only after confirming it belongs to the currently authenticated user.
        return session;
    }

    private List<StudySessionItem> resolveSessionItems(StudySession session) {

        // Return the session items in canonical sequence order for navigation and progress calculation.
        return this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(
                session.getId());
    }

    private StudySessionItem resolveCurrentItem(StudySession session) {
        final List<StudySessionItem> items = resolveSessionItems(session);

        // Return the current item by resolving it against the full ordered item list once.
        return resolveCurrentItem(session, items);
    }

    private StudySessionItem resolveCurrentItem(StudySession session, List<StudySessionItem> items) {
        // Select the item whose sequence index matches the session cursor.
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
        // Find the next unfinished item that appears after the current sequence position.
        return items.stream()
                .filter(item -> item.getSequenceIndex() > currentSequenceIndex)
                .filter(item -> !item.getCurrentModeCompleted())
                .map(StudySessionItem::getSequenceIndex)
                .findFirst()
                .orElse(null);
    }

    private boolean hasPendingRetry(List<StudySessionItem> items) {
        // Check whether the current mode still has any item waiting in the retry queue.
        return items.stream().anyMatch(StudySessionItem::getRetryPending);
    }

    private int findFirstRetrySequenceIndex(List<StudySessionItem> items) {
        // Locate the first retry-pending item so the session can restart from the retry queue.
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
        // Reset per-mode item flags so the next mode starts with a clean interaction state.
        for (StudySessionItem item : items) {
            item.setCurrentModeCompleted(Boolean.FALSE);
            item.setRetryPending(Boolean.FALSE);
            item.setLastOutcome(null);
        }
    }

    private void syncLearningStates(StudySession session, List<StudySessionItem> items) {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        // Sync each session item back into its long-term spaced-repetition record when the session ends.
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
                state.setLastReviewedAt(null);
                state.setLastResult(null);
                state.setNextReviewAt(Instant.now());
                this.learningCardStateRepository.save(state);
                continue;
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

            // Return box 1 so a newly learned card starts at the first SRS level.
            return StudyConstants.MIN_BOX_INDEX;
        }
        // Promote the item one box when the latest outcome is a pass.
        if (outcome == ReviewOutcome.PASSED) {

            // Return the promoted box while respecting the configured upper bound.
            return Math.min(StudyConstants.MAX_BOX_INDEX, currentBoxIndex + 1);
        }
        // Demote the item one box when the latest outcome is a fail.
        if (outcome == ReviewOutcome.FAILED) {

            // Return the demoted box while respecting the configured lower bound.
            return Math.max(StudyConstants.MIN_BOX_INDEX, currentBoxIndex - 1);
        }

        // Return the current box unchanged when no promotion or demotion rule applies.
        return currentBoxIndex;
    }

    private int resolveSuccessCount(int currentCount, ReviewOutcome outcome) {
        // Increase the consecutive success count only for passed outcomes.
        if (outcome == ReviewOutcome.PASSED) {

            // Return the incremented success streak after a successful review outcome.
            return currentCount + 1;
        }

        // Return zero because any non-pass breaks the consecutive success streak.
        return 0;
    }

    private int resolveLapseCount(int currentCount, ReviewOutcome outcome) {
        // Increase the lapse counter only when the latest review failed.
        if (outcome == ReviewOutcome.FAILED) {

            // Return the incremented lapse count after a failed review outcome.
            return currentCount + 1;
        }

        // Return the existing lapse count because successful outcomes do not add a lapse.
        return currentCount;
    }

    private Instant resolveNextReviewAt(int nextBoxIndex, ReviewOutcome outcome) {
        // Schedule an immediate retry for failed outcomes.
        if (outcome == ReviewOutcome.FAILED) {

            // Return now so failed cards become due immediately instead of waiting for the next interval.
            return Instant.now();
        }

        // Return the next scheduled review timestamp derived from the destination SRS box interval.
        return Instant.now().plus(StudyConstants.intervalForBox(nextBoxIndex));
    }

    private StudySessionResponse buildResponse(StudySession session) {
        final List<StudySessionItem> items = resolveSessionItems(session);
        final StudySessionItem currentItem = resolveCurrentResponseItem(session, items);
        // Return the canonical session snapshot that the frontend renders after every command.
        return new StudySessionResponse(
                session.getId(),
                session.getDeck().getId(),
                session.getDeck().getName(),
                session.getSessionType().name(),
                session.getActiveMode().name(),
                session.getModeState().name(),
                // Expose mode names in order so the client can render the canonical study roadmap.
                parseModePlan(session.getModePlan()).stream().map(Enum::name).toList(),
                currentItem == null
                        ? List.of()
                        : resolveStudyModeStrategy(session.getActiveMode()).resolveAllowedActions(session, currentItem),
                buildProgress(session, items),
                currentItem == null ? null : buildCurrentItemResponse(session, currentItem, items),
                session.getSessionCompleted());
    }

    private StudySessionItem resolveCurrentResponseItem(StudySession session, List<StudySessionItem> items) {
        // Return no current item payload when the session contains no item snapshot.
        if (items.isEmpty()) {
            // Return null so completed or empty sessions do not fabricate a current item payload.
            return null;
        }
        
        // Resolve the item addressed by the session cursor and fall back to the first item if the cursor drifted.
        return items.stream()
                .filter(item -> Objects.deepEquals(item.getSequenceIndex(), session.getCurrentItemIndex()))
                .findFirst()
                .orElse(items.get(FIRST_MODE_INDEX));
    }

    private ProgressSummaryResponse buildProgress(StudySession session, List<StudySessionItem> items) {
        // Count completed items in the active mode so the frontend progress bar matches backend state.
        final int completedItems = (int) items.stream().filter(StudySessionItem::getCurrentModeCompleted).count();
        final int totalItems = items.size();
        final int completedModes = session.getCurrentModeIndex();
        final int totalModes = parseModePlan(session.getModePlan()).size();
        final double itemProgress = totalItems == 0 ? 0.0D : (double) completedItems / totalItems;
        final double modeProgress = totalModes == 0 ? 0.0D : (double) completedModes / totalModes;
        final double sessionProgress = totalModes == 0
                ? itemProgress
                : ((double) completedModes + itemProgress) / totalModes;
        // Return the aggregated progress snapshot that powers the study progress bar and counters.
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
        final List<StudyMatchPairResponse> matchPairs = studyModeStrategy.resolveMatchPairs(currentItem, items);
        final UserSpeechPreference speechPreference = resolveSpeechPreference();
        final SpeechCapabilityResponse speechCapability = buildSpeechCapability(speechPreference, prompt);

        // Return the current item payload that the frontend renders for the active mode.
        return new StudySessionItemResponse(
                currentItem.getFlashcard().getId(),
                prompt,
                answer,
                currentItem.getNoteSnapshot(),
                currentItem.getPronunciationSnapshot(),
                studyModeStrategy.resolveInstruction(),
                studyModeStrategy.resolveInputPlaceholder(),
                choices,
                matchPairs,
                speechCapability);
    }

    private UserSpeechPreference resolveSpeechPreference() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();

        // Return the persisted preference when the user has already configured speech behavior.
        return this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(userId)
                .orElseGet(() -> {
                    final UserSpeechPreference preference = new UserSpeechPreference();
                    preference.setEnabled(Boolean.TRUE);
                    preference.setAutoPlay(Boolean.FALSE);
                    preference.setVoice(StudyConstants.DEFAULT_SPEECH_VOICE);
                    preference.setSpeed(StudyConstants.DEFAULT_SPEECH_SPEED);
                    preference.setLocale(StudyConstants.SPEECH_LOCALE);

                    // Return the in-memory default preference when the user has not saved one yet.
                    return preference;
                });
    }

    private StudyModeStrategy resolveStudyModeStrategy(StudyMode studyMode) {

        // Return the strategy that owns prompt, action, and answer behavior for the active mode.
        return this.studyModeStrategyFactory.getStrategy(studyMode);
    }

    private SpeechCapabilityResponse buildSpeechCapability(UserSpeechPreference speechPreference, String prompt) {
        final boolean available = speechPreference.getEnabled() && StringUtils.isNotBlank(prompt);

        // Return the canonical speech payload so the frontend can render play, replay, and autoplay behavior.
        return new SpeechCapabilityResponse(
                speechPreference.getEnabled(),
                speechPreference.getAutoPlay(),
                available,
                speechPreference.getLocale(),
                speechPreference.getVoice(),
                speechPreference.getSpeed(),
                SPEECH_FIELD_PROMPT,
                SPEECH_SOURCE_TEXT,
                "",
                available ? List.of(SPEECH_ACTION_PLAY, SPEECH_ACTION_REPLAY) : List.of(),
                prompt);
    }

    private ReviewOutcome resolveSubmittedOutcome(
            StudyModeStrategy studyModeStrategy,
            StudySession session,
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            SubmitAnswerRequest request) {
        // Use the pairing payload only for the canonical match mode.
        if (session.getActiveMode() == StudyMode.MATCH) {
            final List<StudyMatchPairRequest> matchedPairs = request.matchedPairs();
            // Reject match submissions when the canonical left-right pairs are missing.
            if (CollectionUtils.isEmpty(matchedPairs)) {
                // Stop submission because MATCH mode requires the full pairing payload instead of free text.
                throw new StudyAnswerPayloadInvalidException();
            }

            // Return the evaluated MATCH outcome after comparing the submitted pairs with the canonical grid.
            return studyModeStrategy.evaluateMatchPairs(currentItem, items, matchedPairs);
        }
        // Reject non-match submissions when the free-form answer payload is blank.
        if (StringUtils.isBlank(request.answer())) {
            // Stop submission because text-based modes require a non-blank answer payload.
            throw new StudyAnswerPayloadInvalidException();
        }

        // Return the outcome produced by the active mode strategy for the submitted free-form answer.
        return studyModeStrategy.evaluateAnswer(currentItem, request.answer());
    }

    private String resolveSubmittedAnswerLog(StudySession session, SubmitAnswerRequest request) {
        // Persist pairing attempts as a compact left:right list for review analytics.
        if (session.getActiveMode() == StudyMode.MATCH) {
            // Flatten the submitted pairs into a compact audit string for attempt history and analytics.
            return request.matchedPairs().stream()
                    .map(pair -> pair.leftId() + ":" + pair.rightId())
                    .collect(Collectors.joining(","));
        }

        // Return the raw typed answer for non-match attempt logging.
        return request.answer();
    }

    private void ensureActionAllowed(StudySession session, StudySessionItem currentItem, String actionId) {
        final StudyModeStrategy studyModeStrategy = resolveStudyModeStrategy(session.getActiveMode());
        final List<String> allowedActions = studyModeStrategy.resolveAllowedActions(session, currentItem);
        // Continue only when the requested command is currently exposed by the active mode.
        if (allowedActions.stream().anyMatch(allowedAction -> Strings.CS.equals(allowedAction, actionId))) {

            // Return immediately because the requested command is valid in the current mode state.
            return;
        }
        // Stop execution because clients must not call commands outside the backend-owned allowed-action set.
        throw new StudyCommandNotAllowedException();
    }
}
