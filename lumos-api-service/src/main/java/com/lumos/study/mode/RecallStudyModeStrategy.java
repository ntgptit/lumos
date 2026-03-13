package com.lumos.study.mode;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

@Component
public class RecallStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String FILL_INPUT_PLACEHOLDER = "Type your answer";
    private static final String INSTRUCTION_RECALL = "Think of the answer before revealing it.";

    @Override
    public StudyMode getStudyMode() {
        return StudyMode.RECALL;
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_RECALL;
    }

    @Override
    public String resolveInputPlaceholder() {
        return FILL_INPUT_PLACEHOLDER;
    }

    @Override
    protected boolean isRevealDrivenMode() {
        return true;
    }
}
