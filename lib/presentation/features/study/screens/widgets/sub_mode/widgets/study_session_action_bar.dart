import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../mode/study_mode_action_view_model.dart';
import 'study_session_action_button.dart';

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
            (StudyModeActionViewModel action) => StudySessionActionButton(
              action: action,
              onActionPressed: onActionPressed,
            ),
          )
          .toList(growable: false),
    );
  }
}
