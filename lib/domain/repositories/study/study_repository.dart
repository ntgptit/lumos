import '../../entities/study/study_models.dart';

abstract class StudyRepository {
  Future<StudySessionData> startSession({
    required int deckId,
    StudySessionTypeOption? preferredSessionType,
  });

  Future<StudySessionData> resumeSession({required int sessionId});

  Future<StudySessionData> submitAnswer({
    required int sessionId,
    required String answer,
  });

  Future<StudySessionData> submitMatchedPairs({
    required int sessionId,
    required List<StudyMatchSubmission> matchedPairs,
  });

  Future<StudySessionData> revealAnswer({required int sessionId});

  Future<StudySessionData> markRemembered({required int sessionId});

  Future<StudySessionData> retryItem({required int sessionId});

  Future<StudySessionData> goNext({required int sessionId});

  Future<StudySessionData> resetCurrentMode({required int sessionId});

  Future<void> resetDeckProgress({required int deckId});

  Future<StudyReminderSummary> getReminderSummary();

  Future<StudyAnalyticsOverview> getAnalyticsOverview();

  Future<SpeechPreference> getSpeechPreference();

  Future<SpeechPreference> updateSpeechPreference({
    required SpeechPreference preference,
  });
}
