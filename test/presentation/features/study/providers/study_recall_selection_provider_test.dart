import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/presentation/features/study/providers/study_recall_selection_provider.dart';

void main() {
  group('StudyRecallSelectionController', () {
    testWidgets('reveal countdown queues auto reveal after 15 seconds', (
      WidgetTester tester,
    ) async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyRecallSelectionController controller = container.read(
        studyRecallSelectionControllerProvider(44).notifier,
      );
      controller.syncCurrentItem(
        itemKey: 'RECALL:101',
        shouldStartRevealCountdown: true,
      );

      StudyRecallSelectionState state = container.read(
        studyRecallSelectionControllerProvider(44),
      );
      expect(state.revealCountdownSeconds, studyRecallRevealCountdownSeconds);
      expect(state.isRevealCountdownActive, isTrue);
      expect(state.hasPendingReveal, isFalse);
      expect(state.showsNextActionOnly, isFalse);

      await tester.pump(const Duration(seconds: 1));

      state = container.read(studyRecallSelectionControllerProvider(44));
      expect(
        state.revealCountdownSeconds,
        studyRecallRevealCountdownSeconds - 1,
      );

      await tester.pump(
        const Duration(seconds: studyRecallRevealCountdownSeconds - 1),
      );

      state = container.read(studyRecallSelectionControllerProvider(44));
      expect(state.hasPendingReveal, isTrue);
      expect(
        state.selectedActionId,
        StudyRecallSelectionController.revealActionId,
      );
      expect(state.isRevealCountdownActive, isFalse);
      expect(state.showsNextActionOnly, isTrue);
    });

    testWidgets(
      'remembered feedback queues a pending submit after success delay',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyRecallSelectionController controller = container.read(
          studyRecallSelectionControllerProvider(44).notifier,
        );
        controller.syncCurrentItem(
          itemKey: 'RECALL:101',
          shouldStartRevealCountdown: false,
        );

        controller.selectAction(
          actionId: StudyRecallSelectionController.rememberedActionId,
        );

        StudyRecallSelectionState state = container.read(
          studyRecallSelectionControllerProvider(44),
        );
        expect(state.isSelected(StudyRecallSelectionController.rememberedActionId), isTrue);
        expect(state.isRememberedFeedback, isTrue);
        expect(state.canSubmit, isFalse);

        await tester.pump(studyRecallRememberedFeedbackDuration);

        state = container.read(studyRecallSelectionControllerProvider(44));
        expect(
          state.pendingSubmittedActionId,
          StudyRecallSelectionController.rememberedActionId,
        );
        expect(state.canSubmit, isTrue);
        expect(state.isInteractionLocked, isTrue);
      },
    );

    testWidgets(
      'retry feedback queues a pending submit after retry delay',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyRecallSelectionController controller = container.read(
          studyRecallSelectionControllerProvider(44).notifier,
        );
        controller.syncCurrentItem(
          itemKey: 'RECALL:101',
          shouldStartRevealCountdown: false,
        );

        controller.selectAction(
          actionId: StudyRecallSelectionController.retryActionId,
        );

        StudyRecallSelectionState state = container.read(
          studyRecallSelectionControllerProvider(44),
        );
        expect(state.isSelected(StudyRecallSelectionController.retryActionId), isTrue);
        expect(state.isRetryFeedback, isTrue);
        expect(state.canSubmit, isFalse);

        await tester.pump(studyRecallRetryFeedbackDuration);

        state = container.read(studyRecallSelectionControllerProvider(44));
        expect(
          state.pendingSubmittedActionId,
          StudyRecallSelectionController.retryActionId,
        );
        expect(state.canSubmit, isTrue);
      },
    );

    testWidgets('syncCurrentItem clears stale recall feedback state', (
      WidgetTester tester,
    ) async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
        final StudyRecallSelectionController controller = container.read(
          studyRecallSelectionControllerProvider(44).notifier,
        );
      controller.syncCurrentItem(
        itemKey: 'RECALL:101',
        shouldStartRevealCountdown: false,
      );
      controller.selectAction(
        actionId: StudyRecallSelectionController.rememberedActionId,
      );

      await tester.pump(studyRecallRememberedFeedbackDuration);
      controller.syncCurrentItem(
        itemKey: 'RECALL:102',
        shouldStartRevealCountdown: false,
      );

      final StudyRecallSelectionState state = container.read(
        studyRecallSelectionControllerProvider(44),
      );
      expect(state.currentItemKey, 'RECALL:102');
      expect(state.selectedActionId, isNull);
      expect(state.pendingSubmittedActionId, isNull);
      expect(state.hasActiveFeedback, isFalse);
    });

    testWidgets(
      'manual reveal keeps timeout next-only flag turned off',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyRecallSelectionController controller = container.read(
          studyRecallSelectionControllerProvider(44).notifier,
        );
        controller.syncCurrentItem(
          itemKey: 'RECALL:101',
          shouldStartRevealCountdown: true,
        );

        await tester.pump(const Duration(seconds: 1));
        controller.queueManualReveal();
        controller.syncCurrentItem(
          itemKey: 'RECALL:101',
          shouldStartRevealCountdown: false,
        );

        final StudyRecallSelectionState state = container.read(
          studyRecallSelectionControllerProvider(44),
        );
        expect(state.showsNextActionOnly, isFalse);
        expect(state.hasPendingReveal, isFalse);
      },
    );
  });
}
