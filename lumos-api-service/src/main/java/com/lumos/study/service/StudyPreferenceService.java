package com.lumos.study.service;

import com.lumos.study.dto.request.UpdateStudyPreferenceRequest;
import com.lumos.study.dto.response.StudyPreferenceResponse;

public interface StudyPreferenceService {

    StudyPreferenceResponse getStudyPreference();

    StudyPreferenceResponse updateStudyPreference(UpdateStudyPreferenceRequest request);
}
