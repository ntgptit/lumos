import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import '../../../../../providers/study_recall_selection_provider.dart';
import '../../widgets/study_session_action_row_layout.dart';
import '../../widgets/study_session_layout_metrics.dart';
import 'study_session_recall_action_button.dart';

class StudySessionRecallActionRow extends StatelessWidget {
  const StudySessionRecallActionRow({
    required this.actions,
    required this.selectionState,
    required this.onActionPressed,
    super.key,
  });

  final List<StudyModeActionViewModel> actions;
  final StudyRecallSelectionState selectionState;
  final ValueChanged<String> onActionPressed;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = actions
        .map(
          (StudyModeActionViewModel action) => StudySessionRecallActionButton(
            action: action,
            selectionState: selectionState,
            onActionPressed: onActionPressed,
          ),
        )
        .toList(growable: false);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactWidth = constraints.maxWidth <
            StudySessionLayoutMetrics.compactActionWidthBreakpoint;
        return StudySessionActionRowLayout(
          gap: compactWidth ? context.spacing.md : context.spacing.lg,
          rowHeight: compactWidth ? 56 : 64,
          verticalSpacing: compactWidth ? context.spacing.xs : context.spacing.sm,
          singleWidthFactor: compactWidth ? 0.56 : 0.42,
          children: actionButtons,
        );
      },
    );
  }
}
