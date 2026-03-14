package com.lumos.study.dto.request;

import jakarta.validation.constraints.NotBlank;

public record StudyMatchPairRequest(
        @NotBlank String leftId,
        @NotBlank String rightId) {
}
