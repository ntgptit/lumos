import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/study/mode/fill_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_view_model.dart';
import 'package:lumos/presentation/features/study/providers/study_fill_selection_provider.dart';
import 'package:lumos/presentation/features/study/providers/study_speech_playback_provider.dart';
import 'package:lumos/presentation/features/study/screens/widgets/blocks/study_session_screen_app_bar.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/study_session_fill_content.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_action_row.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_body_panel.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_input_panel.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_prompt_card.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_progress_row.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fill mode app bar uses mode chrome', (
    WidgetTester tester,
  ) async {
    final StudySessionData session = _buildFillSession();
    final StudyModeViewModel viewModel = const FillStudyModeViewStrategy()
        .buildViewModel(session: session);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: StudySessionScreenAppBar(
            deckName: session.deckName,
            session: session,
            viewModel: viewModel,
            onPlaySpeech: () {},
            onStudyMenuSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Điền'), findsOneWidget);
    expect(find.byIcon(Icons.text_fields_rounded), findsOneWidget);
  });

  testWidgets(
    'fill content keeps progress prompt input and bottom actions order',
    (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(430, 932);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      final StudySessionData session = _buildFillSession();
      final StudyModeViewModel viewModel = const FillStudyModeViewStrategy()
          .buildViewModel(session: session);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: StudySessionFillContent(
              session: session,
              viewModel: viewModel,
              fillSelectionState: const StudyFillSelectionState.initial(),
              answerController: controller,
              speechPlaybackState: const StudySpeechPlaybackState.initial(),
              onSubmitTypedAnswer: () {},
              onActionPressed: (_) async {},
              onInputChanged: (_) {},
              onRetryInputPressed: () {},
              onPlaySpeech: () {},
              onReplaySpeech: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trợ giúp'), findsOneWidget);
      expect(find.text('Kiểm tra'), findsOneWidget);
      expect(find.text('xin chao'), findsOneWidget);
      expect(find.text('안녕하세요'), findsNothing);

      final double progressTop = tester
          .getTopLeft(find.byType(StudySessionProgressRow))
          .dy;
      final double promptTop = tester
          .getTopLeft(find.byType(StudySessionFillPromptCard))
          .dy;
      final double bodyTop = tester
          .getTopLeft(find.byType(StudySessionFillBodyPanel))
          .dy;
      final double actionTop = tester
          .getTopLeft(find.byType(StudySessionFillActionRow))
          .dy;

      expect(progressTop, lessThan(promptTop));
      expect(promptTop, lessThan(bodyTop));
      expect(bodyTop, lessThan(actionTop));
    },
  );

  testWidgets('fill content shows retry action after an incorrect answer', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController(text: '안녕히');
    addTearDown(controller.dispose);
    final StudySessionData session = _buildFillSession(
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
    );
    final StudyModeViewModel viewModel = const FillStudyModeViewStrategy()
        .buildViewModel(session: session);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StudySessionFillContent(
            session: session,
            viewModel: viewModel,
            fillSelectionState: const StudyFillSelectionState(
              currentItemKey: 'FILL:101',
              submittedAnswer: '안녕히',
              mismatchStartIndex: 2,
              isCorrectSubmission: false,
              showsRetryInput: false,
              showsRequiredInputError: false,
            ),
            answerController: controller,
            speechPlaybackState: const StudySpeechPlaybackState.initial(),
            onSubmitTypedAnswer: () {},
            onActionPressed: (_) async {},
            onInputChanged: (_) {},
            onRetryInputPressed: () {},
            onPlaySpeech: () {},
            onReplaySpeech: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nhập lại'), findsOneWidget);
    expect(find.text('Trợ giúp'), findsOneWidget);
    expect(find.text('Kiểm tra'), findsNothing);
  });

  testWidgets('fill content returns to input state when retry starts', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final StudySessionData session = _buildFillSession(
      modeState: 'WAITING_FEEDBACK',
      allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
    );
    final StudyModeViewModel viewModel = const FillStudyModeViewStrategy()
        .buildViewModel(session: session);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StudySessionFillContent(
            session: session,
            viewModel: viewModel,
            fillSelectionState: const StudyFillSelectionState(
              currentItemKey: 'FILL:101',
              submittedAnswer: null,
              mismatchStartIndex: null,
              isCorrectSubmission: false,
              showsRetryInput: true,
              showsRequiredInputError: false,
            ),
            answerController: controller,
            speechPlaybackState: const StudySpeechPlaybackState.initial(),
            onSubmitTypedAnswer: () {},
            onActionPressed: (_) async {},
            onInputChanged: (_) {},
            onRetryInputPressed: () {},
            onPlaySpeech: () {},
            onReplaySpeech: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nhập lại'), findsNothing);
    expect(find.text('Kiểm tra'), findsOneWidget);
    expect(find.text('Trợ giúp'), findsOneWidget);
  });

  testWidgets('fill input shows centered error banner when validation fails', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StudySessionFillInputPanel(
            controller: controller,
            label: 'term',
            showsRequiredInputError: true,
            onChanged: (_) {},
            onSubmit: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Câu trả lời là bắt buộc.'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });
}

StudySessionData _buildFillSession({
  String modeState = 'IN_PROGRESS',
  List<String> allowedActions = const <String>[
    'SUBMIT_ANSWER',
    'REVEAL_ANSWER',
  ],
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
    currentItem: const StudySessionItemData(
      flashcardId: 101,
      prompt: '안녕하세요',
      answer: 'xin chao',
      note: 'note',
      pronunciation: 'annyeonghaseyo',
      instruction: 'Study instruction',
      inputPlaceholder: '',
      choices: <StudyChoice>[],
      matchPairs: <StudyMatchPair>[],
      speech: SpeechCapability(
        enabled: true,
        autoPlay: false,
        available: true,
        locale: 'ko-KR',
        voice: 'ko-KR-neutral',
        speed: 1,
        fieldName: 'prompt',
        sourceType: 'text',
        audioUrl: '',
        allowedActions: <String>['play_speech', 'replay_speech'],
        speechText: '안녕하세요',
      ),
    ),
    sessionCompleted: false,
  );
}
