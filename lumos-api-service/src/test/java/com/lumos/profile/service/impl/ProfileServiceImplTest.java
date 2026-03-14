package com.lumos.profile.service.impl;

import static com.lumos.testkit.ProfileTestFixtures.currentUserResponse;
import static com.lumos.testkit.StudyTestFixtures.speechPreferenceResponse;
import static com.lumos.testkit.StudyTestFixtures.studyPreferenceResponse;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mapstruct.factory.Mappers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.service.AuthService;
import com.lumos.profile.mapper.ProfileMapper;
import com.lumos.study.service.SpeechPreferenceService;
import com.lumos.study.service.StudyPreferenceService;

@ExtendWith(MockitoExtension.class)
class ProfileServiceImplTest {

    @Mock
    private AuthService authService;

    @Mock
    private StudyPreferenceService studyPreferenceService;

    @Mock
    private SpeechPreferenceService speechPreferenceService;

    @Spy
    private ProfileMapper profileMapper = Mappers.getMapper(ProfileMapper.class);

    @InjectMocks
    private ProfileServiceImpl profileService;

    @Test
    void getProfile_returnsAggregatedProfileSnapshot() {
        final var user = currentUserResponse();
        final var studyPreference = studyPreferenceResponse();
        final var speechPreference = speechPreferenceResponse();
        when(this.authService.getCurrentUser()).thenReturn(user);
        when(this.studyPreferenceService.getStudyPreference()).thenReturn(studyPreference);
        when(this.speechPreferenceService.getSpeechPreference()).thenReturn(speechPreference);

        final var response = this.profileService.getProfile();

        assertEquals(user, response.user());
        assertEquals(studyPreference, response.studyPreference());
        assertEquals(speechPreference, response.speechPreference());
    }
}
