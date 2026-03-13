import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../mode/study_mode_action_button_style.dart';
import '../../../mode/study_mode_action_view_model.dart';

class StudySessionActionBar extends StatelessWidget {
  const StudySessionActionBar({
    required this.actions,
    required this.onActionPressed,
    super.key,
  });

  final List<StudyModeActionViewModel> actions;
  final ValueChanged<String> onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: actions
          .map(
            (StudyModeActionViewModel action) =>
                _buildActionButton(action: action),
          )
          .toList(growable: false),
    );
  }

  Widget _buildActionButton({required StudyModeActionViewModel action}) {
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
