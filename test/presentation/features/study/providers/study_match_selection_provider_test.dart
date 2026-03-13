import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/providers/study_match_selection_provider.dart';

void main() {
  group('StudyMatchSelectionController', () {
    test('only correct pairs are marked as matched', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyMatchSelectionController controller = container.read(
        studyMatchSelectionControllerProvider(33).notifier,
      );
      controller.syncPairs(_pairs);
      controller.selectLeft('left-faith');
      controller.selectRight('right-researcher');

      final StudyMatchSelectionState state = container.read(
        studyMatchSelectionControllerProvider(33),
      );
      expect(state.matchedPairs, isEmpty);
      expect(state.selectedLeftId, isNull);
      expect(state.selectedRightId, isNull);
    });

    test('correct pair is matched and can complete mode', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);
      final StudyMatchSelectionController controller = container.read(
        studyMatchSelectionControllerProvider(33).notifier,
      );
      controller.syncPairs(_pairs);

      controller.selectLeft('left-faith');
      controller.selectRight('right-faith');
      controller.selectLeft('left-night');
      controller.selectRight('right-night');

      final StudyMatchSelectionState state = container.read(
        studyMatchSelectionControllerProvider(33),
      );
      expect(state.matchedPairs, hasLength(2));
      expect(state.matchedPairs[0].leftId, 'left-faith');
      expect(state.matchedPairs[0].rightId, 'right-faith');
      expect(state.matchedPairs[1].leftId, 'left-night');
      expect(state.matchedPairs[1].rightId, 'right-night');
      expect(state.canSubmit, isTrue);
    });
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
