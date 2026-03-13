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
        return StudyMode.RECALL;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            return completedActions;
        }
        // Split recall between answer-reveal state and post-assessment acknowledgement.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Switch to next-only acknowledgement once the item already has a final outcome.
            if (currentItem.getLastOutcome() != null) {
                return List.of(ACTION_GO_NEXT);
            }
            return List.of(
                    ACTION_MARK_REMEMBERED,
                    ACTION_RETRY_ITEM);
        }
        return List.of(ACTION_REVEAL_ANSWER);
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_RECALL;
    }
}
