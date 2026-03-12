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
import com.lumos.study.repository.UserSpeechPreferenceRepository;
import com.lumos.study.service.SpeechPreferenceService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SpeechPreferenceServiceImpl implements SpeechPreferenceService {

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final UserAccountRepository userAccountRepository;
    private final UserSpeechPreferenceRepository userSpeechPreferenceRepository;

    /**
     * Return the current user's persisted speech preference.
     *
     * @return speech preference response
     */
    @Override
    @Transactional
    public SpeechPreferenceResponse getSpeechPreference() {
        final UserSpeechPreference preference = resolvePreference();
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
        preference.setVoice(request.voice());
        preference.setSpeed(request.speed());
        return toResponse(preference);
    }

    private UserSpeechPreference resolvePreference() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        final UserSpeechPreference existingPreference = this.userSpeechPreferenceRepository
                .findByUserAccountIdAndDeletedAtIsNull(userId)
                .orElse(null);
        // Reuse the stored preference when the user has already configured speech options.
        if (existingPreference != null) {
            return existingPreference;
        }
        final UserAccount userAccount = this.userAccountRepository.findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(UnauthorizedAccessException::new);
        final UserSpeechPreference preference = new UserSpeechPreference();
        preference.setUserAccount(userAccount);
        preference.setEnabled(Boolean.TRUE);
        preference.setAutoPlay(Boolean.FALSE);
        preference.setVoice(StudyConstants.DEFAULT_SPEECH_VOICE);
        preference.setSpeed(StudyConstants.DEFAULT_SPEECH_SPEED);
        preference.setLocale(StudyConstants.SPEECH_LOCALE);
        return this.userSpeechPreferenceRepository.save(preference);
    }

    private SpeechPreferenceResponse toResponse(UserSpeechPreference preference) {
        return new SpeechPreferenceResponse(
                preference.getEnabled(),
                preference.getAutoPlay(),
                preference.getVoice(),
                preference.getSpeed(),
                preference.getLocale());
    }
}
