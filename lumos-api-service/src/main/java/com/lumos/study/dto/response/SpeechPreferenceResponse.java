package com.lumos.study.dto.response;

import com.lumos.study.enums.TtsAdapterType;

public record SpeechPreferenceResponse(
        boolean enabled,
        boolean autoPlay,
        TtsAdapterType adapter,
        String voice,
        Double speed,
        Double pitch,
        String locale) {
}
