import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';

void main() {
  group('Study models', () {
    test('fromJson maps study session payload', () {
      final StudySessionData session = StudySessionData.fromJson(<String, dynamic>{
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
            <String, dynamic>{'id': 'choice-0', 'label': 'xin chao'},
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
      });

      expect(session.sessionId, 33);
      expect(session.currentItem.flashcardId, 101);
      expect(session.currentItem.choices.single.label, 'xin chao');
      expect(session.currentItem.speech.locale, 'ko-KR');
    });

    test('StudyReminderSummary.fromJson maps nullable recommendation', () {
      final StudyReminderSummary summary = StudyReminderSummary.fromJson(
        <String, dynamic>{
          'dueCount': 4,
          'overdueCount': 2,
          'escalationLevel': 'LEVEL_1',
          'reminderTypes': const <String>['IN_APP_BADGE_DUE_LIST'],
          'recommendation': <String, dynamic>{
            'deckId': 10,
            'deckName': 'Korean Basics',
            'dueCount': 4,
            'overdueCount': 2,
            'estimatedSessionMinutes': 1,
            'recommendedSessionType': 'REVIEW',
          },
        },
      );

      expect(summary.recommendation, isNotNull);
      expect(summary.recommendation!.deckName, 'Korean Basics');
    });

    test('StudyAnalyticsOverview.fromJson maps boxDistribution keys', () {
      final StudyAnalyticsOverview overview =
          StudyAnalyticsOverview.fromJson(<String, dynamic>{
            'totalLearnedItems': 12,
            'dueCount': 4,
            'overdueCount': 2,
            'passedAttempts': 9,
            'failedAttempts': 3,
            'boxDistribution': <String, dynamic>{'1': 3, '2': 4},
          });

      expect(overview.boxDistribution[1], 3);
      expect(overview.boxDistribution[2], 4);
    });

    test('SpeechPreference.toJson and copyWith preserve fields', () {
      const SpeechPreference preference = SpeechPreference(
        enabled: true,
        autoPlay: false,
        voice: 'ko-KR-neutral',
        speed: 1,
        locale: 'ko-KR',
      );

      final SpeechPreference updated = preference.copyWith(
        enabled: false,
        autoPlay: true,
        voice: 'ko-KR-female',
        speed: 1.2,
      );
      final Map<String, dynamic> json = updated.toJson();

      expect(updated.enabled, isFalse);
      expect(updated.autoPlay, isTrue);
      expect(updated.voice, 'ko-KR-female');
      expect(updated.locale, 'ko-KR');
      expect(json, <String, dynamic>{
        'enabled': false,
        'autoPlay': true,
        'voice': 'ko-KR-female',
        'speed': 1.2,
      });
    });
  });
}
