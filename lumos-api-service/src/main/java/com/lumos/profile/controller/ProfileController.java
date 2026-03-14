package com.lumos.profile.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lumos.profile.dto.response.ProfileResponse;
import com.lumos.profile.service.ProfileService;
import com.lumos.study.dto.request.UpdateSpeechPreferenceRequest;
import com.lumos.study.dto.request.UpdateStudyPreferenceRequest;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.dto.response.StudyPreferenceResponse;
import com.lumos.study.service.SpeechPreferenceService;
import com.lumos.study.service.StudyPreferenceService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

/**
 * Profile endpoints for account and preference state.
 */
@Validated
@RestController
@RequiredArgsConstructor
@Tag(name = "Profile", description = "Account profile and preference APIs")
@RequestMapping("/api/v1/profile")
public class ProfileController {

    private final ProfileService profileService;
    private final SpeechPreferenceService speechPreferenceService;
    private final StudyPreferenceService studyPreferenceService;

    /**
     * Return the current authenticated profile snapshot.
     *
     * @return profile response
     */
    @Operation(summary = "Get profile")
    @GetMapping
    public ResponseEntity<ProfileResponse> getProfile() {
        final ProfileResponse response = this.profileService.getProfile();
        // Return the aggregated profile snapshot so the client can bootstrap account settings from one endpoint.
        return ResponseEntity
                .ok(response);
    }

    /**
     * Return the current user's speech preference.
     *
     * @return speech preference response
     */
    @Operation(summary = "Get speech preference")
    @GetMapping("/speech-preference")
    public ResponseEntity<SpeechPreferenceResponse> getSpeechPreference() {
        final SpeechPreferenceResponse response = this.speechPreferenceService.getSpeechPreference();
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
    @PutMapping("/speech-preference")
    public ResponseEntity<SpeechPreferenceResponse> updateSpeechPreference(
            @Valid
            @RequestBody UpdateSpeechPreferenceRequest request) {
        final SpeechPreferenceResponse response = this.speechPreferenceService.updateSpeechPreference(request);
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
    @GetMapping("/study-preference")
    public ResponseEntity<StudyPreferenceResponse> getStudyPreference() {
        final StudyPreferenceResponse response = this.studyPreferenceService.getStudyPreference();
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
    @PutMapping("/study-preference")
    public ResponseEntity<StudyPreferenceResponse> updateStudyPreference(
            @Valid
            @RequestBody UpdateStudyPreferenceRequest request) {
        final StudyPreferenceResponse response = this.studyPreferenceService.updateStudyPreference(request);
        // Return the saved study preference so first-learning session size stays aligned with backend truth.
        return ResponseEntity
                .ok(response);
    }
}
