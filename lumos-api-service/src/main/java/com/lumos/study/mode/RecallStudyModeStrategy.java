package com.lumos.study.mode;

import java.util.List;

import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudyMode;

@Component
public class RecallStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_RECALL = "Think of the answer first, then reveal it only when needed.";

    @Override
    public StudyMode getStudyMode() {
        // Return the enum key that binds this strategy to the recall mode.
        return StudyMode.RECALL;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            // Return the completed-state action set so recall mode cannot continue after session completion.
            return completedActions;
        }
        // Split recall between answer-reveal state and post-assessment acknowledgement.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Switch to next-only acknowledgement once the item already has a final outcome.
            if (currentItem.getLastOutcome() != null) {
                // Return next-only because the user has already judged recall success or failure.
                return withResetCurrentModeAction(List.of(ACTION_GO_NEXT));
            }
            // Return the self-assessment actions shown immediately after the answer is revealed.
            return withResetCurrentModeAction(List.of(
                    ACTION_MARK_REMEMBERED,
                    ACTION_RETRY_ITEM));
        }
        // Return reveal-only so the learner must attempt recall mentally before seeing the answer.
        return withResetCurrentModeAction(List.of(ACTION_REVEAL_ANSWER));
    }

    @Override
    public String resolveInstruction() {
        // Return the instruction text that explains the delayed-reveal recall exercise.
        return INSTRUCTION_RECALL;
    }
}
