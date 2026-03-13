import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/providers/network_providers.dart';
import '../../../domain/entities/study/study_models.dart';
import '../../../domain/repositories/study/study_repository.dart';

part 'study_repository_impl.g.dart';

abstract final class StudyRepositoryImplConst {
  StudyRepositoryImplConst._();

  static const String sessionsPath = '/api/v1/study/sessions';
  static const String studyDecksPath = '/api/v1/study/decks';
  static const String remindersSummaryPath = '/api/v1/study/reminders/summary';
  static const String analyticsOverviewPath =
      '/api/v1/study/analytics/overview';
  static const String speechPreferencePath =
      '/api/v1/profile/speech-preference';
  static const String studyPreferencePath = '/api/v1/profile/study-preference';
}

class DioStudyRepository implements StudyRepository {
  const DioStudyRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<StudySessionData> startSession({
    required int deckId,
    StudySessionTypeOption? preferredSessionType,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      StudyRepositoryImplConst.sessionsPath,
      data: <String, dynamic>{
        'deckId': deckId,
        'preferredSessionType': preferredSessionType?.apiValue,
      },
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> resumeSession({required int sessionId}) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId',
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> submitAnswer({
    required int sessionId,
    required String answer,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/submit-answer',
      data: <String, dynamic>{'answer': answer},
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> submitMatchedPairs({
    required int sessionId,
    required List<StudyMatchSubmission> matchedPairs,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/submit-answer',
      data: <String, dynamic>{
        'answer': 'match',
        'matchedPairs': matchedPairs
            .map((StudyMatchSubmission pair) => pair.toJson())
            .toList(growable: false),
      },
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> revealAnswer({required int sessionId}) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/reveal-answer',
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> markRemembered({required int sessionId}) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/mark-remembered',
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> retryItem({required int sessionId}) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/retry-item',
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> goNext({required int sessionId}) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/next',
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<StudySessionData> resetCurrentMode({required int sessionId}) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.sessionsPath}/$sessionId/reset-current-mode',
    );
    return StudySessionData.fromJson(_castMap(response.data));
  }

  @override
  Future<void> resetDeckProgress({required int deckId}) async {
    await _dio.post<dynamic>(
      '${StudyRepositoryImplConst.studyDecksPath}/$deckId/reset-progress',
    );
  }

  @override
  Future<StudyReminderSummary> getReminderSummary() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      StudyRepositoryImplConst.remindersSummaryPath,
    );
    return StudyReminderSummary.fromJson(_castMap(response.data));
  }

  @override
  Future<StudyAnalyticsOverview> getAnalyticsOverview() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      StudyRepositoryImplConst.analyticsOverviewPath,
    );
    return StudyAnalyticsOverview.fromJson(_castMap(response.data));
  }

  @override
  Future<SpeechPreference> getSpeechPreference() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      StudyRepositoryImplConst.speechPreferencePath,
    );
    return SpeechPreference.fromJson(_castMap(response.data));
  }

  @override
  Future<SpeechPreference> updateSpeechPreference({
    required SpeechPreference preference,
  }) async {
    final Response<dynamic> response = await _dio.put<dynamic>(
      StudyRepositoryImplConst.speechPreferencePath,
      data: preference.toJson(),
    );
    return SpeechPreference.fromJson(_castMap(response.data));
  }

  @override
  Future<StudyPreference> getStudyPreference() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      StudyRepositoryImplConst.studyPreferencePath,
    );
    return StudyPreference.fromJson(_castMap(response.data));
  }

  @override
  Future<StudyPreference> updateStudyPreference({
    required StudyPreference preference,
  }) async {
    final Response<dynamic> response = await _dio.put<dynamic>(
      StudyRepositoryImplConst.studyPreferencePath,
      data: preference.toJson(),
    );
    return StudyPreference.fromJson(_castMap(response.data));
  }

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }
}

@Riverpod(keepAlive: true)
StudyRepository studyRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return DioStudyRepository(dio: dio);
}
