package com.lumos.study.support;

import java.util.List;
import java.util.Objects;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.lumos.auth.security.AuthenticatedUserProvider;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.dto.response.ProgressSummaryResponse;
import com.lumos.study.dto.response.SpeechCapabilityResponse;
import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.dto.response.StudyMatchPairResponse;
import com.lumos.study.dto.response.StudySessionItemResponse;
import com.lumos.study.dto.response.StudySessionResponse;
import com.lumos.study.entity.StudySession;
import com.lumos.study.entity.StudySessionItem;
import com.lumos.study.entity.UserSpeechPreference;
import com.lumos.study.enums.StudyMode;
import com.lumos.study.mode.StudyModeStrategy;
import com.lumos.study.mode.StudyModeStrategyFactory;
import com.lumos.study.repository.StudySessionItemRepository;
import com.lumos.study.repository.UserSpeechPreferenceRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StudySessionResponseFactory {

    private static final int FIRST_MODE_INDEX = 0;
    private static final String SPEECH_ACTION_PLAY = "play_speech";
    private static final String SPEECH_ACTION_REPLAY = "replay_speech";
    private static final String SPEECH_FIELD_PROMPT = "prompt";
    private static final String SPEECH_SOURCE_TEXT = "text";

    private final AuthenticatedUserProvider authenticatedUserProvider;
    private final StudySessionItemRepository studySessionItemRepository;
    private final UserSpeechPreferenceRepository userSpeechPreferenceRepository;
    private final StudyModeStrategyFactory studyModeStrategyFactory;
    private final StudySessionSetupSupport studySessionSetupSupport;

    public StudySessionResponse buildResponse(StudySession session) {
        final List<StudySessionItem> items = this.studySessionItemRepository
                .findAllByStudySessionIdAndDeletedAtIsNullOrderBySequenceIndexAsc(session.getId());
        final StudySessionItem currentItem = resolveCurrentResponseItem(session, items);
        return new StudySessionResponse(
                session.getId(),
                session.getDeck().getId(),
                session.getDeck().getName(),
                session.getSessionType().name(),
                session.getActiveMode().name(),
                session.getModeState().name(),
                this.studySessionSetupSupport.parseModePlan(session.getModePlan()).stream().map(Enum::name).toList(),
                currentItem == null
                        ? List.of()
                        : resolveStudyModeStrategy(session.getActiveMode()).resolveAllowedActions(session, currentItem),
                buildProgress(session, items),
                currentItem == null ? null : buildCurrentItemResponse(session, currentItem, items),
                session.getSessionCompleted());
    }

    private StudySessionItem resolveCurrentResponseItem(StudySession session, List<StudySessionItem> items) {
        if (items.isEmpty()) {
            return null;
        }
        return items.stream()
                .filter(item -> Objects.deepEquals(item.getSequenceIndex(), session.getCurrentItemIndex()))
                .findFirst()
                .orElse(items.get(FIRST_MODE_INDEX));
    }

    private ProgressSummaryResponse buildProgress(StudySession session, List<StudySessionItem> items) {
        final int completedItems = (int) items.stream().filter(StudySessionItem::getCurrentModeCompleted).count();
        final int totalItems = items.size();
        final int completedModes = session.getCurrentModeIndex();
        final int totalModes = this.studySessionSetupSupport.parseModePlan(session.getModePlan()).size();
        final double itemProgress = totalItems == 0 ? 0.0D : (double) completedItems / totalItems;
        final double modeProgress = totalModes == 0 ? 0.0D : (double) completedModes / totalModes;
        final double sessionProgress = totalModes == 0
                ? itemProgress
                : ((double) completedModes + itemProgress) / totalModes;
        return new ProgressSummaryResponse(
                completedItems,
                totalItems,
                completedModes,
                totalModes,
                itemProgress,
                modeProgress,
                sessionProgress);
    }

    private StudySessionItemResponse buildCurrentItemResponse(
            StudySession session,
            StudySessionItem currentItem,
            List<StudySessionItem> items) {
        final StudyModeStrategy studyModeStrategy = resolveStudyModeStrategy(session.getActiveMode());
        final String prompt = studyModeStrategy.resolvePrompt(currentItem);
        final List<StudyChoiceResponse> choices = studyModeStrategy.resolveChoices(currentItem, items);
        final List<StudyMatchPairResponse> matchPairs = studyModeStrategy.resolveMatchPairs(currentItem, items);
        final UserSpeechPreference speechPreference = resolveSpeechPreference();
        return new StudySessionItemResponse(
                currentItem.getFlashcard().getId(),
                prompt,
                studyModeStrategy.resolveExpectedAnswer(currentItem),
                currentItem.getNoteSnapshot(),
                currentItem.getPronunciationSnapshot(),
                studyModeStrategy.resolveInstruction(),
                studyModeStrategy.resolveInputPlaceholder(),
                choices,
                matchPairs,
                buildSpeechCapability(speechPreference, prompt));
    }

    private UserSpeechPreference resolveSpeechPreference() {
        final Long userId = this.authenticatedUserProvider.getCurrentUserId();
        return this.userSpeechPreferenceRepository.findByUserAccountIdAndDeletedAtIsNull(userId)
                .orElseGet(() -> {
                    final UserSpeechPreference preference = new UserSpeechPreference();
                    preference.setEnabled(Boolean.TRUE);
                    preference.setAutoPlay(Boolean.FALSE);
                    preference.setAdapter(StudyConstants.DEFAULT_TTS_ADAPTER);
                    preference.setVoice(StudyConstants.DEFAULT_SPEECH_VOICE);
                    preference.setSpeed(StudyConstants.DEFAULT_SPEECH_SPEED);
                    preference.setPitch(StudyConstants.DEFAULT_SPEECH_PITCH);
                    preference.setLocale(StudyConstants.SPEECH_LOCALE);
                    return preference;
                });
    }

    private StudyModeStrategy resolveStudyModeStrategy(StudyMode studyMode) {
        return this.studyModeStrategyFactory.getStrategy(studyMode);
    }

    private SpeechCapabilityResponse buildSpeechCapability(UserSpeechPreference speechPreference, String prompt) {
        final boolean available = speechPreference.getEnabled() && StringUtils.isNotBlank(prompt);
        return new SpeechCapabilityResponse(
                speechPreference.getEnabled(),
                speechPreference.getAutoPlay(),
                available,
                speechPreference.getAdapter(),
                speechPreference.getLocale(),
                speechPreference.getVoice(),
                speechPreference.getSpeed(),
                speechPreference.getPitch(),
                SPEECH_FIELD_PROMPT,
                SPEECH_SOURCE_TEXT,
                "",
                available ? List.of(SPEECH_ACTION_PLAY, SPEECH_ACTION_REPLAY) : List.of(),
                prompt);
    }
}
