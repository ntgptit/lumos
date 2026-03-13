package com.lumos.study.dto.response;

import java.util.List;

public record SpeechCapabilityResponse(
        boolean enabled,
        boolean autoPlay,
        boolean available,
        String locale,
        String voice,
        Double speed,
        String fieldName,
        String sourceType,
        String audioUrl,
        List<String> allowedActions,
        String speechText) {
}
