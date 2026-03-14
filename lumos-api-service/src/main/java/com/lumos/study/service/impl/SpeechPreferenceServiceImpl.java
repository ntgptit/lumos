package com.lumos.study.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.exception.UnauthorizedAccessException;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.dto.request.UpdateSpeechPreferenceRequest;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.entity.UserSpeechPreference;
import com.lumos.study.mapper.SpeechPreferenceMapper;
import com.lumos.study.repository.UserSpeechPreferenceRepository;
import com.lumos.study.service.SpeechPreferenceService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SpeechPreferenceServiceImpl implements SpeechPreferenceService {

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final UserAccountRepository userAccountRepository;
    private final UserSpeechPreferenceRepository userSpeechPreferenceRepository;
    private final SpeechPreferenceMapper speechPreferenceMapper;

    /**
     * Return the current user's persisted speech preference.
     *
     * @return speech preference response
     */
    @Override
    @Transactional
    public SpeechPreferenceResponse getSpeechPreference() {
        final UserSpeechPreference preference = resolvePreference();
        // Return the persisted speech preference so the client can render the current account-level setting.
        return toResponse(preference);
    }

    /**
     * Update and return the current user's speech preference.
     *
     * @param request speech preference update payload
     * @return updated speech preference response
     */
    @Override
    @Transactional
    public SpeechPreferenceResponse updateSpeechPreference(UpdateSpeechPreferenceRequest request) {
        final UserSpeechPreference preference = resolvePreference();
        preference.setEnabled(request.enabled());
        preference.setAutoPlay(request.autoPlay());
        preference.setAdapter(request.adapter());
        preference.setVoice(request.voice());
        preference.setSpeed(request.speed());
        preference.setPitch(request.pitch());
        // Return the saved preference snapshot so the client stays aligned with the backend canonical state.
        return toResponse(preference);
    }

    private UserSpeechPreference resolvePreference() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final UserSpeechPreference existingPreference = this.userSpeechPreferenceRepository
                .findByUserAccountIdAndDeletedAtIsNull(userId)
                .orElse(null);
        // Reuse the stored preference when the user has already configured speech options.
        if (existingPreference != null) {
            // Return the existing preference instead of creating a duplicate row for the same account.
            return existingPreference;
        }
        final UserAccount userAccount = this.userAccountRepository.findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(UnauthorizedAccessException::new);
        final UserSpeechPreference preference = new UserSpeechPreference();
        preference.setUserAccount(userAccount);
        preference.setEnabled(Boolean.TRUE);
        preference.setAutoPlay(Boolean.FALSE);
        preference.setAdapter(StudyConstants.DEFAULT_TTS_ADAPTER);
        preference.setVoice(StudyConstants.DEFAULT_SPEECH_VOICE);
        preference.setSpeed(StudyConstants.DEFAULT_SPEECH_SPEED);
        preference.setPitch(StudyConstants.DEFAULT_SPEECH_PITCH);
        preference.setLocale(StudyConstants.SPEECH_LOCALE);
        // Return the newly persisted default preference so later reads and updates reuse the same record.
        return this.userSpeechPreferenceRepository.save(preference);
    }

    private SpeechPreferenceResponse toResponse(UserSpeechPreference preference) {
        // Return the DTO projection exposed by the profile speech-preference API.
        return this.speechPreferenceMapper.toSpeechPreferenceResponse(preference);
    }
}
