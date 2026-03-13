import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';

void main() {
  group('DioStudyRepository', () {
    test('calls study endpoints and maps payloads', () async {
      final Dio dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
                if (options.path ==
                    StudyRepositoryImplConst.remindersSummaryPath) {
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: options,
                      data: <String, dynamic>{
                        'dueCount': 4,
                        'overdueCount': 2,
                        'escalationLevel': 'LEVEL_1',
                        'reminderTypes': const <String>[
                          'IN_APP_BADGE_DUE_LIST',
                        ],
                        'recommendation': <String, dynamic>{
                          'deckId': 10,
                          'deckName': 'Korean Basics',
                          'dueCount': 4,
                          'overdueCount': 2,
                          'estimatedSessionMinutes': 1,
                          'recommendedSessionType': 'REVIEW',
                        },
                      },
                    ),
                  );
                  return;
                }
                if (options.path ==
                    StudyRepositoryImplConst.analyticsOverviewPath) {
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: options,
                      data: <String, dynamic>{
                        'totalLearnedItems': 12,
                        'dueCount': 4,
                        'overdueCount': 2,
                        'passedAttempts': 9,
                        'failedAttempts': 3,
                        'boxDistribution': <String, dynamic>{'1': 3, '2': 4},
                      },
                    ),
                  );
                  return;
                }
                if (options.path ==
                    StudyRepositoryImplConst.speechPreferencePath) {
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: options,
                      data: <String, dynamic>{
                        'enabled': true,
                        'autoPlay': false,
                        'voice': 'ko-KR-neutral',
                        'speed': 1.0,
                        'locale': 'ko-KR',
                      },
                    ),
                  );
                  return;
                }
                handler.resolve(
                  Response<dynamic>(
                    requestOptions: options,
                    data: <String, dynamic>{
                      'sessionId': 33,
                      'deckId': 10,
                      'deckName': 'Korean Basics',
                      'sessionType': 'FIRST_LEARNING',
                      'activeMode': 'REVIEW',
                      'modeState': 'IN_PROGRESS',
                      'modePlan': const <String>['REVIEW', 'MATCH'],
                      'allowedActions': const <String>['REVEAL_ANSWER'],
                      'progress': <String, dynamic>{
                        'completedItems': 1,
                        'totalItems': 2,
                        'completedModes': 0,
                        'totalModes': 5,
                        'itemProgress': 0.5,
                        'modeProgress': 0.0,
                        'sessionProgress': 0.1,
                      },
                      'currentItem': <String, dynamic>{
                        'flashcardId': 101,
                        'prompt': '안녕하세요',
                        'answer': 'xin chao',
                        'note': 'note',
                        'pronunciation': 'annyeonghaseyo',
                        'instruction': 'Reveal the answer',
                        'inputPlaceholder': '',
                        'choices': <Map<String, dynamic>>[
                          <String, dynamic>{
                            'id': 'choice-0',
                            'label': 'xin chao',
                          },
                        ],
                        'speech': <String, dynamic>{
                          'enabled': true,
                          'autoPlay': false,
                          'available': true,
                          'locale': 'ko-KR',
                          'voice': 'ko-KR-neutral',
                          'speed': 1.0,
                          'speechText': '안녕하세요',
                        },
                      },
                      'sessionCompleted': false,
                    },
                  ),
                );
              },
        ),
      );
      final DioStudyRepository repository = DioStudyRepository(dio: dio);

      final StudySessionData started = await repository.startSession(
        deckId: 10,
        preferredSessionType: StudySessionTypeOption.firstLearning,
      );
      final StudySessionData resumed = await repository.resumeSession(
        sessionId: 33,
      );
      final StudySessionData submitted = await repository.submitAnswer(
        sessionId: 33,
        answer: 'xin chao',
      );
      final StudySessionData revealed = await repository.revealAnswer(
        sessionId: 33,
      );
      final StudySessionData remembered = await repository.markRemembered(
        sessionId: 33,
      );
      final StudySessionData retried = await repository.retryItem(
        sessionId: 33,
      );
      final StudySessionData next = await repository.goNext(sessionId: 33);
      await repository.resetDeckProgress(deckId: 10);
      final reminder = await repository.getReminderSummary();
      final analytics = await repository.getAnalyticsOverview();
      final SpeechPreference preference = await repository
          .getSpeechPreference();
      final SpeechPreference updated = await repository.updateSpeechPreference(
        preference: preference.copyWith(autoPlay: true),
      );

      expect(started.sessionId, 33);
      expect(resumed.deckName, 'Korean Basics');
      expect(submitted.currentItem.answer, 'xin chao');
      expect(revealed.currentItem.flashcardId, 101);
      expect(remembered.modeState, 'IN_PROGRESS');
      expect(retried.activeMode, 'REVIEW');
      expect(next.progress.completedItems, 1);
      expect(reminder.recommendation!.deckId, 10);
      expect(analytics.boxDistribution[1], 3);
      expect(preference.voice, 'ko-KR-neutral');
      expect(updated.autoPlay, isFalse);
    });
  });
}
