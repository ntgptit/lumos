package com.lumos.study.mode;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

@Component
public class FillStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String FILL_INPUT_PLACEHOLDER = "Type your answer";
    private static final String INSTRUCTION_FILL = "Type the exact answer to complete the review.";

    @Override
    public StudyMode getStudyMode() {
        return StudyMode.FILL;
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_FILL;
    }

    @Override
    public String resolveInputPlaceholder() {
        return FILL_INPUT_PLACEHOLDER;
    }
}
