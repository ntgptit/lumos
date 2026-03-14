package com.lumos.study.mode;

import java.util.List;

import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.StudyModeLifecycleState;

@Component
public class ReviewStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_REVIEW = "Review both sides, then decide if you remembered the item.";

    @Override
    public StudyMode getStudyMode() {
        // Return the enum key that binds this strategy to the review mode.
        return StudyMode.REVIEW;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            // Return the completed-state action set so review mode cannot continue after session completion.
            return completedActions;
        }
        // Move to next only after the user already chose remembered or failed.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK
                && currentItem.getLastOutcome() != null) {
            // Return next-only because review mode already captured the learner's memory judgment.
            return withResetCurrentModeAction(List.of(ACTION_GO_NEXT));
        }
        // Return the two review judgments so the learner can mark remembered versus needs-review.
        return withResetCurrentModeAction(List.of(
                ACTION_MARK_REMEMBERED,
                ACTION_RETRY_ITEM));
    }

    @Override
    public String resolveInstruction() {
        // Return the instruction text that frames review mode as a memory self-check.
        return INSTRUCTION_REVIEW;
    }
}
