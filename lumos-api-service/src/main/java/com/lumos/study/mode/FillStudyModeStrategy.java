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
        return StudyMode.FILL;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            return completedActions;
        }
        // Switch to feedback-specific actions after help or answer submission.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Keep answer submission available after showing a help hint.
            if (currentItem.getLastOutcome() == null) {
                return List.of(ACTION_SUBMIT_ANSWER);
            }
            return List.of(ACTION_GO_NEXT);
        }
        return List.of(
                ACTION_SUBMIT_ANSWER,
                ACTION_REVEAL_ANSWER);
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_FILL;
    }

    @Override
    public String resolveInputPlaceholder() {
        return FILL_INPUT_PLACEHOLDER;
    }
}
