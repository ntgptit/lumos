package com.lumos.study.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mapstruct.factory.Mappers;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.entity.UserSpeechPreference;
import com.lumos.study.mapper.SpeechPreferenceMapper;
import com.lumos.study.repository.UserSpeechPreferenceRepository;

@ExtendWith(MockitoExtension.class)
class SpeechPreferenceServiceImplTest {

    private static final Long USER_ID = 15L;

    @Mock
    private AuthenticatedUserProvider authenticatedUserProvider;

    @Mock
    private UserAccountRepository userAccountRepository;

    @Mock
    private UserSpeechPreferenceRepository userSpeechPreferenceRepository;

    @Spy
    private SpeechPreferenceMapper speechPreferenceMapper = Mappers.getMapper(SpeechPreferenceMapper.class);

    private SpeechPreferenceServiceImpl speechPreferenceService;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        this.speechPreferenceService = new SpeechPreferenceServiceImpl(
                this.authenticatedUserProvider,
                this.userAccountRepository,
                this.userSpeechPreferenceRepository,
                this.speechPreferenceMapper);
    }

    @Test
    void getSpeechPreference_returnsExistingPreference() {
        final UserSpeechPreference preference = preference();
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID))
                .thenReturn(Optional.of(preference));

        final var response = this.speechPreferenceService.getSpeechPreference();

        assertEquals(true, response.enabled());
        assertEquals("ko-KR-neutral", response.voice());
        assertEquals("ko-KR", response.locale());
    }

    @Test
    void updateSpeechPreference_createsDefaultPreferenceWhenMissing() {
        final UserAccount userAccount = new UserAccount();
        userAccount.setId(USER_ID);
        final UserSpeechPreference savedPreference = preference();
        when(this.authenticatedUserProvider.getCurrentUserId()).thenReturn(USER_ID);
        when(this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(USER_ID))
                .thenReturn(Optional.empty());
        when(this.userAccountRepository.findByIdAndDeletedAtIsNull(USER_ID)).thenReturn(Optional.of(userAccount));
        when(this.userSpeechPreferenceRepository.save(any(UserSpeechPreference.class))).thenReturn(savedPreference);

        final var response = this.speechPreferenceService.updateSpeechPreference(
                new com.lumos.study.dto.request.UpdateSpeechPreferenceRequest(false, true, "ko-KR-female", 1.25D));

        verify(this.userSpeechPreferenceRepository).save(any(UserSpeechPreference.class));
        assertEquals(false, response.enabled());
        assertEquals(true, response.autoPlay());
        assertEquals("ko-KR-female", response.voice());
        assertEquals(1.25D, response.speed());
        assertEquals(StudyConstants.SPEECH_LOCALE, response.locale());
    }

    private UserSpeechPreference preference() {
        final UserSpeechPreference preference = new UserSpeechPreference();
        preference.setEnabled(true);
        preference.setAutoPlay(false);
        preference.setVoice("ko-KR-neutral");
        preference.setSpeed(1.0D);
        preference.setLocale("ko-KR");
        
        return preference;
    }
}
