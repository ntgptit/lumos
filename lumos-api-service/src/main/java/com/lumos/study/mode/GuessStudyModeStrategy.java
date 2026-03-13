package com.lumos.study.mode;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

@Component
public class GuessStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_GUESS = "Choose the matching prompt.";

    @Override
    public StudyMode getStudyMode() {
        return StudyMode.GUESS;
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_GUESS;
    }

    @Override
    protected boolean usesChoiceOptions() {
        return true;
    }

    @Override
    protected boolean usesBackTextAsPrompt() {
        return true;
    }
}
