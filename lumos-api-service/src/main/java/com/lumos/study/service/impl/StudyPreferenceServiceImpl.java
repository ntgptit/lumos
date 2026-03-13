package com.lumos.study.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.dto.request.UpdateStudyPreferenceRequest;
import com.lumos.study.dto.response.StudyPreferenceResponse;
import com.lumos.study.entity.UserStudyPreference;
import com.lumos.study.mapper.StudyPreferenceMapper;
import com.lumos.study.service.StudyPreferenceService;
import com.lumos.study.support.UserStudyPreferenceSupport;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StudyPreferenceServiceImpl implements StudyPreferenceService {

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final UserStudyPreferenceSupport userStudyPreferenceSupport;
    private final StudyPreferenceMapper studyPreferenceMapper;

    /**
     * Return the current user's persisted study preference.
     *
     * @return study preference response
     */
    @Override
    @Transactional
    public StudyPreferenceResponse getStudyPreference() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final UserStudyPreference preference = this.userStudyPreferenceSupport.resolvePreference(userId);
        // Return the persisted study preference so the profile screen can render the current first-learning limit.
        return toResponse(preference);
    }

    /**
     * Update and return the current user's study preference.
     *
     * @param request study preference update payload
     * @return updated study preference response
     */
    @Override
    @Transactional
    public StudyPreferenceResponse updateStudyPreference(UpdateStudyPreferenceRequest request) {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final UserStudyPreference preference = this.userStudyPreferenceSupport.resolvePreference(userId);
        preference.setFirstLearningCardLimit(request.firstLearningCardLimit());
        // Return the saved study preference snapshot so first-learning session setup uses the canonical limit.
        return toResponse(preference);
    }

    private StudyPreferenceResponse toResponse(UserStudyPreference preference) {
        // Return the DTO projection exposed by the profile study-preference API.
        return this.studyPreferenceMapper.toStudyPreferenceResponse(preference);
    }
}
