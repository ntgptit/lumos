package com.lumos.study.dto.response;

public record ProgressSummaryResponse(
        int completedItems,
        int totalItems,
        int completedModes,
        int totalModes,
        double itemProgress,
        double modeProgress,
        double sessionProgress) {
}
