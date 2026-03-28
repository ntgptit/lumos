import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../mode/study_mode_action_view_model.dart';
import 'study_session_action_button.dart';
import 'study_session_layout_metrics.dart';

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double baseGap = constraints.maxWidth < 380
            ? LumosSpacing.xs
            : LumosSpacing.sm;
        final double actionGap = StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue: baseGap,
        );
        return Wrap(
          spacing: actionGap,
          runSpacing: actionGap,
          children: actions
              .map(
                (StudyModeActionViewModel action) => StudySessionActionButton(
                  action: action,
                  onActionPressed: onActionPressed,
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

