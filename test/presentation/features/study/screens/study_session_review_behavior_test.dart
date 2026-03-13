import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/study/providers/study_speech_playback_provider.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/review/study_session_review_content.dart';
import 'package:lumos/presentation/shared/widgets/lumos_widgets.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    await tester.drag(find.text('안녕하세요'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(actions, <String>[
      StudySessionReviewContentConst.rememberedActionId,
      StudySessionReviewContentConst.nextActionId,
    ]);
  });

  testWidgets('review blocks backward swipe on the first card', (
    WidgetTester tester,
  ) async {
    final List<String> actions = <String>[];
    await _pumpReviewContent(
      tester: tester,
      locale: const Locale('vi'),
      session: sampleStudySession(
        progress: const StudyProgressSummary(
          completedItems: 0,
          totalItems: 2,
          completedModes: 0,
          totalModes: 5,
          itemProgress: 0,
          modeProgress: 0,
          sessionProgress: 0,
        ),
      ),
      onActionPressed: (String actionId) async {
        actions.add(actionId);
      },
    );

    await tester.drag(find.text('안녕하세요'), const Offset(600, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(actions, isEmpty);
    expect(find.text('Đây là thẻ đầu tiên.'), findsOneWidget);
  });
}

Future<void> _pumpReviewContent({
  required WidgetTester tester,
  required Future<void> Function(String actionId) onActionPressed,
  StudySessionData? session,
  Locale? locale,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 932);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: StudySessionReviewContent(
          session: session ?? sampleStudySession(),
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
