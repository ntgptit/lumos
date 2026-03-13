package com.lumos.study.mode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import org.apache.commons.lang3.StringUtils;

import com.lumos.study.dto.request.StudyMatchPairRequest;
import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.dto.response.StudyMatchPairResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.exception.StudyCommandNotAllowedException;

public abstract class AbstractStudyModeStrategy implements StudyModeStrategy {

    private static final int CHOICE_LIMIT = 4;

    @Override
    public ReviewOutcome evaluateAnswer(StudySessionItem currentItem, String submittedAnswer) {
        final String normalizedSubmittedAnswer = normalize(submittedAnswer);
        final String normalizedExpectedAnswer = normalize(resolveExpectedAnswer(currentItem));
        final boolean isMatched = StringUtils.compareIgnoreCase(
                normalizedSubmittedAnswer,
                normalizedExpectedAnswer) == 0;
        // Return a passed outcome only when the submitted answer matches the expected answer.
        if (isMatched) {
            return ReviewOutcome.PASSED;
        }
        return ReviewOutcome.FAILED;
    }

    @Override
    public String resolvePrompt(StudySessionItem currentItem) {
        // Flip the prompt side only for modes that intentionally ask from the answer side first.
        if (usesBackTextAsPrompt()) {
            return currentItem.getBackTextSnapshot();
        }
        return currentItem.getFrontTextSnapshot();
    }

    @Override
    public String resolveExpectedAnswer(StudySessionItem currentItem) {
        // Flip the expected answer side only when the prompt is intentionally reversed.
        if (usesBackTextAsPrompt()) {
            return currentItem.getFrontTextSnapshot();
        }
        return currentItem.getBackTextSnapshot();
    }

    @Override
    public List<StudyChoiceResponse> resolveChoices(StudySessionItem currentItem, List<StudySessionItem> items) {
        // Skip choice generation for modes that use free-form or reveal-driven interaction.
        if (!usesChoiceOptions()) {
            return List.of();
        }

        final List<String> values = new ArrayList<>();
        values.add(resolveExpectedAnswer(currentItem));
        for (StudySessionItem item : items) {
            // Skip the current item so distractors always come from different flashcards.
            if (Objects.deepEquals(item.getId(), currentItem.getId())) {
                continue;
            }
            values.add(resolveExpectedAnswer(item));
        }

        final List<String> uniqueValues = values.stream().distinct().limit(CHOICE_LIMIT).toList();
        final List<StudyChoiceResponse> choices = new ArrayList<>();
        for (int index = 0; index < uniqueValues.size(); index++) {
            choices.add(new StudyChoiceResponse("choice-" + index, uniqueValues.get(index)));
        }
        Collections.rotate(choices, currentItem.getSequenceIndex() % Math.max(1, choices.size()));
        return choices;
    }

    @Override
    public List<StudyMatchPairResponse> resolveMatchPairs(StudySessionItem currentItem, List<StudySessionItem> items) {
        return List.of();
    }

    @Override
    public ReviewOutcome evaluateMatchPairs(
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            List<StudyMatchPairRequest> matchedPairs) {
        throw new StudyCommandNotAllowedException();
    }

    @Override
    public String resolveInputPlaceholder() {
        return "";
    }

    protected boolean usesChoiceOptions() {
        return false;
    }

    protected boolean usesBackTextAsPrompt() {
        return false;
    }

    protected List<String> resolveCompletedActions(StudySession session) {
        // Expose no actions after the whole session has already completed.
        if (Boolean.TRUE == session.getSessionCompleted()) {
            return List.of();
        }
        return null;
    }

    private String normalize(String value) {
        return StringUtils.trimToEmpty(value);
    }
}
