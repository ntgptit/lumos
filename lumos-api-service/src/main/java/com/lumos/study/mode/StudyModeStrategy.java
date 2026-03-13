package com.lumos.study.mode;

import java.util.List;

import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.enums.ReviewOutcome;
import com.lumos.study.enums.StudyMode;

public interface StudyModeStrategy {

    StudyMode getStudyMode();

    ReviewOutcome evaluateAnswer(StudySessionItem currentItem, String submittedAnswer);

    List<String> resolveAllowedActions(StudySession session);

    String resolvePrompt(StudySessionItem currentItem);

    String resolveExpectedAnswer(StudySessionItem currentItem);

    List<StudyChoiceResponse> resolveChoices(StudySessionItem currentItem, List<StudySessionItem> items);

    String resolveInstruction();

    String resolveInputPlaceholder();
}
