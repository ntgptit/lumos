import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_guess_selection_provider.g.dart';

const Duration studyGuessSuccessFeedbackDuration = Duration(milliseconds: 600);
const Duration studyGuessErrorFeedbackDuration = Duration(milliseconds: 700);

@immutable
class StudyGuessSelectionState {
  const StudyGuessSelectionState({
    required this.currentItemKey,
    required this.selectedChoiceLabel,
    required this.pendingSubmittedAnswer,
    required this.isFeedbackSuccess,
    required this.isFeedbackError,
  });

  const StudyGuessSelectionState.initial()
    : currentItemKey = null,
      selectedChoiceLabel = null,
      pendingSubmittedAnswer = null,
      isFeedbackSuccess = false,
      isFeedbackError = false;

  final String? currentItemKey;
  final String? selectedChoiceLabel;
  final String? pendingSubmittedAnswer;
  final bool isFeedbackSuccess;
  final bool isFeedbackError;

  bool get hasActiveFeedback {
    return (selectedChoiceLabel ?? '').isNotEmpty &&
        (isFeedbackSuccess || isFeedbackError);
  }

  bool get canSubmit {
    return (pendingSubmittedAnswer ?? '').isNotEmpty;
  }

  bool get isInteractionLocked {
    return hasActiveFeedback || canSubmit;
  }

  bool isChoiceSelected(String choiceLabel) {
    return selectedChoiceLabel == choiceLabel;
  }

  bool isSuccessFeedbackFor(String choiceLabel) {
    return isFeedbackSuccess && selectedChoiceLabel == choiceLabel;
  }

  bool isErrorFeedbackFor(String choiceLabel) {
    return isFeedbackError && selectedChoiceLabel == choiceLabel;
  }

  StudyGuessSelectionState copyWith({
    Object? currentItemKey = _unsetGuessValue,
    Object? selectedChoiceLabel = _unsetGuessValue,
    Object? pendingSubmittedAnswer = _unsetGuessValue,
    bool? isFeedbackSuccess,
    bool? isFeedbackError,
  }) {
    return StudyGuessSelectionState(
      currentItemKey: identical(currentItemKey, _unsetGuessValue)
          ? this.currentItemKey
          : currentItemKey as String?,
      selectedChoiceLabel: identical(selectedChoiceLabel, _unsetGuessValue)
          ? this.selectedChoiceLabel
          : selectedChoiceLabel as String?,
      pendingSubmittedAnswer:
          identical(pendingSubmittedAnswer, _unsetGuessValue)
          ? this.pendingSubmittedAnswer
          : pendingSubmittedAnswer as String?,
      isFeedbackSuccess: isFeedbackSuccess ?? this.isFeedbackSuccess,
      isFeedbackError: isFeedbackError ?? this.isFeedbackError,
    );
  }
}

const Object _unsetGuessValue = Object();

@Riverpod(keepAlive: true)
class StudyGuessSelectionController extends _$StudyGuessSelectionController {
  Timer? _feedbackTimer;

  @override
  StudyGuessSelectionState build(int sessionId) {
    ref.onDispose(_cancelFeedbackTimer);
    return const StudyGuessSelectionState.initial();
  }

  void syncCurrentItem({required String itemKey}) {
    if (state.currentItemKey == itemKey) {
      return;
    }
    _cancelFeedbackTimer();
    state = StudyGuessSelectionState(
      currentItemKey: itemKey,
      selectedChoiceLabel: null,
      pendingSubmittedAnswer: null,
      isFeedbackSuccess: false,
      isFeedbackError: false,
    );
  }

  void selectChoice({required String choiceLabel, required bool isCorrect}) {
    if (state.isInteractionLocked) {
      return;
    }
    if (isCorrect) {
      _queueSuccessFeedback(choiceLabel);
      return;
    }
    _queueErrorFeedback(choiceLabel);
  }

  void reset() {
    _cancelFeedbackTimer();
    state = state.copyWith(
      selectedChoiceLabel: null,
      pendingSubmittedAnswer: null,
      isFeedbackSuccess: false,
      isFeedbackError: false,
    );
  }

  void _queueSuccessFeedback(String choiceLabel) {
    _cancelFeedbackTimer();
    state = state.copyWith(
      selectedChoiceLabel: choiceLabel,
      pendingSubmittedAnswer: null,
      isFeedbackSuccess: true,
      isFeedbackError: false,
    );
    _feedbackTimer = Timer(
      studyGuessSuccessFeedbackDuration,
      _completeSuccessFeedback,
    );
  }

  void _queueErrorFeedback(String choiceLabel) {
    _cancelFeedbackTimer();
    state = state.copyWith(
      selectedChoiceLabel: choiceLabel,
      pendingSubmittedAnswer: null,
      isFeedbackSuccess: false,
      isFeedbackError: true,
    );
    _feedbackTimer = Timer(studyGuessErrorFeedbackDuration, reset);
  }

  void _completeSuccessFeedback() {
    final String? selectedChoiceLabel = state.selectedChoiceLabel;
    if (!state.isFeedbackSuccess || (selectedChoiceLabel ?? '').isEmpty) {
      return;
    }
    state = state.copyWith(pendingSubmittedAnswer: selectedChoiceLabel);
  }

  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }
}
