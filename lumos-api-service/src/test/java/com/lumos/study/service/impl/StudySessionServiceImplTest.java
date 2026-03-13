package com.lumos.study.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.deck.entity.Deck;
import com.lumos.deck.repository.DeckRepository;
import com.lumos.flashcard.entity.Flashcard;
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

@ExtendWith(MockitoExtension.class)
class StudySessionServiceImplTest {

    private static final Long USER_ID = 7L;
    private static final Long DECK_ID = 3L;
    private static final Long SESSION_ID = 33L;

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

    private StudySessionServiceImpl studySessionService;

    @BeforeEach
    void setUp() {
        final StudyModeStrategyFactory studyModeStrategyFactory = new StudyModeStrategyFactory(List.of(
                new ReviewStudyModeStrategy(),
                new MatchStudyModeStrategy(),
                new GuessStudyModeStrategy(),
                new RecallStudyModeStrategy(),
                new FillStudyModeStrategy()));
        this.studySessionService = new StudySessionServiceImpl(
                this.authenticatedUserProvider,
                this.userAccountRepository,
                this.deckRepository,
                this.flashcardRepository,
                this.studySessionRepository,
                this.studySessionItemRepository,
                this.studyAttemptRepository,
                this.learningCardStateRepository,
                this.userSpeechPreferenceRepository,
                studyModeStrategyFactory);
    }

    @Test
    void startSession_createsFirstLearningSessionForNewFlashcards() {
        final UserAccount user = user();
        final Deck deck = deck();
        final Flashcard flashcard = flashcard(101L, deck, "안녕하세요", "xin chao");
        final StudySession savedSession = session(user, deck, StudySessionType.FIRST_LEARNING, StudyMode.REVIEW,
                StudyModeLifecycleState.INITIALIZED, 0, 0, false);
        savedSession.setId(SESSION_ID);
        savedSession.setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        final StudySessionItem item = sessionItem(1L, savedSession, flashcard, 0, false, false, ReviewOutcome.SKIPPED);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.of(user));
        when(this.deckRepository.findByIdAndDeletedAtIsNull(DECK_ID)).thenReturn(Optional.of(deck));
        when(this.flashcardRepository.findAllByDeckIdAndDeletedAtIsNullOrderByIdAsc(DECK_ID)).thenReturn(List.of(flashcard));
        when(this.learningCardStateRepository.findAllByUserAccountIdAndFlashcardIdInAndDeletedAtIsNull(USER_ID,
                List.of(101L))).thenReturn(List.of());
        when(this.studySessionRepository.save(any(StudySession.class))).thenReturn(savedSession);
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.startSession(new StartStudySessionRequest(DECK_ID));

        assertEquals("FIRST_LEARNING", response.sessionType());
        assertEquals("REVIEW", response.activeMode());
        assertEquals(5, response.modePlan().size());
        assertEquals("안녕하세요", response.currentItem().prompt());
    }

    @Test
    void resumeSession_returnsExistingSession() {
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, ReviewOutcome.SKIPPED, false, false);
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
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, ReviewOutcome.SKIPPED, false, false);
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
    void revealAnswer_marksRetryPendingAndWaitingFeedback() {
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, ReviewOutcome.SKIPPED, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.revealAnswer(SESSION_ID);

        assertEquals("WAITING_FEEDBACK", response.modeState());
        assertEquals(ReviewOutcome.REVEALED_WITHOUT_PASS, item.getLastOutcome());
        assertTrue(item.getRetryPending());
    }

    @Test
    void markRemembered_marksCurrentItemAsCompleted() {
        final StudySession session = activeSession();
        final StudySessionItem item = currentItem(session, ReviewOutcome.SKIPPED, false, false);
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
        final StudySessionItem item = currentItem(session, ReviewOutcome.SKIPPED, false, false);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.studySessionRepository.findByIdAndDeletedAtIsNull(SESSION_ID)).thenReturn(Optional.of(session));
        when(this.studySessionItemRepository.findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(SESSION_ID))
                .thenReturn(List.of(item));
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.empty());

        final var response = this.studySessionService.retryItem(SESSION_ID);

        assertEquals("RETRY_PENDING", response.modeState());
        assertFalse(item.getCurrentModeCompleted());
        assertTrue(item.getRetryPending());
    }

    @Test
    void goNext_movesToNextAvailableItem() {
        final StudySession session = activeSession();
        final StudySessionItem firstItem = currentItem(session, ReviewOutcome.PASSED, true, false);
        final StudySessionItem secondItem = sessionItem(2L, session, flashcard(102L, session.getDeck(), "감사합니다", "cam on"),
                1, false, false, ReviewOutcome.SKIPPED);
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
    void completeMode_onLastMode_updatesLearningStateAndCompletesSession() {
        final StudySession session = session(user(), deck(), StudySessionType.REVIEW, StudyMode.FILL,
                StudyModeLifecycleState.COMPLETED, 0, 0, false);
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

    private UserAccount user() {
        final UserAccount user = new UserAccount();
        user.setId(USER_ID);
        user.setUsername("tester");
        user.setEmail("tester@mail.com");
        return user;
    }

    private Deck deck() {
        final Deck deck = new Deck();
        deck.setId(DECK_ID);
        deck.setName("Korean Basics");
        return deck;
    }

    private Flashcard flashcard(Long id, Deck deck, String front, String back) {
        final Flashcard flashcard = new Flashcard();
        flashcard.setId(id);
        flashcard.setDeck(deck);
        flashcard.setFrontText(front);
        flashcard.setBackText(back);
        flashcard.setNote("note");
        flashcard.setPronunciation("pronunciation");
        return flashcard;
    }

    private StudySession activeSession() {
        final StudySession session = session(user(), deck(), StudySessionType.FIRST_LEARNING, StudyMode.REVIEW,
                StudyModeLifecycleState.IN_PROGRESS, 0, 0, false);
        session.setId(SESSION_ID);
        session.setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        return session;
    }

    private StudySession session(
            UserAccount user,
            Deck deck,
            StudySessionType sessionType,
            StudyMode activeMode,
            StudyModeLifecycleState modeState,
            int currentModeIndex,
            int currentItemIndex,
            boolean completed) {
        final StudySession session = new StudySession();
        session.setUserAccount(user);
        session.setDeck(deck);
        session.setSessionType(sessionType);
        session.setActiveMode(activeMode);
        session.setModeState(modeState);
        session.setCurrentModeIndex(currentModeIndex);
        session.setCurrentItemIndex(currentItemIndex);
        session.setSessionCompleted(completed);
        return session;
    }

    private StudySessionItem currentItem(
            StudySession session,
            ReviewOutcome outcome,
            boolean completed,
            boolean retryPending) {
        return sessionItem(1L, session, flashcard(101L, session.getDeck(), "안녕하세요", "xin chao"), 0, completed,
                retryPending, outcome);
    }

    private StudySessionItem sessionItem(
            Long itemId,
            StudySession session,
            Flashcard flashcard,
            int sequenceIndex,
            boolean completed,
            boolean retryPending,
            ReviewOutcome outcome) {
        final StudySessionItem item = new StudySessionItem();
        item.setId(itemId);
        item.setStudySession(session);
        item.setFlashcard(flashcard);
        item.setSequenceIndex(sequenceIndex);
        item.setFrontTextSnapshot(flashcard.getFrontText());
        item.setBackTextSnapshot(flashcard.getBackText());
        item.setNoteSnapshot("note");
        item.setPronunciationSnapshot("pronunciation");
        item.setCurrentModeCompleted(completed);
        item.setRetryPending(retryPending);
        item.setLastOutcome(outcome);
        return item;
    }
}
