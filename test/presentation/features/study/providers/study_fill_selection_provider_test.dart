import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/presentation/features/study/providers/study_fill_selection_provider.dart';

void main() {
  group('StudyFillSelectionController', () {
    test('correct answer is marked correct without mismatch highlight', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyFillSelectionController controller = container.read(
        studyFillSelectionControllerProvider(33).notifier,
      );
      controller.syncCurrentItem(itemKey: 'FILL:101');

      final bool isCorrect = controller.evaluateSubmission(
        submittedAnswer: '안녕하세요',
        expectedAnswer: '안녕하세요',
      );

      final StudyFillSelectionState state = container.read(
        studyFillSelectionControllerProvider(33),
      );
      expect(isCorrect, isTrue);
      expect(state.isCorrectSubmission, isTrue);
      expect(state.mismatchStartIndex, isNull);
      expect(state.submittedAnswer, '안녕하세요');
      expect(state.hasIncorrectSubmission, isFalse);
      expect(state.showsRequiredInputError, isFalse);
    });

    test('wrong answer stores mismatch index from first wrong character', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyFillSelectionController controller = container.read(
        studyFillSelectionControllerProvider(33).notifier,
      );
      controller.syncCurrentItem(itemKey: 'FILL:101');

      final bool isCorrect = controller.evaluateSubmission(
        submittedAnswer: '안녕히',
        expectedAnswer: '안녕하세요',
      );

      final StudyFillSelectionState state = container.read(
        studyFillSelectionControllerProvider(33),
      );
      expect(isCorrect, isFalse);
      expect(state.isCorrectSubmission, isFalse);
      expect(state.mismatchStartIndex, 2);
      expect(state.hasIncorrectSubmission, isTrue);
      expect(state.showsRequiredInputError, isFalse);
    });

    test('syncCurrentItem clears stale fill result when item changes', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyFillSelectionController controller = container.read(
        studyFillSelectionControllerProvider(33).notifier,
      );
      controller.syncCurrentItem(itemKey: 'FILL:101');
      controller.evaluateSubmission(
        submittedAnswer: '안녕히',
        expectedAnswer: '안녕하세요',
      );

      controller.syncCurrentItem(itemKey: 'FILL:102');

      final StudyFillSelectionState state = container.read(
        studyFillSelectionControllerProvider(33),
      );
      expect(state.currentItemKey, 'FILL:102');
      expect(state.submittedAnswer, isNull);
      expect(state.mismatchStartIndex, isNull);
      expect(state.hasSubmittedAnswer, isFalse);
      expect(state.showsRequiredInputError, isFalse);
    });

    test(
      'reveal marks the fill item as incorrect even when input is empty',
      () {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyFillSelectionController controller = container.read(
          studyFillSelectionControllerProvider(33).notifier,
        );
        controller.syncCurrentItem(itemKey: 'FILL:101');

        controller.markRevealAsIncorrect(
          submittedAnswer: '',
          expectedAnswer: '안녕하세요',
        );

        final StudyFillSelectionState state = container.read(
          studyFillSelectionControllerProvider(33),
        );
        expect(state.isCorrectSubmission, isFalse);
        expect(state.mismatchStartIndex, 0);
        expect(state.hasIncorrectSubmission, isTrue);
        expect(state.showsRequiredInputError, isFalse);
      },
    );

    test('startRetryInput clears comparison state and opens input again', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyFillSelectionController controller = container.read(
        studyFillSelectionControllerProvider(33).notifier,
      );
      controller.syncCurrentItem(itemKey: 'FILL:101');
      controller.evaluateSubmission(
        submittedAnswer: '안녕히',
        expectedAnswer: '안녕하세요',
      );

      controller.startRetryInput();

      final StudyFillSelectionState state = container.read(
        studyFillSelectionControllerProvider(33),
      );
      expect(state.submittedAnswer, isNull);
      expect(state.mismatchStartIndex, isNull);
      expect(state.isCorrectSubmission, isFalse);
      expect(state.showsRetryInput, isTrue);
      expect(state.showsRequiredInputError, isFalse);
    });

    test('required input error can be shown and cleared locally', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyFillSelectionController controller = container.read(
        studyFillSelectionControllerProvider(33).notifier,
      );
      controller.syncCurrentItem(itemKey: 'FILL:101');

      controller.showRequiredInputError();
      expect(
        container
            .read(studyFillSelectionControllerProvider(33))
            .showsRequiredInputError,
        isTrue,
      );

      controller.clearRequiredInputError();
      expect(
        container
            .read(studyFillSelectionControllerProvider(33))
            .showsRequiredInputError,
        isFalse,
      );
    });
  });
}
