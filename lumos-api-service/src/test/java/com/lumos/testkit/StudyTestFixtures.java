package com.lumos.testkit;

import java.util.List;
import java.util.Map;

import com.lumos.study.dto.request.StartStudySessionRequest;
import com.lumos.study.dto.request.SubmitAnswerRequest;
import com.lumos.study.dto.request.StudyMatchPairRequest;
import com.lumos.study.dto.request.UpdateStudyPreferenceRequest;
import com.lumos.study.dto.request.UpdateSpeechPreferenceRequest;
import com.lumos.study.enums.TtsAdapterType;
import com.lumos.study.enums.StudySessionType;
import com.lumos.reminder.dto.response.ReminderRecommendationResponse;
import com.lumos.reminder.dto.response.ReminderSummaryResponse;
import com.lumos.study.dto.response.ProgressSummaryResponse;
import com.lumos.study.dto.response.SpeechCapabilityResponse;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.dto.response.StudyAnalyticsOverviewResponse;
import com.lumos.study.dto.response.StudyChoiceResponse;
import com.lumos.study.dto.response.StudyMatchPairResponse;
import com.lumos.study.dto.response.StudyPreferenceResponse;
import com.lumos.study.dto.response.StudySessionItemResponse;
import com.lumos.study.dto.response.StudySessionResponse;

public final class StudyTestFixtures {

    private StudyTestFixtures() {
    }

    public static StartStudySessionRequest startStudySessionRequest(Long deckId) {
        
        return new StartStudySessionRequest(deckId, null);
    }

    public static StartStudySessionRequest startStudySessionRequest(Long deckId, StudySessionType preferredSessionType) {
        
        return new StartStudySessionRequest(deckId, preferredSessionType);
    }

    public static SubmitAnswerRequest submitAnswerRequest(String answer) {
        
        return new SubmitAnswerRequest(answer);
    }

    public static SubmitAnswerRequest submitMatchAnswerRequest(String answer, List<StudyMatchPairRequest> matchedPairs) {
        
        return new SubmitAnswerRequest(answer, matchedPairs);
    }

    public static UpdateSpeechPreferenceRequest updateSpeechPreferenceRequest(
            boolean enabled,
            boolean autoPlay,
            TtsAdapterType adapter,
            String voice,
            Double speed,
            Double pitch) {
        
        return new UpdateSpeechPreferenceRequest(enabled, autoPlay, adapter, voice, speed, pitch);
    }

    public static UpdateStudyPreferenceRequest updateStudyPreferenceRequest(int firstLearningCardLimit) {
        
        return new UpdateStudyPreferenceRequest(firstLearningCardLimit);
    }

    public static StudySessionResponse studySessionResponse(Long sessionId, Long deckId, String deckName) {
        
        return new StudySessionResponse(
                sessionId,
                deckId,
                deckName,
                "FIRST_LEARNING",
                "REVIEW",
                "IN_PROGRESS",
                List.of("REVIEW", "MATCH", "GUESS", "RECALL", "FILL"),
                List.of("REVEAL_ANSWER", "MARK_REMEMBERED"),
                new ProgressSummaryResponse(1, 2, 0, 5, 0.5D, 0.0D, 0.1D),
                new StudySessionItemResponse(
                        101L,
                        "안녕하세요",
                        "xin chao",
                        "note",
                        "annyeonghaseyo",
                        "Reveal the answer, then confirm if you remembered it.",
                        "",
                        List.of(new StudyChoiceResponse("choice-0", "xin chao")),
                        List.of(new StudyMatchPairResponse("left-101", "안녕하세요", "right-101", "xin chao")),
                        new SpeechCapabilityResponse(
                                true,
                                false,
                                true,
                                TtsAdapterType.FLUTTER_TTS,
                                "ko-KR",
                                "ko-KR-neutral",
                                1.0D,
                                1.0D,
                                "prompt",
                                "text",
                                "",
                                List.of("play_speech", "replay_speech"),
                                "안녕하세요")),
                false);
    }

    public static ReminderSummaryResponse studyReminderSummaryResponse() {
        
        return new ReminderSummaryResponse(
                4L,
                2L,
                "LEVEL_1",
                List.of("IN_APP_BADGE_DUE_LIST", "DUE_BASED_SESSION_RECOMMENDATION"),
                new ReminderRecommendationResponse(10L, "Korean Basics", 4, 2, 1, "REVIEW"));
    }

    public static StudyAnalyticsOverviewResponse studyAnalyticsOverviewResponse() {
        
        return new StudyAnalyticsOverviewResponse(
                12L,
                4L,
                2L,
                9L,
                3L,
                Map.of(1, 3L, 2, 4L, 3, 5L));
    }

    public static SpeechPreferenceResponse speechPreferenceResponse() {
        
        return new SpeechPreferenceResponse(
                true,
                false,
                TtsAdapterType.FLUTTER_TTS,
                "ko-KR-neutral",
                1.0D,
                1.0D,
                "ko-KR");
    }

    public static StudyPreferenceResponse studyPreferenceResponse() {
        
        return new StudyPreferenceResponse(20);
    }
}
