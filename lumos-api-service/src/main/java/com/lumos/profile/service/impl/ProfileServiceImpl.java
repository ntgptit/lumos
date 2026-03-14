package com.lumos.profile.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.auth.service.AuthService;
import com.lumos.profile.dto.response.ProfileResponse;
import com.lumos.profile.mapper.ProfileMapper;
import com.lumos.profile.service.ProfileService;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.dto.response.StudyPreferenceResponse;
import com.lumos.study.service.SpeechPreferenceService;
import com.lumos.study.service.StudyPreferenceService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProfileServiceImpl implements ProfileService {

    private final AuthService authService;
    private final StudyPreferenceService studyPreferenceService;
    private final SpeechPreferenceService speechPreferenceService;
    private final ProfileMapper profileMapper;

    /**
     * Return the current authenticated profile snapshot.
     *
     * @return aggregated profile response
     */
    @Override
    @Transactional(readOnly = true)
    public ProfileResponse getProfile() {
        final CurrentUserResponse user = this.authService.getCurrentUser();
        final StudyPreferenceResponse studyPreference = this.studyPreferenceService.getStudyPreference();
        final SpeechPreferenceResponse speechPreference = this.speechPreferenceService.getSpeechPreference();
        // Return the canonical profile snapshot so the client can render account and preference state from one read.
        return this.profileMapper.toProfileResponse(user, studyPreference, speechPreference);
    }
}
