import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/mode/fill_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_view_model.dart';
import 'package:lumos/presentation/features/study/providers/study_speech_playback_provider.dart';
import 'package:lumos/presentation/features/study/screens/widgets/blocks/study_session_screen_app_bar.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/study_session_fill_content.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_action_row.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_body_panel.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_progress_row.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_prompt_card.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fill mode app bar uses mode chrome', (
    WidgetTester tester,
  ) async {
    final StudySessionData session = sampleStudySession(
      activeMode: 'FILL',
      allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
    );
    final StudyModeViewModel viewModel = const FillStudyModeViewStrategy()
        .buildViewModel(session: session);

    await tester.pumpWidget(
      MaterialApp(
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

  testWidgets('fill content keeps progress prompt input and bottom actions order', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 932);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final StudySessionData session = sampleStudySession(
      activeMode: 'FILL',
      allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
    );
    final StudyModeViewModel viewModel = const FillStudyModeViewStrategy()
        .buildViewModel(session: session);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudySessionFillContent(
            session: session,
            viewModel: viewModel,
            answerController: controller,
            speechPlaybackState: const StudySpeechPlaybackState.initial(),
            onSubmitTypedAnswer: () {},
            onActionPressed: (_) async {},
            onPlaySpeech: () {},
            onReplaySpeech: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trợ giúp'), findsOneWidget);
    expect(find.text('Kiểm tra'), findsOneWidget);

    final double progressTop = tester.getTopLeft(
      find.byType(StudySessionFillProgressRow),
    ).dy;
    final double promptTop = tester.getTopLeft(
      find.byType(StudySessionFillPromptCard),
    ).dy;
    final double bodyTop = tester.getTopLeft(
      find.byType(StudySessionFillBodyPanel),
    ).dy;
    final double actionTop = tester.getTopLeft(
      find.byType(StudySessionFillActionRow),
    ).dy;

    expect(progressTop, lessThan(promptTop));
    expect(promptTop, lessThan(bodyTop));
    expect(bodyTop, lessThan(actionTop));
  });
}
