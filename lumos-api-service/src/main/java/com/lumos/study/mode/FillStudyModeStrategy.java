package com.lumos.study.mode;

import java.util.List;

import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
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
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            // Return the completed-state action set so finished sessions cannot restart fill input.
            return completedActions;
        }
        // Switch to feedback-specific actions after help or answer submission.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Advance directly once the learner has chosen to reveal the answer as a help hint.
            if (currentItem.getLastOutcome() == null) {
                // Return next-only so the client can continue without re-showing a revealed answer input form.
                return withResetCurrentModeAction(List.of(ACTION_GO_NEXT));
            }
            // Return next-only because the fill outcome has already been recorded.
            return withResetCurrentModeAction(List.of(ACTION_GO_NEXT));
        }
        // Return the default fill actions so the user can answer directly or ask for help first.
        return withResetCurrentModeAction(List.of(
                ACTION_SUBMIT_ANSWER,
                ACTION_REVEAL_ANSWER));
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
