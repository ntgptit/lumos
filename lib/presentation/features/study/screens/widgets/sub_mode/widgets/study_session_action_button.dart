import 'package:flutter/material.dart';

import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final LumosButtonSize buttonSize = constraints.maxWidth < 180
            ? LumosButtonSize.medium
            : LumosButtonSize.large;
        switch (action.style) {
          case StudyModeActionButtonStyle.primary:
            return LumosPrimaryButton(
              onPressed: () => onActionPressed(action.actionId),
              text: action.label,
              icon: action.icon,
              size: buttonSize,
            );
          case StudyModeActionButtonStyle.secondary:
            return LumosSecondaryButton(
              onPressed: () => onActionPressed(action.actionId),
              text: action.label,
              size: buttonSize,
            );
          case StudyModeActionButtonStyle.outline:
            return LumosOutlineButton(
              onPressed: () => onActionPressed(action.actionId),
              text: action.label,
              size: buttonSize,
            );
        }
      },
    );
  }
}

