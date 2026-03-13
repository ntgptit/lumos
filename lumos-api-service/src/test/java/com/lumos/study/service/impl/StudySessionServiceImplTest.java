package com.lumos.study.service.impl;

import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.DECK_ID;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.SESSION_ID;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.USER_ID;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.activeSession;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.currentItem;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.deck;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.flashcard;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.session;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.sessionItem;
import static com.lumos.study.service.impl.StudySessionServiceTestDataFactory.user;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Optional;
import java.time.Instant;

import org.apache.commons.lang3.Strings;
import org.springframework.data.domain.Pageable;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.flashcard.repository.FlashcardRepository;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.dto.request.StartStudySessionRequest;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.entity.StudyAttempt;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudySessionType;
import com.lumos.study.mode.FillStudyModeStrategy;
import com.lumos.study.mode.GuessStudyModeStrategy;
import com.lumos.study.mode.MatchStudyModeStrategy;
import com.lumos.study.mode.RecallStudyModeStrategy;
import com.lumos.study.mode.ReviewStudyModeStrategy;
import com.lumos.study.mode.StudyModeStrategyFactory;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudyAttemptRepository;
import com.lumos.study.repository.StudySessionItemRepository;
import com.lumos.study.repository.StudySessionRepository;
import com.lumos.study.repository.UserSpeechPreferenceRepository;
import com.lumos.study.support.StudyLearningStateSyncSupport;
import com.lumos.study.support.StudySessionFlowSupport;
import com.lumos.study.support.StudySessionResponseFactory;
import com.lumos.study.support.StudySessionSetupSupport;
import com.lumos.study.support.UserStudyPreferenceSupport;

@ExtendWith(MockitoExtension.class)
class StudySessionServiceImplTest {
    @Mock
    private AuthenticatedUserProvider authenticatedUserProvider;
    @Mock
    private UserAccountRepository userAccountRepository;
    @Mock
    private DeckRepository deckRepository;
    @Mock
    private FlashcardRepository flashcardRepository;
    @Mock
    private StudySessionRepository studySessionRepository;
    @Mock
    private StudySessionItemRepository studySessionItemRepository;
    @Mock
    private StudyAttemptRepository studyAttemptRepository;
    @Mock
    private LearningCardStateRepository learningCardStateRepository;
    @Mock
    private UserSpeechPreferenceRepository userSpeechPreferenceRepository;
    @Mock
    private UserStudyPreferenceSupport userStudyPreferenceSupport;
    private StudySessionServiceImpl studySessionService;

    @BeforeEach
    void setUp() {
        final StudyModeStrategyFactory studyModeStrategyFactory = new StudyModeStrategyFactory(List.of(
                new ReviewStudyModeStrategy(),
                new MatchStudyModeStrategy(),
                new GuessStudyModeStrategy(),
                new RecallStudyModeStrategy(),
                new FillStudyModeStrategy()));
        final StudySessionSetupSupport studySessionSetupSupport = new StudySessionSetupSupport(
                this.flashcardRepository,
                this.studySessionItemRepository);
        final StudySessionFlowSupport studySessionFlowSupport = new StudySessionFlowSupport(
                this.authenticatedUserProvider,
                this.studySessionRepository,
                this.studySessionItemRepository,
                this.studyAttemptRepository,
                studyModeStrategyFactory);
        final StudyLearningStateSyncSupport studyLearningStateSyncSupport = new StudyLearningStateSyncSupport(
                this.authenticatedUserProvider,
                this.learningCardStateRepository);
        final StudySessionResponseFactory studySessionResponseFactory = new StudySessionResponseFactory(
                this.authenticatedUserProvider,
                this.studySessionItemRepository,
                this.userSpeechPreferenceRepository,
                studyModeStrategyFactory,
                studySessionSetupSupport);
        this.studySessionService = new StudySessionServiceImpl(
                this.authenticatedUserProvider,
                this.userAccountRepository,
                this.deckRepository,
                this.flashcardRepository,
                this.studySessionRepository,
                this.learningCardStateRepository,
                this.studyAttemptRepository,
                studySessionSetupSupport,
                studySessionFlowSupport,
                studyLearningStateSyncSupport,
                studySessionResponseFactory,
                this.userStudyPreferenceSupport);
    }

    @Test
    void startSession_createsFirstLearningSessionForNewFlashcards() {
        final var deck = deck();
        final var flashcard = flashcard(101L, deck, "안녕하세요", "xin chao");
        final StudySession savedSession = session(
                user(),
                deck,
                StudySessionType.FIRST_LEARNING,
                StudyMode.REVIEW,
                StudyModeLifecycleState.INITIALIZED,
                0,
                0,
                false);
        savedSession.setId(SESSION_ID);
        savedSession.setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        final StudySessionItem item = sessionItem(1L, savedSession, flashcard, 0, false, false, null);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.of(user()));
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.userStudyPreferenceSupport.resolveFirstLearningCardLimit(USER_ID)).thenReturn(20);
        when(this.flashcardRepository.findFirstLearningFlashcards(eq(USER_ID), eq(DECK_ID), any(Pageable.class)))
                .thenReturn(List.of(flashcard));
        when(this.studySessionRepository.save(any(StudySession.class))).thenReturn(savedSession);
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.startSession(new StartStudySessionRequest(DECK_ID, null));
        assertEquals("FIRST_LEARNING", response.sessionType());
        assertEquals("REVIEW", response.activeMode());
        assertEquals(5, response.modePlan().size());
        assertEquals("안녕하세요", response.currentItem().prompt());
    }

    @Test
    void startSession_respectsPreferredReviewSessionType() {
        final var deck = deck();
        final var learnedFlashcard = flashcard(101L, deck, "안녕하세요", "xin chao");
        final StudySession savedSession = session(
                user(),
                deck,
                StudySessionType.REVIEW,
                StudyMode.FILL,
                StudyModeLifecycleState.INITIALIZED,
                0,
                0,
                false);
        savedSession.setId(SESSION_ID);
        savedSession.setModePlan("FILL");
        final StudySessionItem item = sessionItem(1L, savedSession, learnedFlashcard, 0, false, false, null);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.of(user()));
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.flashcardRepository.findDueReviewFlashcards(eq(USER_ID), eq(DECK_ID), any(Instant.class)))
                .thenReturn(List.of(learnedFlashcard));
        when(this.studySessionRepository.save(any(StudySession.class))).thenReturn(savedSession);
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.startSession(
                new StartStudySessionRequest(DECK_ID, StudySessionType.REVIEW));

        assertEquals("REVIEW", response.sessionType());
        assertEquals("FILL", response.activeMode());
        assertEquals(1, response.modePlan().size());
        verify(this.userStudyPreferenceSupport, never()).resolveFirstLearningCardLimit(USER_ID);
    }

    @Test
    void startSession_limitsFirstLearningCardsUsingStudyPreference() {
        final var deck = deck();
        final var firstFlashcard = flashcard(101L, deck, "안녕하세요", "xin chao");
        final StudySession savedSession = session(
                user(),
                deck,
                StudySessionType.FIRST_LEARNING,
                StudyMode.REVIEW,
                StudyModeLifecycleState.INITIALIZED,
                0,
                0,
                false);
        savedSession.setId(SESSION_ID);
        savedSession.setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        final StudySessionItem item = sessionItem(1L, savedSession, firstFlashcard, 0, false, false, null);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.of(user()));
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.userStudyPreferenceSupport.resolveFirstLearningCardLimit(USER_ID)).thenReturn(1);
        when(this.flashcardRepository.findFirstLearningFlashcards(eq(USER_ID), eq(DECK_ID), any(Pageable.class)))
                .thenReturn(List.of(firstFlashcard));
        when(this.studySessionRepository.save(any(StudySession.class))).thenReturn(savedSession);
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.startSession(new StartStudySessionRequest(DECK_ID, null));

        assertEquals(1, response.progress().totalItems());
        assertEquals(101L, response.currentItem().flashcardId());
        verify(this.userStudyPreferenceSupport).resolveFirstLearningCardLimit(USER_ID);
    }

    @Test
    void startSession_reviewSessionKeepsAllDueCardsInTheSession() {
        final var deck = deck();
        final var firstDueFlashcard = flashcard(101L, deck, "안녕하세요", "xin chao");
        final var secondDueFlashcard = flashcard(102L, deck, "감사합니다", "cam on");
        final StudySession savedSession = session(
                user(),
                deck,
                StudySessionType.REVIEW,
                StudyMode.FILL,
                StudyModeLifecycleState.INITIALIZED,
                0,
                0,
                false);
        savedSession.setId(SESSION_ID);
        savedSession.setModePlan("FILL");
        final StudySessionItem firstItem = sessionItem(1L, savedSession, firstDueFlashcard, 0, false, false, null);
        final StudySessionItem secondItem = sessionItem(2L, savedSession, secondDueFlashcard, 1, false, false, null);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.of(user()));
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.flashcardRepository.findDueReviewFlashcards(eq(USER_ID), eq(DECK_ID), any(Instant.class)))
                .thenReturn(List.of(firstDueFlashcard, secondDueFlashcard));
        when(this.studySessionRepository.save(any(StudySession.class))).thenReturn(savedSession);
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(firstItem, secondItem));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.startSession(
                new StartStudySessionRequest(DECK_ID, StudySessionType.REVIEW));

        assertEquals("REVIEW", response.sessionType());
        assertEquals(2, response.progress().totalItems());
        verify(this.userStudyPreferenceSupport, never()).resolveFirstLearningCardLimit(USER_ID);
    }

    @Test
    void resumeSession_returnsExistingSession() {
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, null, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.resumeSession(SESSION_ID);
        assertEquals(SESSION_ID, response.sessionId());
        assertEquals("REVIEW", response.activeMode());
    }

    @Test
    void submitAnswer_marksPassedAnswerWaitingFeedback() {
        final StudySession session = session(
                user(),
                deck(),
                StudySessionType.REVIEW,
                StudyMode.FILL,
                StudyModeLifecycleState.IN_PROGRESS,
                0,
                0,
                false);
        session.setId(SESSION_ID);
        session.setModePlan("FILL");
        final StudySessionItem item = currentItem(session, null, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.submitAnswer(SESSION_ID, new SubmitAnswerRequest("xin chao"));
        verify(this.studyAttemptRepository).save(any(StudyAttempt.class));
        assertEquals("WAITING_FEEDBACK", response.modeState());
        assertTrue(item.getCurrentModeCompleted());
    }

    @Test
    void revealAnswer_keepsOutcomeEmptyAndMovesToWaitingFeedback() {
        final StudySession session = session(
                user(),
                deck(),
                StudySessionType.FIRST_LEARNING,
                StudyMode.RECALL,
                StudyModeLifecycleState.IN_PROGRESS,
                3,
                0,
                false);
        session.setId(SESSION_ID);
        session.setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        final StudySessionItem item = currentItem(session, null, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.revealAnswer(SESSION_ID);
        assertEquals("WAITING_FEEDBACK", response.modeState());
        assertEquals(null, item.getLastOutcome());
        assertFalse(item.getRetryPending());
    }

    @Test
    void markRemembered_marksCurrentItemAsCompleted() {
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, null, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.markRemembered(SESSION_ID);
        assertEquals("WAITING_FEEDBACK", response.modeState());
        assertTrue(item.getCurrentModeCompleted());
    }

    @Test
    void retryItem_marksCurrentItemForRetry() {
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, null, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.retryItem(SESSION_ID);
        assertEquals("WAITING_FEEDBACK", response.modeState());
        assertFalse(item.getCurrentModeCompleted());
        assertTrue(item.getRetryPending());
    }

    @Test
    void goNext_movesToNextAvailableItem() {
        final StudySession session = activeSession();
        final StudySessionItem firstItem = currentItem(session, ReviewOutcome.PASSED, true, false);
        final StudySessionItem secondItem = sessionItem(
                2L,
                session,
                flashcard(102L, session.getDeck(), "감사합니다", "cam on"),
                1,
                false,
                false,
                null);
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(firstItem, secondItem));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.goNext(SESSION_ID);
        assertEquals("IN_PROGRESS", response.modeState());
        assertEquals(1, session.getCurrentItemIndex());
        assertEquals(102L, response.currentItem().flashcardId());
    }

    @Test
    void resetCurrentMode_clearsModeProgressAndDeletesAttempts() {
        final StudySession session = activeSession();
        session.setModeState(StudyModeLifecycleState.WAITING_FEEDBACK);
        final StudySessionItem firstItem = currentItem(session, ReviewOutcome.PASSED, true, false);
        final StudySessionItem secondItem = sessionItem(
                2L,
                session,
                flashcard(102L, session.getDeck(), "감사합니다", "cam on"),
                1,
                false,
                true,
                ReviewOutcome.FAILED);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(firstItem, secondItem));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.resetCurrentMode(SESSION_ID);

        verify(this.studyAttemptRepository).deleteAllByStudySessionIdAndStudyMode(SESSION_ID, StudyMode.REVIEW);
        assertEquals("INITIALIZED", response.modeState());
        assertEquals(0, session.getCurrentItemIndex());
        assertFalse(firstItem.getCurrentModeCompleted());
        assertFalse(secondItem.getRetryPending());
        assertEquals(null, secondItem.getLastOutcome());
        assertTrue(response.allowedActions().stream()
                .anyMatch(action -> Strings.CS.equals(action, "RESET_CURRENT_MODE")));
    }

    @Test
    void resetDeckProgress_deletesLearningStatesForDeckFlashcards() {
        final var deck = deck();
        final var firstFlashcard = flashcard(101L, deck, "안녕하세요", "xin chao");
        final var secondFlashcard = flashcard(102L, deck, "감사합니다", "cam on");
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(DECK_ID))
                .thenReturn(List.of(firstFlashcard, secondFlashcard));

        this.studySessionService.resetDeckProgress(DECK_ID);

        verify(this.learningCardStateRepository)
                .deleteAllByUserAccountIdAndFlashcardIdIn(USER_ID, List.of(101L, 102L));
    }

    @Test
    void completeMode_onLastMode_updatesLearningStateAndCompletesSession() {
        final StudySession session = session(
                user(),
                deck(),
                StudySessionType.REVIEW,
                StudyMode.FILL,
                StudyModeLifecycleState.COMPLETED,
                0,
                0,
                false);
        session.setId(SESSION_ID);
        session.setModePlan("FILL");
        final StudySessionItem item = currentItem(session, ReviewOutcome.PASSED, true, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.learningCardStateRepository.findByUserAccountIdAndFlashcardIdAndDeletedAtIsNull(USER_ID, 101L))
                .thenReturn(Optional.empty());
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());
        final var response = this.studySessionService.completeMode(SESSION_ID);
        final ArgumentCaptor<LearningCardState> captor = ArgumentCaptor.forClass(LearningCardState.class);
        verify(this.learningCardStateRepository).save(captor.capture());
        assertEquals(Integer.valueOf(StudyConstants.MIN_BOX_INDEX), captor.getValue().getBoxIndex());
        assertTrue(response.sessionCompleted());
        assertEquals("COMPLETED", response.modeState());
    }
}
