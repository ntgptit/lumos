package com.lumos.study.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.mapper.StudyInsightResponseMapper;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudyAttemptRepository;

@ExtendWith(MockitoExtension.class)
class StudyInsightServiceImplTest {

    private static final Long USER_ID = 7L;

    @Mock
    private AuthenticatedUserProvider authenticatedUserProvider;

    @Mock
    private LearningCardStateRepository learningCardStateRepository;

    @Mock
    private StudyAttemptRepository studyAttemptRepository;

    private StudyInsightServiceImpl studyInsightService;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        this.studyInsightService = new StudyInsightServiceImpl(
                this.authenticatedUserProvider,
                this.learningCardStateRepository,
                this.studyAttemptRepository,
                new StudyInsightResponseMapper());
    }

    @Test
    void getReminderSummary_returnsRecommendationAndEscalation() {
        final Deck deck = deck(3L, "Korean Basics");
        final Instant now = Instant.now();
        final LearningCardState dueState = learningCardState(deck, 1L, now.minusSeconds(10));
        final LearningCardState overdueState = learningCardState(deck, 2L, now.minusSeconds(200000));
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.learningCardStateRepository.findAllByUserAccountIdAndDeletedAtIsNull(USER_ID))
                .thenReturn(List.of(dueState, overdueState));

        final var response = this.studyInsightService.getReminderSummary();

        assertEquals(2L, response.dueCount());
        assertEquals(1L, response.overdueCount());
        assertEquals("LEVEL_1", response.escalationLevel());
        assertEquals("Korean Basics", response.recommendation().deckName());
        assertEquals("REVIEW", response.recommendation().recommendedSessionType());
    }

    @Test
    void getAnalyticsOverview_returnsCountsAndBoxDistribution() {
        final Deck deck = deck(3L, "Korean Basics");
        final Instant now = Instant.now();
        final LearningCardState dueState = learningCardState(deck, 1L, now.minusSeconds(10));
        final LearningCardState overdueState = learningCardState(deck, 2L, now.minusSeconds(200000));
        overdueState.setBoxIndex(2);
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.learningCardStateRepository.findAllByUserAccountIdAndDeletedAtIsNull(USER_ID))
                .thenReturn(List.of(dueState, overdueState));
        when(this.studyAttemptRepository.countByStudySessionUserAccountIdAndReviewOutcome(USER_ID, ReviewOutcome.PASSED))
                .thenReturn(8L);
        when(this.studyAttemptRepository.countByStudySessionUserAccountIdAndReviewOutcome(USER_ID, ReviewOutcome.FAILED))
                .thenReturn(3L);

        final var response = this.studyInsightService.getAnalyticsOverview();

        assertEquals(2L, response.totalLearnedItems());
        assertEquals(2L, response.dueCount());
        assertEquals(1L, response.overdueCount());
        assertEquals(8L, response.passedAttempts());
        assertEquals(3L, response.failedAttempts());
        assertEquals(1L, response.boxDistribution().get(1));
        assertEquals(1L, response.boxDistribution().get(2));
    }

    private Deck deck(Long id, String name) {
        final Deck deck = new Deck();
        deck.setId(id);
        deck.setName(name);
        
        return deck;
    }

    private LearningCardState learningCardState(Deck deck, Long flashcardId, Instant nextReviewAt) {
        final UserAccount userAccount = new UserAccount();
        userAccount.setId(USER_ID);
        final Flashcard flashcard = new Flashcard();
        flashcard.setId(flashcardId);
        flashcard.setDeck(deck);
        final LearningCardState state = new LearningCardState();
        state.setUserAccount(userAccount);
        state.setFlashcard(flashcard);
        state.setBoxIndex(1);
        state.setNextReviewAt(nextReviewAt);
        state.setLastResult(ReviewOutcome.PASSED);
        state.setConsecutiveSuccessCount(1);
        state.setLapseCount(0);
        
        return state;
    }
}
