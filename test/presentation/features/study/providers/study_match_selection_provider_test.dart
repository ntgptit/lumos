import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/providers/study_match_selection_provider.dart';

void main() {
  group('StudyMatchSelectionController', () {
    testWidgets(
      'wrong pair shows error feedback briefly before clearing',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyMatchSelectionController controller = container.read(
          studyMatchSelectionControllerProvider(33).notifier,
        );
        controller.syncPairs(_extendedPairs);
        controller.selectLeft('left-faith');
        controller.selectRight('right-researcher');

        StudyMatchSelectionState state = container.read(
          studyMatchSelectionControllerProvider(33),
        );
        expect(state.matchedPairs, isEmpty);
        expect(state.selectedLeftId, 'left-faith');
        expect(state.selectedRightId, 'right-researcher');
        expect(state.isFeedbackError, isTrue);
        expect(state.hasActiveFeedback, isTrue);

        await tester.pump(const Duration(milliseconds: 700));

        state = container.read(studyMatchSelectionControllerProvider(33));
        expect(state.matchedPairs, isEmpty);
        expect(state.selectedLeftId, isNull);
        expect(state.selectedRightId, isNull);
        expect(state.hasActiveFeedback, isFalse);
      },
    );
 
    testWidgets(
      'correct pair shows success feedback then disappears before commit',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyMatchSelectionController controller = container.read(
          studyMatchSelectionControllerProvider(33).notifier,
        );
        controller.syncPairs(_pairs);

        controller.selectLeft('left-faith');
        controller.selectRight('right-faith');

        StudyMatchSelectionState state = container.read(
          studyMatchSelectionControllerProvider(33),
        );
        expect(state.isFeedbackSuccess, isTrue);
        expect(state.matchedPairs, isEmpty);
        expect(state.canSubmit, isFalse);

        await tester.pump(const Duration(milliseconds: 600));

        state = container.read(studyMatchSelectionControllerProvider(33));
        expect(state.isFeedbackSuccess, isTrue);
        expect(state.isFeedbackDisappearing, isTrue);
        expect(state.matchedPairs, isEmpty);

        await tester.pump(const Duration(milliseconds: 200));

        state = container.read(studyMatchSelectionControllerProvider(33));
        expect(state.matchedPairs, hasLength(1));
        expect(state.matchedPairs[0].leftId, 'left-faith');
        expect(state.matchedPairs[0].rightId, 'right-faith');
        expect(state.hasActiveFeedback, isFalse);
      },
    );

    testWidgets(
      'correct pair is matched and can complete mode after feedback ends',
      (WidgetTester tester) async {
        final ProviderContainer container = ProviderContainer();
        addTearDown(container.dispose);
        final StudyMatchSelectionController controller = container.read(
          studyMatchSelectionControllerProvider(33).notifier,
        );
        controller.syncPairs(_pairs);

        controller.selectLeft('left-faith');
        controller.selectRight('right-faith');
        await tester.pump(const Duration(milliseconds: 800));
        controller.selectLeft('left-night');
        controller.selectRight('right-night');
        await tester.pump(const Duration(milliseconds: 800));

        final StudyMatchSelectionState state = container.read(
          studyMatchSelectionControllerProvider(33),
        );
        expect(state.matchedPairs, hasLength(2));
        expect(state.matchedPairs[0].leftId, 'left-faith');
        expect(state.matchedPairs[0].rightId, 'right-faith');
        expect(state.matchedPairs[1].leftId, 'left-night');
        expect(state.matchedPairs[1].rightId, 'right-night');
        expect(state.canSubmit, isTrue);
      },
    );
  });
}

const List<StudyMatchPair> _pairs = <StudyMatchPair>[
  StudyMatchPair(
    leftId: 'left-faith',
    leftLabel: 'Faith',
    rightId: 'right-faith',
    rightLabel: '신뢰',
  ),
  StudyMatchPair(
    leftId: 'left-night',
    leftLabel: 'Night',
    rightId: 'right-night',
    rightLabel: '야간',
  ),
];

const List<StudyMatchPair> _extendedPairs = <StudyMatchPair>[
  ..._pairs,
  StudyMatchPair(
    leftId: 'left-researcher',
    leftLabel: 'Researcher',
    rightId: 'right-researcher',
    rightLabel: '연구자',
  ),
];
