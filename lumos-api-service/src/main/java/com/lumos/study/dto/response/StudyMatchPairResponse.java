package com.lumos.study.dto.response;

public record StudyMatchPairResponse(
        String leftId,
        String leftLabel,
        String rightId,
        String rightLabel) {
}
