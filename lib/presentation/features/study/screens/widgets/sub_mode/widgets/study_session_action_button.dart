import 'package:flutter/material.dart';

import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../mode/study_mode_action_button_style.dart';
import '../../../../mode/study_mode_action_view_model.dart';

class StudySessionActionButton extends StatelessWidget {
  const StudySessionActionButton({
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
          onPressed: () => onActionPressed(action.actionId),
          label: action.label,
          icon: action.icon,
        );
      case StudyModeActionButtonStyle.secondary:
        return LumosSecondaryButton(
          onPressed: () => onActionPressed(action.actionId),
          label: action.label,
        );
      case StudyModeActionButtonStyle.outline:
        return LumosOutlineButton(
          onPressed: () => onActionPressed(action.actionId),
          label: action.label,
        );
    }
  }
}
