package com.lumos.study.mode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import org.apache.commons.lang3.Strings;
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
        final boolean isMatched = Strings.CI.equals(
                normalizedSubmittedAnswer,
                normalizedExpectedAnswer);
        // Return a passed outcome only when the submitted answer matches the expected answer.
        if (isMatched) {
            // Return a pass so SRS can promote the card after a correct answer.
            return ReviewOutcome.PASSED;
        }
        // Return a fail so SRS can keep or demote the card after a wrong answer.
        return ReviewOutcome.FAILED;
    }

    @Override
    public String resolvePrompt(StudySessionItem currentItem) {
        // Flip the prompt side only for modes that intentionally ask from the answer side first.
        if (usesBackTextAsPrompt()) {
            // Return the back text as the prompt for modes that quiz from meaning to term.
            return currentItem.getBackTextSnapshot();
        }
        // Return the front text as the default prompt for forward study modes.
        return currentItem.getFrontTextSnapshot();
    }

    @Override
    public String resolveExpectedAnswer(StudySessionItem currentItem) {
        // Flip the expected answer side only when the prompt is intentionally reversed.
        if (usesBackTextAsPrompt()) {
            // Return the front text as the answer when the mode prompts from the back side first.
            return currentItem.getFrontTextSnapshot();
        }
        // Return the back text as the default expected answer in forward study modes.
        return currentItem.getBackTextSnapshot();
    }

    @Override
    public List<StudyChoiceResponse> resolveChoices(StudySessionItem currentItem, List<StudySessionItem> items) {
        // Skip choice generation for modes that use free-form or reveal-driven interaction.
        if (!usesChoiceOptions()) {
            // Return no choice list for modes that rely on typing, reveal, or custom pairing interactions.
            return List.of();
        }

        final List<String> values = new ArrayList<>();
        values.add(resolveExpectedAnswer(currentItem));
        // Collect distractor values from sibling items in the same session item list.
        for (StudySessionItem item : items) {
            // Skip the current item so distractors always come from different flashcards.
            if (Objects.deepEquals(item.getId(), currentItem.getId())) {
                continue;
            }
            values.add(resolveExpectedAnswer(item));
        }

        // Keep distinct choice labels and cap the list to the supported multiple-choice size.
        final List<String> uniqueValues = values.stream().distinct().limit(CHOICE_LIMIT).toList();
        final List<StudyChoiceResponse> choices = new ArrayList<>();
        // Build stable choice ids so the frontend can submit a single selected option.
        for (int index = 0; index < uniqueValues.size(); index++) {
            choices.add(new StudyChoiceResponse("choice-" + index, uniqueValues.get(index)));
        }
        Collections.rotate(choices, currentItem.getSequenceIndex() % Math.max(1, choices.size()));
        // Return the finalized choice list after rotating it to avoid a fixed answer position.
        return choices;
    }

    @Override
    public List<StudyMatchPairResponse> resolveMatchPairs(StudySessionItem currentItem, List<StudySessionItem> items) {
        // Return no pairing contract for modes that do not implement match-specific interaction.
        return List.of();
    }

    @Override
    public ReviewOutcome evaluateMatchPairs(
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            List<StudyMatchPairRequest> matchedPairs) {
        // Fail fast because non-match modes must never receive the pairing submission payload.
        throw new StudyCommandNotAllowedException();
    }

    @Override
    public String resolveInputPlaceholder() {
        // Return an empty placeholder for modes that do not render a text-input field.
        return "";
    }

    protected boolean usesChoiceOptions() {
        // Return false so modes opt into multiple-choice behavior explicitly.
        return false;
    }

    protected boolean usesBackTextAsPrompt() {
        // Return false so modes use the front side as the default prompt direction.
        return false;
    }

    protected List<String> resolveCompletedActions(StudySession session) {
        // Expose no actions after the whole session has already completed.
        if (Boolean.TRUE == session.getSessionCompleted()) {
            // Return an empty action list once the backend has marked the session completed.
            return List.of();
        }
        // Return null so the concrete mode strategy can decide the active command set.
        return null;
    }

    protected List<String> withResetCurrentModeAction(List<String> actions) {
        final List<String> nextActions = new ArrayList<>(actions);
        nextActions.add(ACTION_RESET_CURRENT_MODE);
        // Return the augmented action set so every active mode can expose the shared reset command.
        return List.copyOf(nextActions);
    }

    private String normalize(String value) {
        // Return a trimmed answer value so comparisons ignore accidental surrounding whitespace.
        return StringUtils.trimToEmpty(value);
    }
}
