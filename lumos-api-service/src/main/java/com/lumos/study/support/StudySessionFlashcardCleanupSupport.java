package com.lumos.study.support;

import java.time.Instant;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.repository.StudySessionItemRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StudySessionFlashcardCleanupSupport {

    private static final int FIRST_ITEM_INDEX = 0;

    private final StudySessionItemRepository studySessionItemRepository;

    /**
     * Remove a deleted flashcard from every study-session mode snapshot that still references it.
     *
     * @param flashcardId deleted flashcard identifier
     * @param deletedAt canonical deletion timestamp
     */
    public void removeFlashcardFromAllModes(Long flashcardId, Instant deletedAt) {
        final List<StudySessionItem> affectedItems = this.studySessionItemRepository
                .findAllByFlashcardIdAndDeletedAtIsNullOrderByStudySessionIdAscSequenceIndexAsc(flashcardId);
        // Stop when no active study-session item still points at the deleted flashcard.
        if (affectedItems.isEmpty()) {
            return;
        }
        for (StudySessionItem item : affectedItems) {
            item.setDeletedAt(deletedAt);
        }
        final List<StudySession> affectedSessions = affectedItems.stream()
                .map(StudySessionItem::getStudySession)
                .filter(Objects::nonNull)
                .distinct()
                .toList();
        for (StudySession session : affectedSessions) {
            normalizeSessionAfterFlashcardDeletion(session, flashcardId, deletedAt);
        }
    }

    private void normalizeSessionAfterFlashcardDeletion(StudySession session, Long flashcardId, Instant deletedAt) {
        final List<StudySessionItem> remainingItems = this.studySessionItemRepository
                .findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(session.getId())
                .stream()
                .filter(item -> !Objects.deepEquals(item.getFlashcard().getId(), flashcardId))
                .toList();
        // Soft delete the now-empty session so deleted flashcards cannot leave behind blank study flows.
        if (remainingItems.isEmpty()) {
            session.setDeletedAt(deletedAt);
            return;
        }
        final boolean deletedCurrentItem = isDeletedCurrentItem(session, flashcardId);
        final StudySessionItem nextCurrentItem = resolveNextCurrentItem(session, remainingItems);
        reindexItems(remainingItems);
        session.setCurrentItemIndex(nextCurrentItem.getSequenceIndex());
        // Re-open the mode when the deleted flashcard was the active item so the next card is immediately actionable.
        if (deletedCurrentItem && session.getSessionCompleted() != Boolean.TRUE) {
            session.setModeState(StudyModeLifecycleState.IN_PROGRESS);
        }
    }

    private boolean isDeletedCurrentItem(StudySession session, Long flashcardId) {
        final Integer currentItemIndex = session.getCurrentItemIndex();
        return this.studySessionItemRepository
                .findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(session.getId())
                .stream()
                .filter(item -> Objects.deepEquals(item.getFlashcard().getId(), flashcardId))
                .anyMatch(item -> Objects.deepEquals(item.getSequenceIndex(), currentItemIndex));
    }

    private StudySessionItem resolveNextCurrentItem(StudySession session, List<StudySessionItem> remainingItems) {
        final Integer currentItemIndex = session.getCurrentItemIndex();
        final StudySessionItem firstItemAtOrAfterCurrent = remainingItems.stream()
                .filter(item -> item.getSequenceIndex() >= currentItemIndex)
                .findFirst()
                .orElse(null);
        // Keep the current cursor position when a same-or-next item still exists after compaction.
        if (firstItemAtOrAfterCurrent != null) {
            return firstItemAtOrAfterCurrent;
        }
        return remainingItems.stream()
                .max(Comparator.comparingInt(StudySessionItem::getSequenceIndex))
                .orElseThrow();
    }

    private void reindexItems(List<StudySessionItem> items) {
        for (int index = 0; index < items.size(); index++) {
            items.get(index).setSequenceIndex(index);
        }
        // Keep the first slot reserved at zero for every compacted session item list.
        if (!items.isEmpty()) {
            items.get(FIRST_ITEM_INDEX).setSequenceIndex(FIRST_ITEM_INDEX);
        }
    }
}
