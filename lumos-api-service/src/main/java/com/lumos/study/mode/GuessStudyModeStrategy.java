package com.lumos.study.mode;

import java.util.List;

import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudyMode;

@Component
public class GuessStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_GUESS = "Choose the correct answer for the current prompt.";

    @Override
    public StudyMode getStudyMode() {
        // Return the enum key that binds this strategy to the guess mode.
        return StudyMode.GUESS;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            // Return the completed-state action set so guess mode cannot continue after session completion.
            return completedActions;
        }
        // Restrict feedback state to acknowledgement after the answer is checked.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Return next-only because the choice outcome is already locked in.
            return List.of(ACTION_GO_NEXT);
        }
        // Return submit-only because guess mode is resolved by one choice submission.
        return List.of(ACTION_SUBMIT_ANSWER);
    }

    @Override
    public String resolveInstruction() {
        // Return the instruction text that asks the learner to pick the correct option.
        return INSTRUCTION_GUESS;
    }

    @Override
    protected boolean usesChoiceOptions() {
        // Return true so the current item payload includes generated guess choices.
        return true;
    }
}
