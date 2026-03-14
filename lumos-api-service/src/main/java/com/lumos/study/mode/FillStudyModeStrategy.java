package com.lumos.study.mode;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.Strings;
import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudyMode;

@Component
public class FillStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String FILL_INPUT_PLACEHOLDER = "Type your answer";
    private static final String INSTRUCTION_FILL = "Type the answer, or ask for help before checking.";

    @Override
    public StudyMode getStudyMode() {
        // Return the enum key that binds this strategy to the fill-in-answer mode.
        return StudyMode.FILL;
    }

    @Override
    public ReviewOutcome evaluateAnswer(StudySessionItem currentItem, String submittedAnswer) {
        final String normalizedSubmittedAnswer = StringUtils.trimToEmpty(submittedAnswer);
        final String normalizedExpectedAnswer = StringUtils.trimToEmpty(currentItem.getFrontTextSnapshot());
        final boolean isMatched = Strings.CI.equals(
                normalizedSubmittedAnswer,
                normalizedExpectedAnswer);
        // Return a passed outcome only when the learner re-enters the term side that fill mode expects.
        if (isMatched) {
            // Return pass so fill retries can promote the current item and unlock next.
            return ReviewOutcome.PASSED;
        }
        // Return fail so fill mode keeps the learner on the same item until the term is entered correctly.
        return ReviewOutcome.FAILED;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            // Return the completed-state action set so finished sessions cannot restart fill input.
            return completedActions;
        }
        // Return the default input actions while the fill item has not entered feedback yet.
        if (session.getModeState() != StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Return the default fill actions so the user can answer directly or ask for help first.
            return withResetCurrentModeAction(List.of(
                    ACTION_SUBMIT_ANSWER,
                    ACTION_REVEAL_ANSWER));
        }
        // Return next-only after a correct fill retry has already completed the current item.
        if (currentItem.getLastOutcome() == ReviewOutcome.PASSED) {
            // Return next-only after the learner eventually gets the same item right.
            return withResetCurrentModeAction(List.of(ACTION_GO_NEXT));
        }
        // Keep help available during fill retries because difficult terms may need multiple reveals before recall stabilizes.
        return withResetCurrentModeAction(List.of(
                ACTION_REVEAL_ANSWER,
                ACTION_SUBMIT_ANSWER));
    }

    @Override
    public String resolveInstruction() {
        // Return the instruction text that explains the expected fill interaction.
        return INSTRUCTION_FILL;
    }

    @Override
    public String resolveInputPlaceholder() {
        // Return the placeholder shown inside the fill answer field.
        return FILL_INPUT_PLACEHOLDER;
    }
}
