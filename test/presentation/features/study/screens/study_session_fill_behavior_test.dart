import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';
import 'package:lumos/domain/repositories/study/study_repository.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/study/screens/study_session_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'fill retry flow keeps help visible and auto-advances after a correct retry',
    (WidgetTester tester) async {
      final _SequencedFillStudyRepository repository =
          _SequencedFillStudyRepository();
      await _pumpFillScreen(tester: tester, repository: repository);

      expect(find.text('xin chao'), findsOneWidget);

      await tester.tap(find.text('Trợ giúp'));
      await tester.pumpAndSettle();

      expect(find.text('Nhập lại'), findsOneWidget);
      expect(find.text('Trợ giúp'), findsOneWidget);

      await tester.tap(find.text('Nhập lại'));
      await tester.pumpAndSettle();

      expect(find.text('Kiểm tra'), findsOneWidget);
      expect(find.text('Trợ giúp'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), '안녕하세요');
      await tester.tap(find.text('Kiểm tra'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(repository.lastAnswer, '안녕하세요');
      expect(repository.goNextCallCount, 1);
      expect(find.text('cam on'), findsOneWidget);
    },
  );
}

Future<void> _pumpFillScreen({
  required WidgetTester tester,
  required StudyRepository repository,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 932);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const StudySessionScreen(deckId: 10, deckName: 'Korean Basics'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _SequencedFillStudyRepository implements StudyRepository {
  StudySessionData _session = _buildFillSession(
    flashcardId: 101,
    prompt: '안녕하세요',
    answer: 'xin chao',
    modeState: 'IN_PROGRESS',
    allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
  );

  String? lastAnswer;
  int goNextCallCount = 0;

  @override
  Future<StudySessionData> startSession({
    required int deckId,
    StudySessionTypeOption? preferredSessionType,
  }) async {
    return _session;
  }

  @override
  Future<StudySessionData> resumeSession({required int sessionId}) async {
    return _session;
  }

  @override
  Future<StudySessionData> submitAnswer({
    required int sessionId,
    required String answer,
  }) async {
    lastAnswer = answer;
    _session = _buildFillSession(
      flashcardId: 101,
      prompt: '안녕하세요',
      answer: 'xin chao',
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['GO_NEXT'],
    );
    return _session;
  }

  @override
  Future<StudySessionData> submitMatchedPairs({
    required int sessionId,
    required List<StudyMatchSubmission> matchedPairs,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<StudySessionData> revealAnswer({required int sessionId}) async {
    _session = _buildFillSession(
      flashcardId: 101,
      prompt: '안녕하세요',
      answer: 'xin chao',
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
    );
    return _session;
  }

  @override
  Future<StudySessionData> markRemembered({required int sessionId}) async {
    throw UnimplementedError();
  }

  @override
  Future<StudySessionData> retryItem({required int sessionId}) async {
    throw UnimplementedError();
  }

  @override
  Future<StudySessionData> goNext({required int sessionId}) async {
    goNextCallCount += 1;
    _session = _buildFillSession(
      flashcardId: 102,
      prompt: '감사합니다',
      answer: 'cam on',
      modeState: 'IN_PROGRESS',
      allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
    );
    return _session;
  }

  @override
  Future<StudySessionData> resetCurrentMode({required int sessionId}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> resetDeckProgress({required int deckId}) async {}

  @override
  Future<StudyReminderSummary> getReminderSummary() async {
    throw UnimplementedError();
  }

  @override
  Future<StudyAnalyticsOverview> getAnalyticsOverview() async {
    throw UnimplementedError();
  }
}

StudySessionData _buildFillSession({
  required int flashcardId,
  required String prompt,
  required String answer,
  required String modeState,
  required List<String> allowedActions,
}) {
  return StudySessionData(
    sessionId: 33,
    deckId: 10,
    deckName: 'Korean Basics',
    sessionType: 'FIRST_LEARNING',
    activeMode: 'FILL',
    modeState: modeState,
    modePlan: const <String>['REVIEW', 'MATCH', 'GUESS', 'RECALL', 'FILL'],
    allowedActions: allowedActions,
    progress: const StudyProgressSummary(
      completedItems: 1,
      totalItems: 3,
      completedModes: 0,
      totalModes: 5,
      itemProgress: 0.33,
      modeProgress: 0,
      sessionProgress: 0.06,
    ),
    currentItem: StudySessionItemData(
      flashcardId: flashcardId,
      prompt: prompt,
      answer: answer,
      note: 'note',
      pronunciation: 'pronunciation',
      instruction: 'Type the answer, or ask for help before checking.',
      inputPlaceholder: '',
      choices: const <StudyChoice>[],
      matchPairs: const <StudyMatchPair>[],
      speech: SpeechCapability(
        enabled: true,
        autoPlay: false,
        available: true,
        adapter: studySpeechAdapterFlutterTts,
        locale: 'ko-KR',
        voice: 'ko-KR-neutral',
        speed: 1,
        pitch: 1,
        fieldName: 'prompt',
        sourceType: 'text',
        audioUrl: '',
        allowedActions: const <String>['play_speech', 'replay_speech'],
        speechText: prompt,
      ),
    ),
    sessionCompleted: false,
  );
}
