import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/string_utils.dart';

part 'study_fill_selection_provider.g.dart';

@immutable
class StudyFillSelectionState {
  const StudyFillSelectionState({
    required this.currentItemKey,
    required this.submittedAnswer,
    required this.mismatchStartIndex,
    required this.isCorrectSubmission,
    required this.showsRetryInput,
    required this.showsRequiredInputError,
  });

  const StudyFillSelectionState.initial()
    : currentItemKey = null,
      submittedAnswer = null,
      mismatchStartIndex = null,
      isCorrectSubmission = false,
      showsRetryInput = false,
      showsRequiredInputError = false;

  final String? currentItemKey;
  final String? submittedAnswer;
  final int? mismatchStartIndex;
  final bool isCorrectSubmission;
  final bool showsRetryInput;
  final bool showsRequiredInputError;

  bool get hasSubmittedAnswer {
    return (submittedAnswer ?? '').isNotEmpty;
  }

  bool get hasIncorrectSubmission {
    return mismatchStartIndex != null && !isCorrectSubmission;
  }

  StudyFillSelectionState copyWith({
    Object? currentItemKey = _unsetFillValue,
    Object? submittedAnswer = _unsetFillValue,
    Object? mismatchStartIndex = _unsetFillValue,
    bool? isCorrectSubmission,
    bool? showsRetryInput,
    bool? showsRequiredInputError,
  }) {
    return StudyFillSelectionState(
      currentItemKey: identical(currentItemKey, _unsetFillValue)
          ? this.currentItemKey
          : currentItemKey as String?,
      submittedAnswer: identical(submittedAnswer, _unsetFillValue)
          ? this.submittedAnswer
          : submittedAnswer as String?,
      mismatchStartIndex: identical(mismatchStartIndex, _unsetFillValue)
          ? this.mismatchStartIndex
          : mismatchStartIndex as int?,
      isCorrectSubmission: isCorrectSubmission ?? this.isCorrectSubmission,
      showsRetryInput: showsRetryInput ?? this.showsRetryInput,
      showsRequiredInputError:
          showsRequiredInputError ?? this.showsRequiredInputError,
    );
  }
}

const Object _unsetFillValue = Object();

@Riverpod(keepAlive: true)
class StudyFillSelectionController extends _$StudyFillSelectionController {
  @override
  StudyFillSelectionState build(int sessionId) {
    return const StudyFillSelectionState.initial();
  }

  void syncCurrentItem({required String itemKey}) {
    if (state.currentItemKey == itemKey) {
      return;
    }
    state = StudyFillSelectionState(
      currentItemKey: itemKey,
      submittedAnswer: null,
      mismatchStartIndex: null,
      isCorrectSubmission: false,
      showsRetryInput: false,
      showsRequiredInputError: false,
    );
  }

  bool evaluateSubmission({
    required String submittedAnswer,
    required String expectedAnswer,
  }) {
    final String normalizedSubmitted = StringUtils.normalizeName(
      submittedAnswer,
    );
    final bool isCorrect =
        StringUtils.compareNormalizedLower(submittedAnswer, expectedAnswer) ==
        0;
    state = state.copyWith(
      submittedAnswer: normalizedSubmitted,
      mismatchStartIndex: isCorrect
          ? null
          : _resolveMismatchStartIndex(
              submittedAnswer: submittedAnswer,
              expectedAnswer: expectedAnswer,
            ),
      isCorrectSubmission: isCorrect,
      showsRetryInput: false,
      showsRequiredInputError: false,
    );
    return isCorrect;
  }

  void markRevealAsIncorrect({
    required String submittedAnswer,
    required String expectedAnswer,
  }) {
    final String normalizedSubmitted = StringUtils.normalizeName(
      submittedAnswer,
    );
    final bool matchesExpected =
        StringUtils.compareNormalizedLower(submittedAnswer, expectedAnswer) ==
        0;
    state = state.copyWith(
      submittedAnswer: normalizedSubmitted,
      mismatchStartIndex: matchesExpected
          ? 0
          : _resolveMismatchStartIndex(
              submittedAnswer: submittedAnswer,
              expectedAnswer: expectedAnswer,
            ),
      isCorrectSubmission: false,
      showsRetryInput: false,
      showsRequiredInputError: false,
    );
  }

  void startRetryInput() {
    state = state.copyWith(
      submittedAnswer: null,
      mismatchStartIndex: null,
      isCorrectSubmission: false,
      showsRetryInput: true,
      showsRequiredInputError: false,
    );
  }

  void showRequiredInputError() {
    state = state.copyWith(
      showsRequiredInputError: true,
      showsRetryInput: false,
    );
  }

  void clearRequiredInputError() {
    if (!state.showsRequiredInputError) {
      return;
    }
    state = state.copyWith(showsRequiredInputError: false);
  }

  void resetResult() {
    state = state.copyWith(
      submittedAnswer: null,
      mismatchStartIndex: null,
      isCorrectSubmission: false,
      showsRetryInput: false,
      showsRequiredInputError: false,
    );
  }

  int _resolveMismatchStartIndex({
    required String submittedAnswer,
    required String expectedAnswer,
  }) {
    final String normalizedExpected = StringUtils.normalizeName(expectedAnswer);
    final String lowerSubmitted = StringUtils.normalizeLower(submittedAnswer);
    final String lowerExpected = StringUtils.normalizeLower(expectedAnswer);
    final int minLength = math.min(lowerSubmitted.length, lowerExpected.length);
    for (int index = 0; index < minLength; index += 1) {
      if (lowerSubmitted.codeUnitAt(index) == lowerExpected.codeUnitAt(index)) {
        continue;
      }
      return index;
    }
    if (normalizedExpected.isEmpty) {
      return 0;
    }
    if (minLength < normalizedExpected.length) {
      return minLength;
    }
    return normalizedExpected.length - 1;
  }
}
