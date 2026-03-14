package com.lumos.study.dto.request;

import com.lumos.study.enums.TtsAdapterType;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

public record UpdateSpeechPreferenceRequest(
        @NotNull Boolean enabled,
        @NotNull Boolean autoPlay,
        @NotNull TtsAdapterType adapter,
        @NotNull String voice,
        @NotNull @DecimalMin("0.5") @DecimalMax("2.0") Double speed,
        @NotNull @DecimalMin("0.5") @DecimalMax("2.0") Double pitch) {
}
