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

  @override
  StudyModeViewModel buildViewModel({required StudySessionData session}) {
    final StudySessionItemData currentItem = session.currentItem;
    return StudyModeViewModel(
      instruction: currentItem.instruction,
      prompt: currentItem.prompt,
      answer: currentItem.answer,
      showAnswer: shouldShowAnswer(session: session),
      showAnswerInput: shouldShowAnswerInput(
        session: session,
        currentItem: currentItem,
      ),
      inputLabel: resolveInputLabel(currentItem: currentItem),
      choices: resolveChoices(currentItem: currentItem),
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

  List<StudyChoice> resolveChoices({required StudySessionItemData currentItem}) {
    return currentItem.choices;
  }

  List<String> resolveActionOrder();

  StudyModeActionViewModel? resolveActionViewModel({
    required String actionId,
    required StudySessionData session,
  }) {
    switch (actionId) {
      case _actionRevealAnswer:
        return const StudyModeActionViewModel(
          actionId: _actionRevealAnswer,
          label: 'Reveal',
          style: StudyModeActionButtonStyle.secondary,
        );
      case _actionMarkRemembered:
        return const StudyModeActionViewModel(
          actionId: _actionMarkRemembered,
          label: 'Remembered',
          style: StudyModeActionButtonStyle.secondary,
        );
      case _actionRetryItem:
        return const StudyModeActionViewModel(
          actionId: _actionRetryItem,
          label: 'Retry later',
          style: StudyModeActionButtonStyle.outline,
        );
      case _actionGoNext:
        return StudyModeActionViewModel(
          actionId: _actionGoNext,
          label: session.sessionCompleted ? 'Done' : 'Next',
          style: StudyModeActionButtonStyle.primary,
          icon: Icons.navigate_next_rounded,
        );
    }
    return null;
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
