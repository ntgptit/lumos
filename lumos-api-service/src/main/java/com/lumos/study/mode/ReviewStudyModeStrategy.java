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
        return StudyMode.REVIEW;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            return completedActions;
        }
        // Move to next only after the user already chose remembered or failed.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK
                && currentItem.getLastOutcome() != null) {
            return List.of(ACTION_GO_NEXT);
        }
        return List.of(
                ACTION_MARK_REMEMBERED,
                ACTION_RETRY_ITEM);
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_REVIEW;
    }
}
