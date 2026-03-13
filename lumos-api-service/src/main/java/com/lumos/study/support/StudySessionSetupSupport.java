package com.lumos.study.support;

import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.lumos.flashcard.entity.Flashcard;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.entity.LearningCardState;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudySessionType;
import com.lumos.study.exception.StudySessionUnavailableException;
import com.lumos.study.repository.LearningCardStateRepository;
import com.lumos.study.repository.StudySessionItemRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StudySessionSetupSupport {

    private static final String MODE_PLAN_SEPARATOR = ",";

    private final LearningCardStateRepository learningCardStateRepository;
    private final StudySessionItemRepository studySessionItemRepository;

    public Map<Long, LearningCardState> resolveLearningStateByFlashcardId(Long userId, List<Flashcard> flashcards) {
        final List<Long> flashcardIds = flashcards.stream().map(Flashcard::getId).toList();
        if (flashcardIds.isEmpty()) {
            return Map.of();
        }
        return this.learningCardStateRepository
                .findAllByUserAccountIdAndFlashcardIdInAndDeletedAtIsNull(userId, flashcardIds)
                .stream()
                .collect(Collectors.toMap(state -> state.getFlashcard().getId(), state -> state));
    }

    public boolean isDue(LearningCardState learningCardState) {
        if (learningCardState == null) {
            return false;
        }
        return !learningCardState.getNextReviewAt().isAfter(Instant.now());
    }

    public StudySessionType resolveSessionType(List<Flashcard> newFlashcards, List<Flashcard> dueFlashcards) {
        if (!newFlashcards.isEmpty()) {
            return StudySessionType.FIRST_LEARNING;
        }
        if (!dueFlashcards.isEmpty()) {
            return StudySessionType.REVIEW;
        }
        throw new StudySessionUnavailableException();
    }

    public List<Flashcard> resolveSelectedFlashcards(
            StudySessionType sessionType,
            List<Flashcard> newFlashcards,
            List<Flashcard> dueFlashcards) {
        return switch (sessionType) {
            case FIRST_LEARNING -> newFlashcards;
            case REVIEW -> dueFlashcards;
        };
    }

    public List<StudyMode> resolveModePlan(StudySessionType sessionType) {
        return switch (sessionType) {
            case FIRST_LEARNING -> StudyConstants.FIRST_LEARNING_MODE_PLAN;
            case REVIEW -> StudyConstants.REVIEW_MODE_PLAN;
        };
    }

    public String joinModePlan(List<StudyMode> modePlan) {
        return modePlan.stream().map(Enum::name).collect(Collectors.joining(MODE_PLAN_SEPARATOR));
    }

    public List<StudyMode> parseModePlan(String rawModePlan) {
        return Arrays.stream(rawModePlan.split(MODE_PLAN_SEPARATOR))
                .map(StudyMode::valueOf)
                .toList();
    }

    public void createSessionItems(StudySession session, List<Flashcard> selectedFlashcards) {
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
}
