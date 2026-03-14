package com.lumos.study.service;

import com.lumos.study.dto.request.UpdateSpeechPreferenceRequest;
import com.lumos.study.dto.response.SpeechPreferenceResponse;

public interface SpeechPreferenceService {

    SpeechPreferenceResponse getSpeechPreference();

    SpeechPreferenceResponse updateSpeechPreference(UpdateSpeechPreferenceRequest request);
}
