package com.lumos.study.dto.response;

public record SpeechCapabilityResponse(
        boolean enabled,
        boolean autoPlay,
        boolean available,
        String locale,
        String voice,
        Double speed,
        String speechText) {
}
