import 'package:flutter/material.dart';

import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../mode/study_mode_action_button_style.dart';
import '../../../../../mode/study_mode_action_view_model.dart';

class StudySessionFillActionButton extends StatelessWidget {
  const StudySessionFillActionButton({
    required this.action,
    required this.onActionPressed,
    super.key,
  });

  final StudyModeActionViewModel action;
  final ValueChanged<String> onActionPressed;

  @override
  Widget build(BuildContext context) {
    switch (action.style) {
      case StudyModeActionButtonStyle.primary:
        return LumosPrimaryButton(
          label: action.label,
          onPressed: () => onActionPressed(action.actionId),
          size: LumosButtonSize.large,
          icon: action.icon,
          expanded: true,
        );
      case StudyModeActionButtonStyle.secondary:
        return LumosSecondaryButton(
          label: action.label,
          onPressed: () => onActionPressed(action.actionId),
          size: LumosButtonSize.large,
          icon: action.icon,
          expanded: true,
        );
      case StudyModeActionButtonStyle.outline:
        return LumosOutlineButton(
          label: action.label,
          onPressed: () => onActionPressed(action.actionId),
          size: LumosButtonSize.large,
          icon: action.icon,
          expanded: true,
        );
    }
  }
}
