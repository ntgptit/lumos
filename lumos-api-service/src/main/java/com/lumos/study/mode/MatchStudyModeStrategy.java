package com.lumos.study.mode;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.lumos.study.dto.request.StudyMatchPairRequest;
import com.lumos.study.dto.response.StudyMatchPairResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.StudyModeLifecycleState;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.enums.ReviewOutcome;

@Component
public class MatchStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_MATCH = "Match the term with the correct meaning.";
    private static final String LEFT_ID_PREFIX = "left-";
    private static final String RIGHT_ID_PREFIX = "right-";

    @Override
    public StudyMode getStudyMode() {
        // Return the canonical mode key used to route MATCH behavior through the factory.
        return StudyMode.MATCH;
    }

    @Override
    public List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem) {
        final List<String> completedActions = resolveCompletedActions(session);
        // Return immediately when the session has already finished.
        if (completedActions != null) {
            // Return the completed action set so the frontend stops exposing interactive commands.
            return completedActions;
        }
        // Restrict feedback state to acknowledgement after the selected match is checked.
        if (session.getModeState() == StudyModeLifecycleState.WAITING_FEEDBACK) {
            // Return only the advance action because the current pairing result is already locked in.
            return withResetCurrentModeAction(List.of(ACTION_GO_NEXT));
        }
        // Return the submit action while the learner is still building the pairing grid.
        return withResetCurrentModeAction(List.of(ACTION_SUBMIT_ANSWER));
    }

    @Override
    public String resolveInstruction() {
        // Return the instructional copy shown above the pairing grid for MATCH mode.
        return INSTRUCTION_MATCH;
    }

    @Override
    public List<StudyMatchPairResponse> resolveMatchPairs(StudySessionItem currentItem, List<StudySessionItem> items) {
        final List<StudySessionItem> matchItems = resolveMatchItems(currentItem, items);
        final List<StudyMatchPairResponse> matchPairs = new ArrayList<>();
        // Build the left-right grid rows that the frontend renders for the current match challenge.
        for (StudySessionItem item : matchItems) {
            matchPairs.add(new StudyMatchPairResponse(
                    LEFT_ID_PREFIX + item.getFlashcard().getId(),
                    resolvePrompt(item),
                    RIGHT_ID_PREFIX + item.getFlashcard().getId(),
                    resolveExpectedAnswer(item)));
        }
        // Return the pairing contract that the frontend uses to render the current MATCH attempt.
        return matchPairs;
    }

    @Override
    public List<StudySessionItem> resolvePassedItems(StudySessionItem currentItem, List<StudySessionItem> items) {
        // Return every item shown in the current grid so a correct MATCH submission completes the visible challenge.
        return List.copyOf(resolveMatchItems(currentItem, items));
    }

    @Override
    public ReviewOutcome evaluateMatchPairs(
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            List<StudyMatchPairRequest> matchedPairs) {
        final List<StudyMatchPairResponse> expectedPairs = resolveMatchPairs(currentItem, items);
        // Flatten the expected match grid into canonical left:right identifiers for exact-set comparison.
        final Set<String> expectedPairIds = expectedPairs.stream()
                .map(pair -> pair.leftId() + ":" + pair.rightId())
                .collect(Collectors.toSet());
        // Flatten the submitted grid into the same canonical shape before comparing learner input.
        final Set<String> submittedPairIds = matchedPairs.stream()
                .map(pair -> StringUtils.trimToEmpty(pair.leftId()) + ":" + StringUtils.trimToEmpty(pair.rightId()))
                .collect(Collectors.toSet());
        // Mark the answer as failed when the number of submitted pairs does not match the expected grid.
        if (submittedPairIds.size() != expectedPairs.size()) {
            // Return fail because an incomplete grid means the learner did not finish all required pairs.
            return ReviewOutcome.FAILED;
        }
        // Mark the answer as failed when any selected pair mismatches the expected canonical pair set.
        if (!expectedPairIds.containsAll(submittedPairIds) || !submittedPairIds.containsAll(expectedPairIds)) {
            // Return fail because at least one submitted pairing maps to the wrong counterpart.
            return ReviewOutcome.FAILED;
        }
        // Return pass only when the learner completes the entire pairing grid correctly.
        return ReviewOutcome.PASSED;
    }

    private List<StudySessionItem> resolveMatchItems(StudySessionItem currentItem, List<StudySessionItem> items) {
        // Return the full session item list so MATCH always shows balanced left-right columns for every term.
        return List.copyOf(items);
    }
}
