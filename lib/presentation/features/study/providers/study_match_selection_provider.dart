import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/study/study_models.dart';

part 'study_match_selection_provider.g.dart';

const Duration _matchSuccessFeedbackHoldDuration = Duration(milliseconds: 600);
const Duration _matchErrorFeedbackHoldDuration = Duration(milliseconds: 700);
const Duration _matchSuccessDisappearDuration = Duration(milliseconds: 500);

@immutable
class StudyMatchSelectionState {
  const StudyMatchSelectionState({
    required this.matchedPairs,
    required this.selectedLeftId,
    required this.selectedRightId,
    required this.totalPairs,
    required this.correctPairByLeftId,
    required this.feedbackLeftId,
    required this.feedbackRightId,
    required this.isFeedbackSuccess,
    required this.isFeedbackError,
    required this.isFeedbackDisappearing,
  });

  const StudyMatchSelectionState.initial()
    : matchedPairs = const <StudyMatchSubmission>[],
      selectedLeftId = null,
      selectedRightId = null,
      totalPairs = 0,
      correctPairByLeftId = const <String, String>{},
      feedbackLeftId = null,
      feedbackRightId = null,
      isFeedbackSuccess = false,
      isFeedbackError = false,
      isFeedbackDisappearing = false;

  final List<StudyMatchSubmission> matchedPairs;
  final String? selectedLeftId;
  final String? selectedRightId;
  final int totalPairs;
  final Map<String, String> correctPairByLeftId;
  final String? feedbackLeftId;
  final String? feedbackRightId;
  final bool isFeedbackSuccess;
  final bool isFeedbackError;
  final bool isFeedbackDisappearing;

  bool get hasActiveFeedback {
    return (feedbackLeftId ?? '').isNotEmpty &&
        (feedbackRightId ?? '').isNotEmpty;
  }

  bool get isInteractionLocked {
    return hasActiveFeedback;
  }

  bool get canSubmit {
    return totalPairs > 0 &&
        matchedPairs.length == totalPairs &&
        !hasActiveFeedback;
  }

  bool isSuccessFeedbackForLeft(String leftId) {
    return isFeedbackSuccess && feedbackLeftId == leftId;
  }

  bool isSuccessFeedbackForRight(String rightId) {
    return isFeedbackSuccess && feedbackRightId == rightId;
  }

  bool isErrorFeedbackForLeft(String leftId) {
    return isFeedbackError && feedbackLeftId == leftId;
  }

  bool isErrorFeedbackForRight(String rightId) {
    return isFeedbackError && feedbackRightId == rightId;
  }

  bool isLeftDisappearing(String leftId) {
    return isFeedbackDisappearing && feedbackLeftId == leftId;
  }

  bool isRightDisappearing(String rightId) {
    return isFeedbackDisappearing && feedbackRightId == rightId;
  }

  bool isLeftMatched(String leftId) {
    return matchedPairs.any(
      (StudyMatchSubmission pair) => pair.leftId == leftId,
    );
  }

  bool isRightMatched(String rightId) {
    return matchedPairs.any(
      (StudyMatchSubmission pair) => pair.rightId == rightId,
    );
  }

  StudyMatchSelectionState copyWith({
    List<StudyMatchSubmission>? matchedPairs,
    Object? selectedLeftId = _unsetMatchValue,
    Object? selectedRightId = _unsetMatchValue,
    int? totalPairs,
    Map<String, String>? correctPairByLeftId,
    Object? feedbackLeftId = _unsetMatchValue,
    Object? feedbackRightId = _unsetMatchValue,
    bool? isFeedbackSuccess,
    bool? isFeedbackError,
    bool? isFeedbackDisappearing,
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
      feedbackLeftId: identical(feedbackLeftId, _unsetMatchValue)
          ? this.feedbackLeftId
          : feedbackLeftId as String?,
      feedbackRightId: identical(feedbackRightId, _unsetMatchValue)
          ? this.feedbackRightId
          : feedbackRightId as String?,
      isFeedbackSuccess: isFeedbackSuccess ?? this.isFeedbackSuccess,
      isFeedbackError: isFeedbackError ?? this.isFeedbackError,
      isFeedbackDisappearing:
          isFeedbackDisappearing ?? this.isFeedbackDisappearing,
    );
  }
}

const Object _unsetMatchValue = Object();

@Riverpod(keepAlive: true)
class StudyMatchSelectionController extends _$StudyMatchSelectionController {
  Timer? _feedbackTimer;
  Timer? _disappearTimer;

  @override
  StudyMatchSelectionState build(int sessionId) {
    ref.onDispose(_cancelFeedbackTimers);
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
    final bool isFeedbackStillValid =
        leftIds.contains(state.feedbackLeftId) &&
        rightIds.contains(state.feedbackRightId);
    if (!isFeedbackStillValid) {
      _cancelFeedbackTimers();
    }
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
      feedbackLeftId: isFeedbackStillValid ? state.feedbackLeftId : null,
      feedbackRightId: isFeedbackStillValid ? state.feedbackRightId : null,
      isFeedbackSuccess: isFeedbackStillValid ? state.isFeedbackSuccess : false,
      isFeedbackError: isFeedbackStillValid ? state.isFeedbackError : false,
      isFeedbackDisappearing: isFeedbackStillValid
          ? state.isFeedbackDisappearing
          : false,
    );
  }

  void selectLeft(String leftId) {
    if (state.isInteractionLocked) {
      return;
    }
    if (_isLeftMatched(leftId)) {
      return;
    }
    final String? nextLeftId = state.selectedLeftId == leftId ? null : leftId;
    state = state.copyWith(selectedLeftId: nextLeftId);
    _tryMatch();
  }

  void selectRight(String rightId) {
    if (state.isInteractionLocked) {
      return;
    }
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
    _cancelFeedbackTimers();
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
      _showErrorFeedback(selectedLeftId, selectedRightId);
      return;
    }
    state = state.copyWith(
      feedbackLeftId: selectedLeftId,
      feedbackRightId: selectedRightId,
      isFeedbackSuccess: true,
      isFeedbackError: false,
      isFeedbackDisappearing: false,
    );
    _cancelFeedbackTimers();
    _feedbackTimer = Timer(
      _matchSuccessFeedbackHoldDuration,
      _startSuccessDisappear,
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

  void _showErrorFeedback(String leftId, String rightId) {
    _cancelFeedbackTimers();
    state = state.copyWith(
      feedbackLeftId: leftId,
      feedbackRightId: rightId,
      isFeedbackSuccess: false,
      isFeedbackError: true,
      isFeedbackDisappearing: false,
    );
    _feedbackTimer = Timer(
      _matchErrorFeedbackHoldDuration,
      _clearFeedbackSelection,
    );
  }

  void _startSuccessDisappear() {
    if (!state.isFeedbackSuccess || !state.hasActiveFeedback) {
      return;
    }
    state = state.copyWith(isFeedbackDisappearing: true);
    _disappearTimer = Timer(
      _matchSuccessDisappearDuration,
      _commitSuccessFeedback,
    );
  }

  void _commitSuccessFeedback() {
    final String? feedbackLeftId = state.feedbackLeftId;
    final String? feedbackRightId = state.feedbackRightId;
    if (!state.isFeedbackSuccess ||
        (feedbackLeftId ?? '').isEmpty ||
        (feedbackRightId ?? '').isEmpty) {
      _clearFeedbackSelection();
      return;
    }
    final bool isAlreadyMatched = state.matchedPairs.any(
      (StudyMatchSubmission pair) =>
          pair.leftId == feedbackLeftId && pair.rightId == feedbackRightId,
    );
    final List<StudyMatchSubmission> nextMatchedPairs = isAlreadyMatched
        ? state.matchedPairs
        : <StudyMatchSubmission>[
            ...state.matchedPairs,
            StudyMatchSubmission(
              leftId: feedbackLeftId!,
              rightId: feedbackRightId!,
            ),
          ];
    _cancelFeedbackTimers();
    state = state.copyWith(
      matchedPairs: nextMatchedPairs,
      selectedLeftId: null,
      selectedRightId: null,
      feedbackLeftId: null,
      feedbackRightId: null,
      isFeedbackSuccess: false,
      isFeedbackError: false,
      isFeedbackDisappearing: false,
    );
  }

  void _clearFeedbackSelection() {
    _cancelFeedbackTimers();
    state = state.copyWith(
      selectedLeftId: null,
      selectedRightId: null,
      feedbackLeftId: null,
      feedbackRightId: null,
      isFeedbackSuccess: false,
      isFeedbackError: false,
      isFeedbackDisappearing: false,
    );
  }

  void _cancelFeedbackTimers() {
    _feedbackTimer?.cancel();
    _disappearTimer?.cancel();
    _feedbackTimer = null;
    _disappearTimer = null;
  }
}
