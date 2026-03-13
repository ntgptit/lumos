package com.lumos.study.mode;

import org.springframework.stereotype.Component;

import com.lumos.study.enums.StudyMode;

@Component
public class ReviewStudyModeStrategy extends AbstractStudyModeStrategy {

    private static final String INSTRUCTION_REVIEW = "Reveal the answer, then confirm if you remembered it.";

    @Override
    public StudyMode getStudyMode() {
        return StudyMode.REVIEW;
    }

    @Override
    public String resolveInstruction() {
        return INSTRUCTION_REVIEW;
    }

    @Override
    protected boolean isRevealDrivenMode() {
        return true;
    }
}
