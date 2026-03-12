package com.lumos.study.dto.request;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UpdateSpeechPreferenceRequest(
        @NotNull Boolean enabled,
        @NotNull Boolean autoPlay,
        @NotBlank String voice,
        @NotNull @DecimalMin("0.5") @DecimalMax("2.0") Double speed) {
}
