package com.lumos.study.mode;

import java.util.List;

import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;

public interface StudyModeStrategy {

    String ACTION_GO_NEXT = "GO_NEXT";
    String ACTION_MARK_REMEMBERED = "MARK_REMEMBERED";
    String ACTION_RETRY_ITEM = "RETRY_ITEM";
    String ACTION_REVEAL_ANSWER = "REVEAL_ANSWER";
    String ACTION_SUBMIT_ANSWER = "SUBMIT_ANSWER";

    StudyMode getStudyMode();

    ReviewOutcome evaluateAnswer(StudySessionItem currentItem, String submittedAnswer);

    List<String> resolveAllowedActions(StudySession session, StudySessionItem currentItem);

    String resolvePrompt(StudySessionItem currentItem);

    String resolveExpectedAnswer(StudySessionItem currentItem);

    List<StudyChoiceResponse> resolveChoices(StudySessionItem currentItem, List<StudySessionItem> items);

    String resolveInstruction();

    String resolveInputPlaceholder();
}
