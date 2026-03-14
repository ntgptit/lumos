package com.lumos.study.dto.response;

import java.util.List;

import com.lumos.study.enums.TtsAdapterType;

public record SpeechCapabilityResponse(
        boolean enabled,
        boolean autoPlay,
        boolean available,
        TtsAdapterType adapter,
        String locale,
        String voice,
        Double speed,
        Double pitch,
        String fieldName,
        String sourceType,
        String audioUrl,
        List<String> allowedActions,
        String speechText) {
}
