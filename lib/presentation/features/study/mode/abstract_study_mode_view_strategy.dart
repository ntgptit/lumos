import 'package:flutter/material.dart';

import '../../../../domain/entities/study/study_models.dart';
import 'study_mode_action_button_style.dart';
import 'study_mode_action_view_model.dart';
import 'study_mode_view_model.dart';
import 'study_mode_view_strategy.dart';

abstract class AbstractStudyModeViewStrategy implements StudyModeViewStrategy {
  const AbstractStudyModeViewStrategy();

  static const String _actionGoNext = 'GO_NEXT';
  static const String _actionMarkRemembered = 'MARK_REMEMBERED';
  static const String _actionRevealAnswer = 'REVEAL_ANSWER';
  static const String _actionRetryItem = 'RETRY_ITEM';
  static const String _actionSubmitAnswer = 'SUBMIT_ANSWER';
  static const String _defaultInputLabel = 'Answer';
  static const String _defaultSubmitLabel = 'Check';

  @override
  StudyModeViewModel buildViewModel({required StudySessionData session}) {
    final StudySessionItemData currentItem = session.currentItem;
    return StudyModeViewModel(
      modeLabel: resolveModeLabel(),
      instruction: currentItem.instruction,
      prompt: currentItem.prompt,
      answer: currentItem.answer,
      showAnswer: shouldShowAnswer(session: session),
      showAnswerInput: shouldShowAnswerInput(
        session: session,
        currentItem: currentItem,
      ),
      inputLabel: resolveInputLabel(currentItem: currentItem),
      submitLabel: resolveSubmitLabel(),
      useChoiceGrid: usesChoiceGrid(),
      choices: resolveChoices(currentItem: currentItem),
      matchPairs: resolveMatchPairs(currentItem: currentItem),
      actions: resolveActions(session: session),
    );
  }

  bool shouldShowAnswer({required StudySessionData session}) {
    return session.modeState == 'WAITING_FEEDBACK';
  }

  bool shouldShowAnswerInput({
    required StudySessionData session,
    required StudySessionItemData currentItem,
  }) {
    if (currentItem.choices.isNotEmpty) {
      return false;
    }
    return session.allowedActions.contains(_actionSubmitAnswer);
  }

  String resolveInputLabel({required StudySessionItemData currentItem}) {
    if (currentItem.inputPlaceholder.isNotEmpty) {
      return currentItem.inputPlaceholder;
    }
    return _defaultInputLabel;
  }

  String resolveSubmitLabel() {
    return _defaultSubmitLabel;
  }

  List<StudyChoice> resolveChoices({
    required StudySessionItemData currentItem,
  }) {
    return currentItem.choices;
  }

  List<StudyMatchPair> resolveMatchPairs({
    required StudySessionItemData currentItem,
  }) {
    return currentItem.matchPairs;
  }

  bool usesChoiceGrid() {
    return false;
  }

  List<String> resolveActionOrder();

  String resolveModeLabel() {
    switch (supportedMode) {
      case 'REVIEW':
        return 'Xem lại';
      case 'MATCH':
        return 'Ghép đôi';
      case 'GUESS':
        return 'Đoán';
      case 'RECALL':
        return 'Nhớ lại';
      case 'FILL':
        return 'Điền';
    }
    return supportedMode;
  }

  StudyModeActionViewModel? resolveActionViewModel({
    required String actionId,
    required StudySessionData session,
  }) {
    switch (actionId) {
      case _actionRevealAnswer:
        return StudyModeActionViewModel(
          actionId: _actionRevealAnswer,
          label: resolveRevealActionLabel(),
          style: StudyModeActionButtonStyle.secondary,
        );
      case _actionMarkRemembered:
        return StudyModeActionViewModel(
          actionId: _actionMarkRemembered,
          label: resolveRememberedActionLabel(),
          style: StudyModeActionButtonStyle.secondary,
        );
      case _actionRetryItem:
        return StudyModeActionViewModel(
          actionId: _actionRetryItem,
          label: resolveRetryActionLabel(),
          style: StudyModeActionButtonStyle.outline,
        );
      case _actionGoNext:
        return StudyModeActionViewModel(
          actionId: _actionGoNext,
          label: session.sessionCompleted ? 'Hoàn tất' : 'Tiếp tục',
          style: StudyModeActionButtonStyle.primary,
          icon: Icons.navigate_next_rounded,
        );
    }
    return null;
  }

  String resolveRevealActionLabel() {
    return 'Hiển thị';
  }

  String resolveRememberedActionLabel() {
    return 'Nhớ được';
  }

  String resolveRetryActionLabel() {
    return 'Cần học lại';
  }

  List<StudyModeActionViewModel> resolveActions({
    required StudySessionData session,
  }) {
    final List<StudyModeActionViewModel> actions = <StudyModeActionViewModel>[];
    for (final String actionId in resolveActionOrder()) {
      if (!session.allowedActions.contains(actionId)) {
        continue;
      }
      final StudyModeActionViewModel? action = resolveActionViewModel(
        actionId: actionId,
        session: session,
      );
      if (action == null) {
        continue;
      }
      actions.add(action);
    }
    return actions;
  }
}
