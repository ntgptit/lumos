package com.lumos.study.controller;

import static com.lumos.testkit.StudyTestFixtures.speechPreferenceResponse;
import static com.lumos.testkit.StudyTestFixtures.startStudySessionRequest;
import static com.lumos.testkit.StudyTestFixtures.studyPreferenceResponse;
import static com.lumos.testkit.StudyTestFixtures.studySessionResponse;
import static com.lumos.testkit.StudyTestFixtures.submitAnswerRequest;
import static com.lumos.testkit.StudyTestFixtures.updateStudyPreferenceRequest;
import static com.lumos.testkit.StudyTestFixtures.updateSpeechPreferenceRequest;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.study.service.SpeechPreferenceService;
import com.lumos.study.service.StudyPreferenceService;
import com.lumos.study.service.StudySessionService;

@ExtendWith(MockitoExtension.class)
class StudySessionControllerTest {

    private static final Long SESSION_ID = 33L;
    private static final Long DECK_ID = 10L;

    @Mock
    private StudySessionService studySessionService;

    @Mock
    private SpeechPreferenceService speechPreferenceService;

    @Mock
    private StudyPreferenceService studyPreferenceService;

    @InjectMocks
    private StudySessionController studySessionController;

    @Test
    void startSession_returnsCreatedResponse() {
        final var request = startStudySessionRequest(DECK_ID);
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.startSession(request)).thenReturn(response);

        final var entity = this.studySessionController.startSession(request);

        assertEquals(201, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void resumeSession_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.resumeSession(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.resumeSession(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void submitAnswer_returnsOkResponse() {
        final var request = submitAnswerRequest("xin chao");
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.submitAnswer(SESSION_ID, request)).thenReturn(response);

        final var entity = this.studySessionController.submitAnswer(SESSION_ID, request);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void revealAnswer_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.revealAnswer(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.revealAnswer(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void markRemembered_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.markRemembered(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.markRemembered(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void retryItem_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.retryItem(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.retryItem(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void goNext_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.goNext(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.goNext(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void resetCurrentMode_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.resetCurrentMode(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.resetCurrentMode(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void resetDeckProgress_returnsNoContentResponse() {
        final var entity = this.studySessionController.resetDeckProgress(DECK_ID);

        verify(this.studySessionService).resetDeckProgress(DECK_ID);
        assertEquals(204, entity.getStatusCode().value());
    }

    @Test
    void completeMode_returnsOkResponse() {
        final var response = studySessionResponse(SESSION_ID, DECK_ID, "Korean Basics");
        when(this.studySessionService.completeMode(SESSION_ID)).thenReturn(response);

        final var entity = this.studySessionController.completeMode(SESSION_ID);

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void getSpeechPreference_returnsOkResponse() {
        final var response = speechPreferenceResponse();
        when(this.speechPreferenceService.getSpeechPreference()).thenReturn(response);

        final var entity = this.studySessionController.getSpeechPreference();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateSpeechPreference_returnsOkResponse() {
        final var request = updateSpeechPreferenceRequest(true, true, "ko-KR-female", 1.2D);
        final var response = speechPreferenceResponse();
        when(this.speechPreferenceService.updateSpeechPreference(request)).thenReturn(response);

        final var entity = this.studySessionController.updateSpeechPreference(request);

        verify(this.speechPreferenceService).updateSpeechPreference(request);
        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void getStudyPreference_returnsOkResponse() {
        final var response = studyPreferenceResponse();
        when(this.studyPreferenceService.getStudyPreference()).thenReturn(response);

        final var entity = this.studySessionController.getStudyPreference();

        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }

    @Test
    void updateStudyPreference_returnsOkResponse() {
        final var request = updateStudyPreferenceRequest(20);
        final var response = studyPreferenceResponse();
        when(this.studyPreferenceService.updateStudyPreference(request)).thenReturn(response);

        final var entity = this.studySessionController.updateStudyPreference(request);

        verify(this.studyPreferenceService).updateStudyPreference(request);
        assertEquals(200, entity.getStatusCode().value());
        assertEquals(response, entity.getBody());
    }
}
