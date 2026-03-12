package com.lumos.study.constant;

import java.time.Duration;
import java.util.List;

import com.lumos.study.enums.StudyMode;

import lombok.experimental.UtilityClass;

@UtilityClass
public class StudyConstants {

    public static final String SPEECH_LOCALE = "ko-KR";
    public static final String DEFAULT_SPEECH_VOICE = "ko-KR-neutral";
    public static final double DEFAULT_SPEECH_SPEED = 1.0D;
    public static final int MIN_BOX_INDEX = 1;
    public static final int MAX_BOX_INDEX = 7;
    public static final List<StudyMode> FIRST_LEARNING_MODE_PLAN = List.of(
            StudyMode.REVIEW,
            StudyMode.MATCH,
            StudyMode.GUESS,
            StudyMode.RECALL,
            StudyMode.FILL);
    public static final List<StudyMode> REVIEW_MODE_PLAN = List.of(StudyMode.FILL);

    public static Duration intervalForBox(int boxIndex) {
        return switch (boxIndex) {
            case 1 -> Duration.ofHours(12);
            case 2 -> Duration.ofDays(1);
            case 3 -> Duration.ofDays(3);
            case 4 -> Duration.ofDays(7);
            case 5 -> Duration.ofDays(14);
            case 6 -> Duration.ofDays(30);
            default -> Duration.ofDays(60);
        };
    }
}
