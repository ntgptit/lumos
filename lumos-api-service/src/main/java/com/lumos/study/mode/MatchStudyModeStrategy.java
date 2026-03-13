package com.lumos.study.mode;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
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
    private static final int MATCH_PAIR_LIMIT = 4;
    private static final String RIGHT_ID_PREFIX = "right-";

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
    public List<StudyMatchPairResponse> resolveMatchPairs(StudySessionItem currentItem, List<StudySessionItem> items) {
        final List<StudySessionItem> matchItems = resolveMatchItems(currentItem, items);
        final List<StudyMatchPairResponse> matchPairs = new ArrayList<>();
        for (StudySessionItem item : matchItems) {
            matchPairs.add(new StudyMatchPairResponse(
                    LEFT_ID_PREFIX + item.getFlashcard().getId(),
                    resolvePrompt(item),
                    RIGHT_ID_PREFIX + item.getFlashcard().getId(),
                    resolveExpectedAnswer(item)));
        }
        return matchPairs;
    }

    @Override
    public ReviewOutcome evaluateMatchPairs(
            StudySessionItem currentItem,
            List<StudySessionItem> items,
            List<StudyMatchPairRequest> matchedPairs) {
        final List<StudyMatchPairResponse> expectedPairs = resolveMatchPairs(currentItem, items);
        final Set<String> expectedPairIds = expectedPairs.stream()
                .map(pair -> pair.leftId() + ":" + pair.rightId())
                .collect(Collectors.toSet());
        final Set<String> submittedPairIds = matchedPairs.stream()
                .map(pair -> StringUtils.trimToEmpty(pair.leftId()) + ":" + StringUtils.trimToEmpty(pair.rightId()))
                .collect(Collectors.toSet());
        // Mark the answer as failed when the number of submitted pairs does not match the expected grid.
        if (submittedPairIds.size() != expectedPairs.size()) {
            return ReviewOutcome.FAILED;
        }
        // Mark the answer as failed when any selected pair mismatches the expected canonical pair set.
        if (!expectedPairIds.containsAll(submittedPairIds) || !submittedPairIds.containsAll(expectedPairIds)) {
            return ReviewOutcome.FAILED;
        }
        return ReviewOutcome.PASSED;
    }

    private List<StudySessionItem> resolveMatchItems(StudySessionItem currentItem, List<StudySessionItem> items) {
        final List<StudySessionItem> matchItems = new ArrayList<>();
        matchItems.add(currentItem);
        for (StudySessionItem item : items) {
            // Keep the current item as the first pair and fill remaining slots with other items.
            if (Objects.compare(currentItem.getId(), item.getId(), Comparator.naturalOrder()) == 0) {
                continue;
            }
            matchItems.add(item);
            // Stop when the pairing grid already contains the target number of rows.
            if (matchItems.size() >= MATCH_PAIR_LIMIT) {
                break;
            }
        }
        return matchItems;
    }
}
