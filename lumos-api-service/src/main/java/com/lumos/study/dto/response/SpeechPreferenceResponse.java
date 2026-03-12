package com.lumos.study.dto.response;

public record SpeechPreferenceResponse(
        boolean enabled,
        boolean autoPlay,
        String voice,
        Double speed,
        String locale) {
}
