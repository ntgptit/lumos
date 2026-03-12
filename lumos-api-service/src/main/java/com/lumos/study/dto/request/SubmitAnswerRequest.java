package com.lumos.study.dto.request;

import jakarta.validation.constraints.NotBlank;

public record SubmitAnswerRequest(@NotBlank String answer) {
}
