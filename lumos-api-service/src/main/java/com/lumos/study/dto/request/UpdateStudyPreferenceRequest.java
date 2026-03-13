package com.lumos.study.dto.request;

import com.lumos.study.constant.StudyConstants;
import com.lumos.study.constant.ValidationMessageKeys;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record UpdateStudyPreferenceRequest(
        @NotNull(message = ValidationMessageKeys.FIRST_LEARNING_CARD_LIMIT_REQUIRED)
        @Min(value = StudyConstants.MIN_FIRST_LEARNING_CARD_LIMIT, message = ValidationMessageKeys.FIRST_LEARNING_CARD_LIMIT_MIN)
        @Max(value = StudyConstants.MAX_FIRST_LEARNING_CARD_LIMIT, message = ValidationMessageKeys.FIRST_LEARNING_CARD_LIMIT_MAX)
        Integer firstLearningCardLimit) {
}
