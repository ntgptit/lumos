import 'package:flutter/material.dart';

import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../mode/study_mode_action_button_style.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import '../../../../../providers/study_recall_selection_provider.dart';

class StudySessionRecallActionButton extends StatelessWidget {
  const StudySessionRecallActionButton({
    required this.action,
    required this.selectionState,
    required this.onActionPressed,
    super.key,
  });

  final StudyModeActionViewModel action;
  final StudyRecallSelectionState selectionState;
  final ValueChanged<String> onActionPressed;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectionState.isSelected(action.actionId);
    final bool isInteractionLocked = selectionState.isInteractionLocked;
    final bool isRevealLoading =
        action.actionId == StudyRecallSelectionController.revealActionId &&
        selectionState.hasPendingReveal;
    final String resolvedLabel =
        action.actionId == StudyRecallSelectionController.revealActionId &&
            selectionState.isRevealCountdownActive
        ? '${action.label} (${selectionState.revealCountdownSeconds}s)'
        : action.label;
    final VoidCallback? onPressed = isInteractionLocked
        ? null
        : () => onActionPressed(action.actionId);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final LumosButtonSize buttonSize = constraints.maxWidth < 180
            ? LumosButtonSize.medium
            : LumosButtonSize.large;
        switch (action.style) {
          case StudyModeActionButtonStyle.primary:
            return LumosPrimaryButton(
              label: resolvedLabel,
              onPressed: onPressed,
              size: buttonSize,
              icon: action.icon,
              isLoading: isRevealLoading || (isSelected && isInteractionLocked),
              expanded: true,
            );
          case StudyModeActionButtonStyle.secondary:
            return LumosSecondaryButton(
              label: resolvedLabel,
              onPressed: onPressed,
              size: buttonSize,
              icon: action.icon,
              isLoading: isRevealLoading || (isSelected && isInteractionLocked),
              expanded: true,
            );
          case StudyModeActionButtonStyle.outline:
            return LumosOutlineButton(
              label: resolvedLabel,
              onPressed: onPressed,
              size: buttonSize,
              icon: action.icon,
              isLoading: isRevealLoading || (isSelected && isInteractionLocked),
              expanded: true,
            );
        }
      },
    );
  }
}
