package com.lumos.study.service.impl;

import com.lumos.auth.entity.UserAccount;
import com.lumos.deck.entity.Deck;
import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudySessionType;

final class StudySessionServiceTestDataFactory {

    static final Long USER_ID = 7L;
    static final Long DECK_ID = 3L;
    static final Long SESSION_ID = 33L;

    private StudySessionServiceTestDataFactory() {
    }

    static UserAccount user() {
        final UserAccount user = new UserAccount();
        user.setId(USER_ID);
        user.setUsername("tester");
        user.setEmail("tester@mail.com");
        return user;
    }

    static Deck deck() {
        final Deck deck = new Deck();
        deck.setId(DECK_ID);
        deck.setName("Korean Basics");
        return deck;
    }

    static Flashcard flashcard(Long id, Deck deck, String front, String back) {
        final Flashcard flashcard = new Flashcard();
        flashcard.setId(id);
        flashcard.setDeck(deck);
        flashcard.setFrontText(front);
        flashcard.setBackText(back);
        flashcard.setNote("note");
        flashcard.setPronunciation("pronunciation");
        return flashcard;
    }

    static StudySession activeSession() {
        final StudySession session = session(
                user(),
                deck(),
                StudySessionType.FIRST_LEARNING,
                StudyMode.REVIEW,
                StudyModeLifecycleState.IN_PROGRESS,
                0,
                0,
                false);
        session.setId(SESSION_ID);
        session.setModePlan("REVIEW,MATCH,GUESS,RECALL,FILL");
        return session;
    }

    static StudySession session(
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

    static StudySessionItem currentItem(
            StudySession session,
            ReviewOutcome outcome,
            boolean completed,
            boolean retryPending) {
        return sessionItem(
                1L,
                session,
                flashcard(101L, session.getDeck(), "안녕하세요", "xin chao"),
                0,
                completed,
                retryPending,
                outcome);
    }

    static StudySessionItem sessionItem(
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
