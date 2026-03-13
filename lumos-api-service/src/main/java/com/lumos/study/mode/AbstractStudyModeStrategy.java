package com.lumos.study.mode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;

import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyModeLifecycleState;

public abstract class AbstractStudyModeStrategy implements StudyModeStrategy {

    private static final int CHOICE_LIMIT = 4;
    private static final String ACTION_GO_NEXT = "GO_NEXT";
    private static final String ACTION_MARK_REMEMBERED = "MARK_REMEMBERED";
    private static final String ACTION_RETRY_ITEM = "RETRY_ITEM";
    private static final String ACTION_REVEAL_ANSWER = "REVEAL_ANSWER";
    private static final String ACTION_SUBMIT_ANSWER = "SUBMIT_ANSWER";

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
    public List<String> resolveAllowedActions(StudySession session) {
        // Expose no further actions after the session has already completed.
        if (Boolean.TRUE == session.getSessionCompleted()) {
            return List.of();
        }

        // Restrict waiting-feedback state to acknowledgement and retry actions.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            return resolveWaitingFeedbackActions();
        }

        // Expose reveal-first actions for modes that require answer reveal before confirmation.
        if (isRevealDrivenMode()) {
            return List.of(
                    ACTION_REVEAL_ANSWER,
                    ACTION_MARK_REMEMBERED,
                    ACTION_RETRY_ITEM);
        }

        return List.of(
                ACTION_SUBMIT_ANSWER,
                ACTION_REVEAL_ANSWER,
                ACTION_RETRY_ITEM);
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
    public String resolveInputPlaceholder() {
        return "";
    }

    protected boolean isRevealDrivenMode() {
        return false;
    }

    protected boolean usesChoiceOptions() {
        return false;
    }

    protected boolean usesBackTextAsPrompt() {
        return false;
    }

    private List<String> resolveWaitingFeedbackActions() {
        final Set<String> actions = new LinkedHashSet<>();
        actions.add(ACTION_GO_NEXT);
        actions.add(ACTION_RETRY_ITEM);
        // Add remembered confirmation only for reveal-driven modes that support that follow-up action.
        if (isRevealDrivenMode()) {
            actions.add(ACTION_MARK_REMEMBERED);
        }
        return List.copyOf(actions);
    }

    private String normalize(String value) {
        return StringUtils.trimToEmpty(value);
    }
}
