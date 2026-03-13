package com.lumos.study.mode;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

@Component
public class MatchStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_MATCH = "Pick the matching answer.";

    @Override
    public StudyMode getStudyMode() {
        return StudyMode.MATCH;
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
