package com.lumos.study.service.impl;

import java.util.List;

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
import com.lumos.study.dto.request.StartStudySessionRequest;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.dto.response.StudySessionResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudySessionType;
import com.lumos.study.exception.StudyCommandNotAllowedException;
import com.lumos.study.exception.StudySessionUnavailableException;
import com.lumos.study.mode.StudyModeStrategy;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudyAttemptRepository;
import com.lumos.study.repository.StudySessionRepository;
import com.lumos.study.service.StudySessionService;
import com.lumos.study.support.StudyLearningStateSyncSupport;
import com.lumos.study.support.StudySessionFlowSupport;
import com.lumos.study.support.StudySessionResponseFactory;
import com.lumos.study.support.StudySessionSetupSupport;
import com.lumos.study.support.UserStudyPreferenceSupport;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StudySessionServiceImpl implements StudySessionService {

    private static final int FIRST_MODE_INDEX = 0;
    private static final StudyMode FILL_MODE = StudyMode.FILL;
    private static final StudyMode RECALL_MODE = StudyMode.RECALL;
    private static final StudyModeLifecycleState WAITING_FEEDBACK_STATE = StudyModeLifecycleState.WAITING_FEEDBACK;

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final UserAccountRepository userAccountRepository;
    private final DeckRepository deckRepository;
    private final FlashcardRepository flashcardRepository;
    private final StudySessionRepository studySessionRepository;
    private final LearningCardStateRepository learningCardStateRepository;
    private final StudyAttemptRepository studyAttemptRepository;
    private final StudySessionSetupSupport studySessionSetupSupport;
    private final StudySessionFlowSupport studySessionFlowSupport;
    private final StudyLearningStateSyncSupport studyLearningStateSyncSupport;
    private final StudySessionResponseFactory studySessionResponseFactory;
    private final UserStudyPreferenceSupport userStudyPreferenceSupport;

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
        final List<Flashcard> firstLearningFlashcards = resolveFirstLearningFlashcards(request, userId);
        final List<Flashcard> dueFlashcards = resolveDueFlashcards(
                request,
                userId,
                firstLearningFlashcards);
        final StudySessionType sessionType = resolveSessionType(
                request,
                firstLearningFlashcards,
                dueFlashcards);
        final List<Flashcard> selectedFlashcards = this.studySessionSetupSupport.resolveSelectedFlashcards(
                sessionType,
                firstLearningFlashcards,
                dueFlashcards);
        // Reject session creation when no flashcards match the selected session type.
        if (selectedFlashcards.isEmpty()) {
            // Stop session creation because neither first-learning nor review found a usable item set.
            throw new StudySessionUnavailableException();
        }

        final List<StudyMode> modePlan = this.studySessionSetupSupport.resolveModePlan(sessionType);
        final StudySession session = new StudySession();
        session.setUserAccount(userAccount);
        session.setDeck(deck);
        session.setSessionType(sessionType);
        session.setModePlan(this.studySessionSetupSupport.joinModePlan(modePlan));
        session.setCurrentModeIndex(FIRST_MODE_INDEX);
        session.setActiveMode(modePlan.get(FIRST_MODE_INDEX));
        session.setModeState(StudyModeLifecycleState.INITIALIZED);
        session.setCurrentItemIndex(FIRST_MODE_INDEX);
        session.setSessionCompleted(Boolean.FALSE);
        final StudySession savedSession = this.studySessionRepository.save(session);
        this.studySessionSetupSupport.createSessionItems(savedSession, selectedFlashcards);

        // Return the freshly created session snapshot after persisting the canonical session and item state.
        return this.studySessionResponseFactory.buildResponse(savedSession);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);

        // Return the current canonical snapshot so the client can resume from backend-owned state.
        return this.studySessionResponseFactory.buildResponse(session);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        final StudySessionItem currentItem = this.studySessionFlowSupport.resolveCurrentItem(session, items);
        this.studySessionFlowSupport.ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_SUBMIT_ANSWER);
        final ReviewOutcome outcome = this.studySessionFlowSupport.resolveSubmittedOutcome(
                session,
                currentItem,
                items,
                request);
        this.studySessionFlowSupport.applyOutcome(
                session,
                currentItem,
                items,
                outcome,
                this.studySessionFlowSupport.resolveSubmittedAnswerLog(session, request));

        // Return the updated session snapshot after recording the submitted answer outcome.
        return this.studySessionResponseFactory.buildResponse(session);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        final StudySessionItem currentItem = this.studySessionFlowSupport.resolveCurrentItem(session, items);
        this.studySessionFlowSupport.ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_REVEAL_ANSWER);
        currentItem.setLastOutcome(null);
        currentItem.setCurrentModeCompleted(Boolean.FALSE);
        currentItem.setRetryPending(Boolean.FALSE);
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);

        // Return the waiting-feedback snapshot after exposing the answer for the current item.
        return this.studySessionResponseFactory.buildResponse(session);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        final StudySessionItem currentItem = this.studySessionFlowSupport.resolveCurrentItem(session, items);
        this.studySessionFlowSupport.ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_MARK_REMEMBERED);
        this.studySessionFlowSupport.applyOutcome(
                session,
                currentItem,
                items,
                ReviewOutcome.PASSED,
                null);

        // Return the updated session snapshot after marking the current item as remembered.
        return this.studySessionResponseFactory.buildResponse(session);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        final StudySessionItem currentItem = this.studySessionFlowSupport.resolveCurrentItem(session, items);
        this.studySessionFlowSupport.ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_RETRY_ITEM);
        this.studySessionFlowSupport.applyOutcome(
                session,
                currentItem,
                items,
                ReviewOutcome.FAILED,
                null);

        // Return the updated session snapshot after sending the item into the retry path.
        return this.studySessionResponseFactory.buildResponse(session);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        final StudySessionItem currentItem = this.studySessionFlowSupport.resolveCurrentItem(session, items);
        this.studySessionFlowSupport.ensureActionAllowed(session, currentItem, StudyModeStrategy.ACTION_GO_NEXT);
        // Persist a skipped recall outcome before advancing when the answer was revealed without self-assessment.
        if (shouldSkipRevealedItem(session, currentItem)) {
            this.studySessionFlowSupport.applySkippedOutcome(session, currentItem);
        }
        final Integer nextSequenceIndex = this.studySessionFlowSupport.findNextSequenceIndex(
                items,
                currentItem.getSequenceIndex());
        // Continue with the next unfinished item when one is still available.
        if (nextSequenceIndex != null) {
            session.setCurrentItemIndex(nextSequenceIndex);
            session.setModeState(StudyModeLifecycleState.IN_PROGRESS);

            // Return the session positioned on the next unfinished item in the current mode.
            return this.studySessionResponseFactory.buildResponse(session);
        }
        // Restart from the retry queue when at least one item still needs another pass.
        if (this.studySessionFlowSupport.hasPendingRetry(items)) {
            session.setCurrentItemIndex(this.studySessionFlowSupport.findFirstRetrySequenceIndex(items));
            session.setModeState(StudyModeLifecycleState.RETRY_PENDING);

            // Return the retry snapshot when failed items still need another pass in the same mode.
            return this.studySessionResponseFactory.buildResponse(session);
        }

        session.setModeState(StudyModeLifecycleState.COMPLETED);

        // Return the mode-completion transition when the current mode has no more pending items.
        return completeMode(sessionId);
    }

    /**
     * Reset all progress inside the active mode and return to the first item of that mode.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Override
    @Transactional
    public StudySessionResponse resetCurrentMode(Long sessionId) {
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        final StudySessionItem currentItem = this.studySessionFlowSupport.resolveCurrentItem(session, items);
        this.studySessionFlowSupport.ensureActionAllowed(
                session,
                currentItem,
                StudyModeStrategy.ACTION_RESET_CURRENT_MODE);
        this.studySessionFlowSupport.resetCurrentMode(session, items);
        this.studyAttemptRepository.deleteAllByStudySessionIdAndStudyMode(session.getId(), session.getActiveMode());

        // Return the reset mode snapshot after clearing current-mode progress and attempts.
        return this.studySessionResponseFactory.buildResponse(session);
    }

    private boolean shouldSkipRevealedItem(StudySession session, StudySessionItem currentItem) {
        // Stop early when the active mode is not one of the reveal-first flows that support skip-next.
        if (!isRevealSkipMode(session.getActiveMode())) {
            // Return false because other modes already own explicit submit or feedback outcomes.
            return false;
        }
        // Stop early when the mode is not waiting for feedback because unrevealed items cannot be skipped yet.
        if (session.getModeState() != WAITING_FEEDBACK_STATE) {
            // Return false because skip-next applies only after the answer has been revealed.
            return false;
        }
        // Return true only when the revealed item still has no recorded outcome.
        return currentItem.getLastOutcome() == null;
    }

    private boolean isRevealSkipMode(StudyMode activeMode) {
        // Return true only for reveal-driven modes where nexting after help should record a skipped outcome.
        return activeMode == RECALL_MODE || activeMode == FILL_MODE;
    }

    /**
     * Reset all deck-scoped learning progress for the current user.
     *
     * @param deckId deck identifier
     */
    @Override
    @Transactional
    public void resetDeckProgress(Long deckId) {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        this.deckRepository.findByIdAndDeletedAtIsNull(deckId)
                .orElseThrow(() -> new DeckNotFoundException(deckId));
        final List<Flashcard> flashcards = this.flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(deckId);
        // Collect deck flashcard ids so learning-state deletion stays scoped to the selected deck only.
        final List<Long> flashcardIds = flashcards.stream()
                .map(Flashcard::getId)
                .toList();
        // Stop early when the deck has no active flashcards to reset.
        if (flashcardIds.isEmpty()) {
            // Return because there is no persisted learning state to delete for an empty deck.
            return;
        }
        this.learningCardStateRepository.deleteAllByUserAccountIdAndFlashcardIdIn(userId, flashcardIds);
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
        final StudySession session = this.studySessionFlowSupport.resolveSession(sessionId);
        final List<StudySessionItem> items = this.studySessionFlowSupport.resolveSessionItems(session);
        // Detect unfinished items before allowing the mode cursor to advance.
        final boolean hasUnfinishedItem = this.studySessionFlowSupport.hasUnfinishedItem(items);
        // Reject mode completion when unfinished items remain in the active mode.
        if (hasUnfinishedItem) {
            // Stop mode completion because at least one item has not satisfied the active-mode rule yet.
            throw new StudyCommandNotAllowedException();
        }

        final List<StudyMode> modePlan = this.studySessionSetupSupport.parseModePlan(session.getModePlan());
        final boolean isLastMode = session.getCurrentModeIndex() >= modePlan.size() - 1;
        // Finalize learning states when the session just completed the last mode.
        if (isLastMode) {
            this.studyLearningStateSyncSupport.syncLearningStates(session, items);
            session.setSessionCompleted(Boolean.TRUE);
            session.setModeState(StudyModeLifecycleState.COMPLETED);

            // Return the fully completed session snapshot after syncing long-term learning state.
            return this.studySessionResponseFactory.buildResponse(session);
        }

        this.studySessionFlowSupport.moveToNextMode(session, items, modePlan.get(session.getCurrentModeIndex() + 1));

        // Return the reset session snapshot for the next mode in the canonical mode plan.
        return this.studySessionResponseFactory.buildResponse(session);
    }

    private StudySessionType resolveSessionType(
            StartStudySessionRequest request,
            List<Flashcard> firstLearningFlashcards,
            List<Flashcard> dueFlashcards) {
        // Respect the explicit session type requested by the client when one is provided.
        if (request.preferredSessionType() != null) {
            // Return the client-requested session type so manual learn-entry choices override auto selection.
            return request.preferredSessionType();
        }
        // Return the backend-selected session type when the client leaves session-type selection automatic.
        return this.studySessionSetupSupport.resolveSessionType(firstLearningFlashcards, dueFlashcards);
    }

    private List<Flashcard> resolveFirstLearningFlashcards(StartStudySessionRequest request, Long userId) {
        // Skip first-learning candidate lookup when the client explicitly requested a review session.
        if (request.preferredSessionType() == StudySessionType.REVIEW) {
            // Return an empty list because review-only entry should not load new-card candidates.
            return List.of();
        }
        final int firstLearningCardLimit = this.userStudyPreferenceSupport.resolveFirstLearningCardLimit(userId);
        // Return the DB-limited first-learning candidates that respect the user's configured session size.
        return this.studySessionSetupSupport.resolveFirstLearningFlashcards(
                userId,
                request.deckId(),
                firstLearningCardLimit);
    }

    private List<Flashcard> resolveDueFlashcards(
            StartStudySessionRequest request,
            Long userId,
            List<Flashcard> firstLearningFlashcards) {
        // Skip due-card lookup when the client explicitly requested a first-learning session.
        if (request.preferredSessionType() == StudySessionType.FIRST_LEARNING) {
            // Return an empty list because first-learning entry should not load review candidates.
            return List.of();
        }
        // Skip due-card lookup when automatic session selection already found first-learning candidates.
        if (!firstLearningFlashcards.isEmpty()) {
            // Return an empty list because automatic selection should stay on first-learning while new cards exist.
            return List.of();
        }
        // Return all due review cards because review sessions must keep the existing deadline-driven behavior.
        return this.studySessionSetupSupport.resolveDueFlashcards(userId, request.deckId());
    }
}
