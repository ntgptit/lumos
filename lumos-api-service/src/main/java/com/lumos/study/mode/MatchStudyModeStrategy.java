package com.lumos.study.mode;

import java.util.List;

import org.springframework.stereotype.Component;

import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudyMode;

@Component
public class MatchStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_MATCH = "Match the term with the correct meaning.";

    @Override
    public StudyMode getStudyMode() {
        return StudyMode.MATCH;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            return completedActions;
        }
        // Restrict feedback state to acknowledgement after the selected match is checked.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            return List.of(ACTION_GO_NEXT);
        }
        return List.of(ACTION_SUBMIT_ANSWER);
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_MATCH;
    }

    @Override
    protected boolean usesChoiceOptions() {
        return true;
    }
}
