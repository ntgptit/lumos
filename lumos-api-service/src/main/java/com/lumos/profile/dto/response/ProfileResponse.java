package com.lumos.profile.dto.response;

import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.dto.response.StudyPreferenceResponse;

public record ProfileResponse(
        CurrentUserResponse user,
        StudyPreferenceResponse studyPreference,
        SpeechPreferenceResponse speechPreference) {
}
