import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_action_view_model.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_view_model.dart';
import 'package:lumos/presentation/features/study/providers/study_session_provider.dart';
import 'package:lumos/presentation/features/study/providers/study_speech_playback_provider.dart';
import 'package:lumos/presentation/features/study/screens/study_session_screen.dart';
import 'package:lumos/presentation/features/study/screens/widgets/blocks/study_session_review_content.dart';
import 'package:lumos/presentation/shared/widgets/lumos_widgets.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'study session keeps current review card visible while action loads',
    (WidgetTester tester) async {
      final FakeStudyRepository repository = FakeStudyRepository(
        actionDelay: const Duration(milliseconds: 50),
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await _pumpStudySessionScreen(tester: tester, container: container);

      expect(find.text('안녕하세요 / note'), findsOneWidget);

      final StudySessionControllerProvider provider =
          studySessionControllerProvider(
            const StudySessionLaunchRequest(deckId: 10),
          );
      final Future<void> operation = container
          .read(provider.notifier)
          .markRemembered();

      await tester.pump();

      expect(find.byType(LumosLoadingIndicator), findsNothing);
      expect(find.text('안녕하세요 / note'), findsOneWidget);

      await operation;
      await tester.pumpAndSettle();
    },
  );

  testWidgets('review swipe is limited to the card viewport', (
    WidgetTester tester,
  ) async {
    final List<String> actions = <String>[];
    await _pumpReviewContent(
      tester: tester,
      onActionPressed: (String actionId) async {
        actions.add(actionId);
      },
    );

    await tester.drag(find.byType(LumosProgressBar), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(actions, isEmpty);

    await tester.drag(find.text('xin chao'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(actions, <String>[
      StudySessionReviewContentConst.rememberedActionId,
      StudySessionReviewContentConst.nextActionId,
    ]);
  });
}

Future<void> _pumpStudySessionScreen({
  required WidgetTester tester,
  required ProviderContainer container,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 932);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const StudySessionScreen(deckId: 10, deckName: 'Korean Basics'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpReviewContent({
  required WidgetTester tester,
  required Future<void> Function(String actionId) onActionPressed,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 932);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: StudySessionReviewContent(
          session: sampleStudySession(),
          viewModel: _reviewViewModel(),
          speechPlaybackState: const StudySpeechPlaybackState.initial(),
          onActionPressed: onActionPressed,
          onPlaySpeech: () {},
          onReplaySpeech: () {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

StudyModeViewModel _reviewViewModel() {
  return const StudyModeViewModel(
    modeLabel: 'Review',
    instruction: '',
    prompt: '',
    answer: '',
    showAnswer: true,
    showAnswerInput: false,
    inputLabel: '',
    submitLabel: '',
    useChoiceGrid: false,
    choices: <StudyChoice>[],
    matchPairs: <StudyMatchPair>[],
    actions: <StudyModeActionViewModel>[],
  );
}
