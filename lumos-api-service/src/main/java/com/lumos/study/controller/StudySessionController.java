package com.lumos.study.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.study.dto.request.StartStudySessionRequest;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.dto.request.UpdateStudyPreferenceRequest;
import com.lumos.study.dto.request.UpdateSpeechPreferenceRequest;
import com.lumos.study.dto.response.StudyPreferenceResponse;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.dto.response.StudySessionResponse;
import com.lumos.study.service.SpeechPreferenceService;
import com.lumos.study.service.StudyPreferenceService;
import com.lumos.study.service.StudySessionService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

/**
 * Study session and speech preference endpoints.
 */
@Validated
@RestController
@RequiredArgsConstructor
@Tag(name = "Study", description = "Study session and spaced repetition APIs")
public class StudySessionController {

    private final StudySessionService studySessionService;
    private final SpeechPreferenceService speechPreferenceService;
    private final StudyPreferenceService studyPreferenceService;

    /**
     * Start a canonical study session for the selected deck.
     *
     * @param request session creation payload
     * @return created study session response
     */
    @Operation(summary = "Start study session")
    @PostMapping("/api/v1/study/sessions")
    public ResponseEntity<StudySessionResponse> startSession(@Valid
    @RequestBody StartStudySessionRequest request) {
        final var response = this.studySessionService
                .startSession(request);
        // Return the created session snapshot so the study screen can bootstrap from backend state.
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    /**
     * Resume the specified study session.
     *
     * @param sessionId study session identifier
     * @return resumed study session response
     */
    @Operation(summary = "Resume study session")
    @GetMapping("/api/v1/study/sessions/{sessionId}")
    public ResponseEntity<StudySessionResponse> resumeSession(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .resumeSession(sessionId);
        // Return the persisted session snapshot so the client can resume without rebuilding state locally.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Submit an answer for the current session item.
     *
     * @param sessionId study session identifier
     * @param request   answer submission payload
     * @return updated study session response
     */
    @Operation(summary = "Submit study answer")
    @PostMapping("/api/v1/study/sessions/{sessionId}/submit-answer")
    public ResponseEntity<StudySessionResponse> submitAnswer(
            @PathVariable Long sessionId,
            @Valid
            @RequestBody SubmitAnswerRequest request) {
        final var response = this.studySessionService
                .submitAnswer(sessionId, request);
        // Return the post-submit session snapshot so the client can render feedback from backend truth.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Reveal the answer for the current session item.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Operation(summary = "Reveal answer")
    @PostMapping("/api/v1/study/sessions/{sessionId}/reveal-answer")
    public ResponseEntity<StudySessionResponse> revealAnswer(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .revealAnswer(sessionId);
        // Return the reveal-state snapshot so the client can switch into feedback mode.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Mark the current session item as remembered.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Operation(summary = "Mark remembered")
    @PostMapping("/api/v1/study/sessions/{sessionId}/mark-remembered")
    public ResponseEntity<StudySessionResponse> markRemembered(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .markRemembered(sessionId);
        // Return the session snapshot after recording a remembered outcome for the current item.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Move the current session item into the retry queue.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Operation(summary = "Retry item")
    @PostMapping("/api/v1/study/sessions/{sessionId}/retry-item")
    public ResponseEntity<StudySessionResponse> retryItem(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .retryItem(sessionId);
        // Return the session snapshot after moving the current item into the retry path.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Advance the session to the next allowed item or mode.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Operation(summary = "Go next")
    @PostMapping("/api/v1/study/sessions/{sessionId}/next")
    public ResponseEntity<StudySessionResponse> goNext(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .goNext(sessionId);
        // Return the advanced session snapshot so the study screen can render the next backend-selected item.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Reset all progress in the current active mode.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Operation(summary = "Reset current mode")
    @PostMapping("/api/v1/study/sessions/{sessionId}/reset-current-mode")
    public ResponseEntity<StudySessionResponse> resetCurrentMode(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .resetCurrentMode(sessionId);
        // Return the reset mode snapshot so the client can restart the active mode from backend truth.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Reset all learning progress for the specified deck and current user.
     *
     * @param deckId deck identifier
     * @return empty success response
     */
    @Operation(summary = "Reset deck learning progress")
    @PostMapping("/api/v1/study/decks/{deckId}/reset-progress")
    public ResponseEntity<Void> resetDeckProgress(@PathVariable Long deckId) {
        this.studySessionService.resetDeckProgress(deckId);
        // Return no content because the reset command completes without a response body.
        return ResponseEntity.noContent().build();
    }

    /**
     * Complete the current mode when all items satisfy the completion rule.
     *
     * @param sessionId study session identifier
     * @return updated study session response
     */
    @Operation(summary = "Complete mode")
    @PostMapping("/api/v1/study/sessions/{sessionId}/complete-mode")
    public ResponseEntity<StudySessionResponse> completeMode(@PathVariable Long sessionId) {
        final var response = this.studySessionService
                .completeMode(sessionId);
        // Return the next-mode or completed-session snapshot after backend mode completion logic runs.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Return the current user's speech preference.
     *
     * @return speech preference response
     */
    @Operation(summary = "Get speech preference")
    @GetMapping("/api/v1/profile/speech-preference")
    public ResponseEntity<SpeechPreferenceResponse> getSpeechPreference() {
        final var response = this.speechPreferenceService
                .getSpeechPreference();
        // Return the current speech preference so profile and study screens stay in sync.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Update the current user's speech preference.
     *
     * @param request speech preference update payload
     * @return updated speech preference response
     */
    @Operation(summary = "Update speech preference")
    @PutMapping("/api/v1/profile/speech-preference")
    public ResponseEntity<SpeechPreferenceResponse> updateSpeechPreference(
            @Valid
            @RequestBody UpdateSpeechPreferenceRequest request) {
        final var response = this.speechPreferenceService
                .updateSpeechPreference(request);
        // Return the saved speech preference so the client reflects canonical audio settings.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Return the current user's study preference.
     *
     * @return study preference response
     */
    @Operation(summary = "Get study preference")
    @GetMapping("/api/v1/profile/study-preference")
    public ResponseEntity<StudyPreferenceResponse> getStudyPreference() {
        final var response = this.studyPreferenceService
                .getStudyPreference();
        // Return the current study preference so the profile screen can render the first-learning session size.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Update the current user's study preference.
     *
     * @param request study preference update payload
     * @return updated study preference response
     */
    @Operation(summary = "Update study preference")
    @PutMapping("/api/v1/profile/study-preference")
    public ResponseEntity<StudyPreferenceResponse> updateStudyPreference(
            @Valid
            @RequestBody UpdateStudyPreferenceRequest request) {
        final var response = this.studyPreferenceService
                .updateStudyPreference(request);
        // Return the saved study preference so first-learning session size stays aligned with backend truth.
        return ResponseEntity
                .ok(response);
    }
}
