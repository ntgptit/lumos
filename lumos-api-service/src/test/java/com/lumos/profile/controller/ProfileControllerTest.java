package com.lumos.profile.controller;

import static com.lumos.testkit.ProfileTestFixtures.profileResponse;
import static com.lumos.testkit.StudyTestFixtures.speechPreferenceResponse;
import static com.lumos.testkit.StudyTestFixtures.studyPreferenceResponse;
import static com.lumos.testkit.StudyTestFixtures.updateSpeechPreferenceRequest;
import static com.lumos.testkit.StudyTestFixtures.updateStudyPreferenceRequest;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.profile.service.ProfileService;
import com.lumos.study.service.SpeechPreferenceService;
import com.lumos.study.service.StudyPreferenceService;

@ExtendWith(MockitoExtension.class)
class ProfileControllerTest {

    @Mock
    private ProfileService profileService;

    @Mock
    private SpeechPreferenceService speechPreferenceService;

    @Mock
    private StudyPreferenceService studyPreferenceService;

    @InjectMocks
    private ProfileController profileController;

    @Test
    void getProfile_returnsOkResponse() {
        final var response = profileResponse();
        when(this.profileService.getProfile()).thenReturn(response);

        final var entity = this.profileController.getProfile();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void getSpeechPreference_returnsOkResponse() {
        final var response = speechPreferenceResponse();
        when(this.speechPreferenceService.getSpeechPreference()).thenReturn(response);

        final var entity = this.profileController.getSpeechPreference();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateSpeechPreference_returnsOkResponse() {
        final var request = updateSpeechPreferenceRequest(true, true, "ko-KR-female", 1.2D);
        final var response = speechPreferenceResponse();
        when(this.speechPreferenceService.updateSpeechPreference(request)).thenReturn(response);

        final var entity = this.profileController.updateSpeechPreference(request);

        verify(this.speechPreferenceService).updateSpeechPreference(request);
        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void getStudyPreference_returnsOkResponse() {
        final var response = studyPreferenceResponse();
        when(this.studyPreferenceService.getStudyPreference()).thenReturn(response);

        final var entity = this.profileController.getStudyPreference();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateStudyPreference_returnsOkResponse() {
        final var request = updateStudyPreferenceRequest(20);
        final var response = studyPreferenceResponse();
        when(this.studyPreferenceService.updateStudyPreference(request)).thenReturn(response);

        final var entity = this.profileController.updateStudyPreference(request);

        verify(this.studyPreferenceService).updateStudyPreference(request);
        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }
}
