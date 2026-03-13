import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/study/study_models.dart';

part 'study_match_selection_provider.g.dart';

@immutable
class StudyMatchSelectionState {
  const StudyMatchSelectionState({
    required this.matchedPairs,
    required this.selectedLeftId,
    required this.selectedRightId,
    required this.totalPairs,
    required this.correctPairByLeftId,
  });

  const StudyMatchSelectionState.initial()
    : matchedPairs = const <StudyMatchSubmission>[],
      selectedLeftId = null,
      selectedRightId = null,
      totalPairs = 0,
      correctPairByLeftId = const <String, String>{};

  final List<StudyMatchSubmission> matchedPairs;
  final String? selectedLeftId;
  final String? selectedRightId;
  final int totalPairs;
  final Map<String, String> correctPairByLeftId;

  bool get canSubmit {
    return totalPairs > 0 && matchedPairs.length == totalPairs;
  }

  StudyMatchSelectionState copyWith({
    List<StudyMatchSubmission>? matchedPairs,
    Object? selectedLeftId = _unsetMatchValue,
    Object? selectedRightId = _unsetMatchValue,
    int? totalPairs,
    Map<String, String>? correctPairByLeftId,
  }) {
    return StudyMatchSelectionState(
      matchedPairs: matchedPairs ?? this.matchedPairs,
      selectedLeftId: identical(selectedLeftId, _unsetMatchValue)
          ? this.selectedLeftId
          : selectedLeftId as String?,
      selectedRightId: identical(selectedRightId, _unsetMatchValue)
          ? this.selectedRightId
          : selectedRightId as String?,
      totalPairs: totalPairs ?? this.totalPairs,
      correctPairByLeftId: correctPairByLeftId ?? this.correctPairByLeftId,
    );
  }
}

const Object _unsetMatchValue = Object();

@Riverpod(keepAlive: true)
class StudyMatchSelectionController extends _$StudyMatchSelectionController {
  @override
  StudyMatchSelectionState build(int sessionId) {
    return const StudyMatchSelectionState.initial();
  }

  void syncPairs(List<StudyMatchPair> pairs) {
    final Map<String, String> correctPairByLeftId = <String, String>{
      for (final StudyMatchPair pair in pairs) pair.leftId: pair.rightId,
    };
    final Set<String> leftIds = pairs
        .map((StudyMatchPair pair) => pair.leftId)
        .toSet();
    final Set<String> rightIds = pairs
        .map((StudyMatchPair pair) => pair.rightId)
        .toSet();
    final List<StudyMatchSubmission> nextMatchedPairs = state.matchedPairs
        .where(
          (StudyMatchSubmission pair) =>
              leftIds.contains(pair.leftId) &&
              rightIds.contains(pair.rightId) &&
              correctPairByLeftId[pair.leftId] == pair.rightId,
        )
        .toList(growable: false);
    state = state.copyWith(
      matchedPairs: nextMatchedPairs,
      selectedLeftId: leftIds.contains(state.selectedLeftId)
          ? state.selectedLeftId
          : null,
      selectedRightId: rightIds.contains(state.selectedRightId)
          ? state.selectedRightId
          : null,
      totalPairs: pairs.length,
      correctPairByLeftId: correctPairByLeftId,
    );
  }

  void selectLeft(String leftId) {
    if (_isLeftMatched(leftId)) {
      return;
    }
    final String? nextLeftId = state.selectedLeftId == leftId ? null : leftId;
    state = state.copyWith(selectedLeftId: nextLeftId);
    _tryMatch();
  }

  void selectRight(String rightId) {
    if (_isRightMatched(rightId)) {
      return;
    }
    final String? nextRightId = state.selectedRightId == rightId
        ? null
        : rightId;
    state = state.copyWith(selectedRightId: nextRightId);
    _tryMatch();
  }

  void reset() {
    state = const StudyMatchSelectionState.initial();
  }

  bool isLeftMatched(String leftId) {
    return _isLeftMatched(leftId);
  }

  bool isRightMatched(String rightId) {
    return _isRightMatched(rightId);
  }

  void _tryMatch() {
    final String? selectedLeftId = state.selectedLeftId;
    final String? selectedRightId = state.selectedRightId;
    if ((selectedLeftId ?? '').isEmpty || (selectedRightId ?? '').isEmpty) {
      return;
    }
    if (!_isCorrectPair(selectedLeftId!, selectedRightId!)) {
      state = state.copyWith(selectedLeftId: null, selectedRightId: null);
      return;
    }
    final List<StudyMatchSubmission> nextMatchedPairs = <StudyMatchSubmission>[
      ...state.matchedPairs,
      StudyMatchSubmission(leftId: selectedLeftId, rightId: selectedRightId),
    ];
    state = state.copyWith(
      matchedPairs: nextMatchedPairs,
      selectedLeftId: null,
      selectedRightId: null,
    );
  }

  bool _isLeftMatched(String leftId) {
    return state.matchedPairs.any(
      (StudyMatchSubmission pair) => pair.leftId == leftId,
    );
  }

  bool _isRightMatched(String rightId) {
    return state.matchedPairs.any(
      (StudyMatchSubmission pair) => pair.rightId == rightId,
    );
  }

  bool _isCorrectPair(String leftId, String rightId) {
    return state.correctPairByLeftId[leftId] == rightId;
  }
}
