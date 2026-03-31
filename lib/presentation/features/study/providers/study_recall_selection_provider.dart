import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_recall_selection_provider.g.dart';

const int studyRecallRevealCountdownSeconds = 15;
const Duration _studyRecallRevealTickDuration = Duration(seconds: 1);
const Duration studyRecallRememberedFeedbackDuration = Duration(
  milliseconds: 600,
);
const Duration studyRecallRetryFeedbackDuration = Duration(milliseconds: 700);

@immutable
class StudyRecallSelectionState {
  const StudyRecallSelectionState({
    required this.currentItemKey,
    required this.selectedActionId,
    required this.revealCountdownSeconds,
    required this.hasPendingReveal,
    required this.isRevealCountdownActive,
    required this.showsNextActionOnly,
    required this.pendingSubmittedActionId,
    required this.isRememberedFeedback,
    required this.isRetryFeedback,
  });

  const StudyRecallSelectionState.initial()
    : currentItemKey = null,
      selectedActionId = null,
      revealCountdownSeconds = 0,
      hasPendingReveal = false,
      isRevealCountdownActive = false,
      showsNextActionOnly = false,
      pendingSubmittedActionId = null,
      isRememberedFeedback = false,
      isRetryFeedback = false;

  final String? currentItemKey;
  final String? selectedActionId;
  final int revealCountdownSeconds;
  final bool hasPendingReveal;
  final bool isRevealCountdownActive;
  final bool showsNextActionOnly;
  final String? pendingSubmittedActionId;
  final bool isRememberedFeedback;
  final bool isRetryFeedback;

  bool get hasActiveFeedback {
    return (selectedActionId ?? '').isNotEmpty &&
        (isRememberedFeedback || isRetryFeedback);
  }

  bool get canSubmit {
    return (pendingSubmittedActionId ?? '').isNotEmpty;
  }

  bool get isInteractionLocked {
    return hasPendingReveal || hasActiveFeedback || canSubmit;
  }

  bool isSelected(String actionId) {
    return selectedActionId == actionId;
  }

  StudyRecallSelectionState copyWith({
    Object? currentItemKey = _unsetRecallValue,
    Object? selectedActionId = _unsetRecallValue,
    int? revealCountdownSeconds,
    bool? hasPendingReveal,
    bool? isRevealCountdownActive,
    bool? showsNextActionOnly,
    Object? pendingSubmittedActionId = _unsetRecallValue,
    bool? isRememberedFeedback,
    bool? isRetryFeedback,
  }) {
    return StudyRecallSelectionState(
      currentItemKey: identical(currentItemKey, _unsetRecallValue)
          ? this.currentItemKey
          : currentItemKey as String?,
      selectedActionId: identical(selectedActionId, _unsetRecallValue)
          ? this.selectedActionId
          : selectedActionId as String?,
      revealCountdownSeconds:
          revealCountdownSeconds ?? this.revealCountdownSeconds,
      hasPendingReveal: hasPendingReveal ?? this.hasPendingReveal,
      isRevealCountdownActive:
          isRevealCountdownActive ?? this.isRevealCountdownActive,
      showsNextActionOnly: showsNextActionOnly ?? this.showsNextActionOnly,
      pendingSubmittedActionId:
          identical(pendingSubmittedActionId, _unsetRecallValue)
          ? this.pendingSubmittedActionId
          : pendingSubmittedActionId as String?,
      isRememberedFeedback: isRememberedFeedback ?? this.isRememberedFeedback,
      isRetryFeedback: isRetryFeedback ?? this.isRetryFeedback,
    );
  }
}

const Object _unsetRecallValue = Object();

@Riverpod(keepAlive: true)
class StudyRecallSelectionController extends _$StudyRecallSelectionController {
  static const String revealActionId = 'REVEAL_ANSWER';
  static const String rememberedActionId = 'MARK_REMEMBERED';
  static const String retryActionId = 'RETRY_ITEM';

  Timer? _feedbackTimer;
  Timer? _revealCountdownTimer;

  @override
  StudyRecallSelectionState build(int sessionId) {
    ref.onDispose(_cancelAllTimers);
    return const StudyRecallSelectionState.initial();
  }

  void syncCurrentItem({
    required String itemKey,
    required bool shouldStartRevealCountdown,
  }) {
    if (state.currentItemKey != itemKey) {
      _replaceCurrentItemState(
        itemKey: itemKey,
        shouldStartRevealCountdown: shouldStartRevealCountdown,
      );
      return;
    }
    if (shouldStartRevealCountdown) {
      _restartCurrentItemCountdown();
      return;
    }
    _stopRevealCountdownForCurrentItem();
  }

  void selectAction({required String actionId}) {
    if (state.isInteractionLocked) {
      return;
    }
    if (actionId == revealActionId) {
      queueManualReveal();
      return;
    }
    if (actionId == rememberedActionId) {
      _queueRememberedFeedback();
      return;
    }
    if (actionId == retryActionId) {
      _queueRetryFeedback();
    }
  }

  void reset() {
    _cancelFeedbackTimer();
    state = state.copyWith(
      selectedActionId: null,
      showsNextActionOnly: false,
      pendingSubmittedActionId: null,
      isRememberedFeedback: false,
      isRetryFeedback: false,
    );
  }

  void queueManualReveal() {
    if (state.hasPendingReveal) {
      return;
    }
    if (!state.isRevealCountdownActive && state.revealCountdownSeconds <= 0) {
      return;
    }
    _cancelRevealCountdownTimer();
    state = state.copyWith(
      selectedActionId: revealActionId,
      revealCountdownSeconds: 0,
      hasPendingReveal: true,
      isRevealCountdownActive: false,
      showsNextActionOnly: false,
    );
  }

  void queueTimedOutReveal() {
    if (state.hasPendingReveal) {
      return;
    }
    _cancelRevealCountdownTimer();
    state = state.copyWith(
      selectedActionId: revealActionId,
      revealCountdownSeconds: 0,
      hasPendingReveal: true,
      isRevealCountdownActive: false,
      showsNextActionOnly: true,
    );
  }

  void restartRevealCountdown() {
    _cancelRevealCountdownTimer();
    state = state.copyWith(
      selectedActionId: null,
      revealCountdownSeconds: studyRecallRevealCountdownSeconds,
      hasPendingReveal: false,
      isRevealCountdownActive: true,
      showsNextActionOnly: false,
    );
    _startRevealCountdown();
  }

  void _queueRememberedFeedback() {
    _cancelFeedbackTimer();
    state = state.copyWith(
      selectedActionId: rememberedActionId,
      pendingSubmittedActionId: null,
      isRememberedFeedback: true,
      isRetryFeedback: false,
    );
    _feedbackTimer = Timer(
      studyRecallRememberedFeedbackDuration,
      _queuePendingSubmit,
    );
  }

  void _queueRetryFeedback() {
    _cancelFeedbackTimer();
    state = state.copyWith(
      selectedActionId: retryActionId,
      pendingSubmittedActionId: null,
      isRememberedFeedback: false,
      isRetryFeedback: true,
    );
    _feedbackTimer = Timer(
      studyRecallRetryFeedbackDuration,
      _queuePendingSubmit,
    );
  }

  void _queuePendingSubmit() {
    final String? selectedActionId = state.selectedActionId;
    if ((selectedActionId ?? '').isEmpty) {
      return;
    }
    state = state.copyWith(pendingSubmittedActionId: selectedActionId);
  }

  void _startRevealCountdown() {
    _revealCountdownTimer = Timer.periodic(
      _studyRecallRevealTickDuration,
      _handleRevealCountdownTick,
    );
  }

  void _handleRevealCountdownTick(Timer timer) {
    final int currentSeconds = state.revealCountdownSeconds;
    if (currentSeconds <= 1) {
      queueTimedOutReveal();
      return;
    }
    state = state.copyWith(revealCountdownSeconds: currentSeconds - 1);
  }

  void _replaceCurrentItemState({
    required String itemKey,
    required bool shouldStartRevealCountdown,
  }) {
    _cancelAllTimers();
    state = StudyRecallSelectionState(
      currentItemKey: itemKey,
      selectedActionId: null,
      revealCountdownSeconds: shouldStartRevealCountdown
          ? studyRecallRevealCountdownSeconds
          : 0,
      hasPendingReveal: false,
      isRevealCountdownActive: shouldStartRevealCountdown,
      showsNextActionOnly: false,
      pendingSubmittedActionId: null,
      isRememberedFeedback: false,
      isRetryFeedback: false,
    );
    if (!shouldStartRevealCountdown) {
      return;
    }
    _startRevealCountdown();
  }

  void _restartCurrentItemCountdown() {
    if (state.isRevealCountdownActive &&
        !state.hasPendingReveal &&
        !state.showsNextActionOnly) {
      return;
    }
    _cancelAllTimers();
    state = state.copyWith(
      selectedActionId: null,
      revealCountdownSeconds: studyRecallRevealCountdownSeconds,
      hasPendingReveal: false,
      isRevealCountdownActive: true,
      showsNextActionOnly: false,
      pendingSubmittedActionId: null,
      isRememberedFeedback: false,
      isRetryFeedback: false,
    );
    _startRevealCountdown();
  }

  void _stopRevealCountdownForCurrentItem() {
    _cancelRevealCountdownTimer();
    final String? selectedActionId = state.selectedActionId == revealActionId
        ? null
        : state.selectedActionId;
    state = state.copyWith(
      selectedActionId: selectedActionId,
      revealCountdownSeconds: 0,
      hasPendingReveal: false,
      isRevealCountdownActive: false,
    );
  }

  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }

  void _cancelRevealCountdownTimer() {
    _revealCountdownTimer?.cancel();
    _revealCountdownTimer = null;
  }

  void _cancelAllTimers() {
    _cancelFeedbackTimer();
    _cancelRevealCountdownTimer();
  }
}
