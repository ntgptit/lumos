import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/presentation/features/study/providers/study_guess_selection_provider.dart';

void main() {
  group('StudyGuessSelectionController', () {
    testWidgets(
      'wrong choice shows error feedback then clears without queuing submit',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyGuessSelectionController controller = container.read(
          studyGuessSelectionControllerProvider(33).notifier,
        );
        controller.syncCurrentItem(itemKey: 'GUESS:101');

        controller.selectChoice(choiceLabel: 'cam on', isCorrect: false);

        StudyGuessSelectionState state = container.read(
          studyGuessSelectionControllerProvider(33),
        );
        expect(state.isErrorFeedbackFor('cam on'), isTrue);
        expect(state.canSubmit, isFalse);
        expect(state.isInteractionLocked, isTrue);

        await tester.pump(studyGuessErrorFeedbackDuration);

        state = container.read(studyGuessSelectionControllerProvider(33));
        expect(state.selectedChoiceLabel, isNull);
        expect(state.isFeedbackError, isFalse);
        expect(state.canSubmit, isFalse);
        expect(state.isInteractionLocked, isFalse);
      },
    );

    testWidgets(
      'correct choice queues one pending submit after success feedback',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyGuessSelectionController controller = container.read(
          studyGuessSelectionControllerProvider(33).notifier,
        );
        controller.syncCurrentItem(itemKey: 'GUESS:101');

        controller.selectChoice(choiceLabel: 'xin chao', isCorrect: true);

        StudyGuessSelectionState state = container.read(
          studyGuessSelectionControllerProvider(33),
        );
        expect(state.isSuccessFeedbackFor('xin chao'), isTrue);
        expect(state.canSubmit, isFalse);

        await tester.pump(studyGuessSuccessFeedbackDuration);

        state = container.read(studyGuessSelectionControllerProvider(33));
        expect(state.isSuccessFeedbackFor('xin chao'), isTrue);
        expect(state.pendingSubmittedAnswer, 'xin chao');
        expect(state.canSubmit, isTrue);
        expect(state.isInteractionLocked, isTrue);
      },
    );

    testWidgets('syncCurrentItem resets stale feedback when the item changes', (
      WidgetTester tester,
    ) async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyGuessSelectionController controller = container.read(
        studyGuessSelectionControllerProvider(33).notifier,
      );
      controller.syncCurrentItem(itemKey: 'GUESS:101');
      controller.selectChoice(choiceLabel: 'xin chao', isCorrect: true);

      await tester.pump(studyGuessSuccessFeedbackDuration);
      controller.syncCurrentItem(itemKey: 'GUESS:102');

      final StudyGuessSelectionState state = container.read(
        studyGuessSelectionControllerProvider(33),
      );
      expect(state.currentItemKey, 'GUESS:102');
      expect(state.selectedChoiceLabel, isNull);
      expect(state.pendingSubmittedAnswer, isNull);
      expect(state.hasActiveFeedback, isFalse);
    });
  });
}
