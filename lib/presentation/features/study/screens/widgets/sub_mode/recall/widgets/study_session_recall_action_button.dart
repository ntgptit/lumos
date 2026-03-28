import 'package:flutter/material.dart';

import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
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

