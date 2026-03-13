package com.lumos.study.support;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.entity.UserAccount;
import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudySessionType;
import com.lumos.study.repository.StudySessionItemRepository;

@ExtendWith(MockitoExtension.class)
class StudySessionFlashcardCleanupSupportTest {

    private static final Long DECK_ID = 10L;
    private static final Long FLASHCARD_ID = 101L;
    private static final Long DELETED_FLASHCARD_ID = 102L;

    @Mock
    private StudySessionItemRepository studySessionItemRepository;

    @Test
    void removeFlashcardFromAllModes_reindexesSessionAndMovesCursorWhenCurrentItemIsDeleted() {
        final var support = new StudySessionFlashcardCleanupSupport(
                this.studySessionItemRepository);
        final StudySession studySession = this
                .createSession(
                        33L,
                        StudyMode.REVIEW,
                        StudyModeLifecycleState.WAITING_FEEDBACK,
                        0,
                        1,
                        false);
        final StudySessionItem firstItem = this
                .createSessionItem(
                        1L,
                        studySession,
                        this
                                .createFlashcard(FLASHCARD_ID, "faith", "신뢰"),
                        0,
                        true,
                        false,
                        ReviewOutcome.PASSED);
        final StudySessionItem deletedCurrentItem = this
                .createSessionItem(
                        2L,
                        studySession,
                        this
                                .createFlashcard(DELETED_FLASHCARD_ID, "night", "야간"),
                        1,
                        false,
                        false,
                        null);
        final StudySessionItem thirdItem = this
                .createSessionItem(
                        3L,
                        studySession,
                        this
                                .createFlashcard(103L, "researcher", "연구자"),
                        2,
                        false,
                        false,
                        null);
        final var deletedAt = Instant
                .parse("2026-03-13T10:15:30Z");
        when(this.studySessionItemRepository
                .findAllByFlashcardIdAndDeletedAtIsNullOrderByStudySessionIdAscSequenceIndexAsc(DELETED_FLASHCARD_ID))
                .thenReturn(List
                        .of(deletedCurrentItem));
        when(this.studySessionItemRepository
                .findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(33L))
                .thenReturn(List
                        .of(firstItem, deletedCurrentItem, thirdItem));

        support
                .removeFlashcardFromAllModes(DELETED_FLASHCARD_ID, deletedAt);

        assertEquals(deletedAt, deletedCurrentItem
                .getDeletedAt());
        assertEquals(0, firstItem
                .getSequenceIndex());
        assertEquals(1, thirdItem
                .getSequenceIndex());
        assertEquals(1, studySession
                .getCurrentItemIndex());
        assertEquals(StudyModeLifecycleState.IN_PROGRESS, studySession
                .getModeState());
    }

    @Test
    void removeFlashcardFromAllModes_softDeletesSessionWhenItLosesEveryItem() {
        final var support = new StudySessionFlashcardCleanupSupport(
                this.studySessionItemRepository);
        final StudySession studySession = this
                .createSession(
                        44L,
                        StudyMode.GUESS,
                        StudyModeLifecycleState.IN_PROGRESS,
                        2,
                        0,
                        false);
        final StudySessionItem onlyItem = this
                .createSessionItem(
                        4L,
                        studySession,
                        this
                                .createFlashcard(FLASHCARD_ID, "faith", "신뢰"),
                        0,
                        false,
                        false,
                        null);
        final var deletedAt = Instant
                .parse("2026-03-13T10:30:00Z");
        when(this.studySessionItemRepository
                .findAllByFlashcardIdAndDeletedAtIsNullOrderByStudySessionIdAscSequenceIndexAsc(FLASHCARD_ID))
                .thenReturn(List
                        .of(onlyItem));
        when(this.studySessionItemRepository
                .findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(44L))
                .thenReturn(List
                        .of(onlyItem));

        support
                .removeFlashcardFromAllModes(FLASHCARD_ID, deletedAt);

        assertEquals(deletedAt, onlyItem
                .getDeletedAt());
        assertEquals(deletedAt, studySession
                .getDeletedAt());
    }

    @Test
    void removeFlashcardFromAllModes_returnsImmediatelyWhenNoStudySessionUsesTheFlashcard() {
        final var support = new StudySessionFlashcardCleanupSupport(
                this.studySessionItemRepository);
        final var deletedAt = Instant
                .parse("2026-03-13T10:40:00Z");
        when(this.studySessionItemRepository
                .findAllByFlashcardIdAndDeletedAtIsNullOrderByStudySessionIdAscSequenceIndexAsc(FLASHCARD_ID))
                .thenReturn(List
                        .of());

        support
                .removeFlashcardFromAllModes(FLASHCARD_ID, deletedAt);

        verify(this.studySessionItemRepository)
                .findAllByFlashcardIdAndDeletedAtIsNullOrderByStudySessionIdAscSequenceIndexAsc(FLASHCARD_ID);
    }

    private StudySession createSession(
            Long sessionId,
            StudyMode activeMode,
            StudyModeLifecycleState modeState,
            int currentModeIndex,
            int currentItemIndex,
            boolean sessionCompleted) {
        final StudySession studySession = new StudySession();
        studySession
                .setId(sessionId);
        studySession
                .setUserAccount(this
                        .createUser());
        studySession
                .setDeck(this
                        .createDeck());
        studySession
                .setSessionType(StudySessionType.FIRST_LEARNING);
        studySession
                .setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        studySession
                .setCurrentModeIndex(currentModeIndex);
        studySession
                .setActiveMode(activeMode);
        studySession
                .setModeState(modeState);
        studySession
                .setCurrentItemIndex(currentItemIndex);
        studySession
                .setSessionCompleted(sessionCompleted);
        return studySession;
    }

    private StudySessionItem createSessionItem(
            Long itemId,
            StudySession studySession,
            Flashcard flashcard,
            int sequenceIndex,
            boolean currentModeCompleted,
            boolean retryPending,
            ReviewOutcome lastOutcome) {
        final StudySessionItem studySessionItem = new StudySessionItem();
        studySessionItem
                .setId(itemId);
        studySessionItem
                .setStudySession(studySession);
        studySessionItem
                .setFlashcard(flashcard);
        studySessionItem
                .setSequenceIndex(sequenceIndex);
        studySessionItem
                .setFrontTextSnapshot(flashcard
                        .getFrontText());
        studySessionItem
                .setBackTextSnapshot(flashcard
                        .getBackText());
        studySessionItem
                .setNoteSnapshot("note");
        studySessionItem
                .setPronunciationSnapshot("pronunciation");
        studySessionItem
                .setCurrentModeCompleted(currentModeCompleted);
        studySessionItem
                .setRetryPending(retryPending);
        studySessionItem
                .setLastOutcome(lastOutcome);
        return studySessionItem;
    }

    private Flashcard createFlashcard(Long flashcardId, String frontText, String backText) {
        final Flashcard flashcard = new Flashcard();
        flashcard
                .setId(flashcardId);
        flashcard
                .setDeck(this
                        .createDeck());
        flashcard
                .setFrontText(frontText);
        flashcard
                .setBackText(backText);
        flashcard
                .setNote("note");
        flashcard
                .setPronunciation("pronunciation");
        return flashcard;
    }

    private Deck createDeck() {
        final Deck deck = new Deck();
        deck
                .setId(DECK_ID);
        deck
                .setName("Korean Basics");
        return deck;
    }

    private UserAccount createUser() {
        final UserAccount userAccount = new UserAccount();
        userAccount
                .setId(7L);
        userAccount
                .setUsername("tester");
        userAccount
                .setEmail("tester@mail.com");
        return userAccount;
    }
}
