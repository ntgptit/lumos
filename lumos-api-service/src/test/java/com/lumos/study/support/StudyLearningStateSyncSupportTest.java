package com.lumos.study.support;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.repository.LearningCardStateRepository;

@ExtendWith(MockitoExtension.class)
class StudyLearningStateSyncSupportTest {

    private static final Long USER_ID = 7L;
    private static final Long FLASHCARD_ID = 101L;

    @Mock
    private AuthenticatedUserProvider authenticatedUserProvider;

    @Mock
    private LearningCardStateRepository learningCardStateRepository;

    @Test
    void syncLearningStates_ignoresLegacySkippedOutcome() {
        final var support = new StudyLearningStateSyncSupport(
                this.authenticatedUserProvider,
                this.learningCardStateRepository);
        final StudySession session = createSession();
        final StudySessionItem skippedItem = createItem(session, ReviewOutcome.SKIPPED);
        final LearningCardState existingState = createExistingState();
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.learningCardStateRepository.findByUserAccountIdAndFlashcardIdAndDeletedAtIsNull(USER_ID, FLASHCARD_ID))
                .thenReturn(Optional.of(existingState));

        support.syncLearningStates(session, List.of(skippedItem));

        assertEquals(2, existingState.getBoxIndex());
        assertEquals(3, existingState.getConsecutiveSuccessCount());
        assertEquals(1, existingState.getLapseCount());
        assertEquals(Instant.parse("2026-03-10T00:00:00Z"), existingState.getNextReviewAt());
        assertEquals(ReviewOutcome.PASSED, existingState.getLastResult());
        verify(this.learningCardStateRepository, never()).save(any(LearningCardState.class));
    }

    private StudySession createSession() {
        final StudySession session = new StudySession();
        session.setUserAccount(createUser());
        return session;
    }

    private StudySessionItem createItem(StudySession session, ReviewOutcome outcome) {
        final StudySessionItem item = new StudySessionItem();
        item.setStudySession(session);
        item.setFlashcard(createFlashcard());
        item.setLastOutcome(outcome);
        item.setIncorrectAttemptCount(0);
        return item;
    }

    private LearningCardState createExistingState() {
        final LearningCardState state = new LearningCardState();
        state.setUserAccount(createUser());
        state.setFlashcard(createFlashcard());
        state.setBoxIndex(2);
        state.setLastReviewedAt(Instant.parse("2026-03-09T00:00:00Z"));
        state.setNextReviewAt(Instant.parse("2026-03-10T00:00:00Z"));
        state.setLastResult(ReviewOutcome.PASSED);
        state.setConsecutiveSuccessCount(3);
        state.setLapseCount(1);
        return state;
    }

    private Flashcard createFlashcard() {
        final Flashcard flashcard = new Flashcard();
        flashcard.setId(FLASHCARD_ID);
        flashcard.setDeck(createDeck());
        flashcard.setFrontText("faith");
        flashcard.setBackText("신뢰");
        flashcard.setNote("note");
        flashcard.setPronunciation("shinroe");
        return flashcard;
    }

    private Deck createDeck() {
        final Deck deck = new Deck();
        deck.setId(11L);
        deck.setName("Korean Basics");
        return deck;
    }

    private UserAccount createUser() {
        final UserAccount userAccount = new UserAccount();
        userAccount.setId(USER_ID);
        userAccount.setUsername("tester");
        userAccount.setEmail("tester@mail.com");
        return userAccount;
    }
}
