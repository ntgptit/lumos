import 'package:flutter/material.dart';

import '../../../../../mode/study_mode_action_view_model.dart';
import '../../../../../providers/study_recall_selection_provider.dart';
import '../../widgets/study_session_action_row_layout.dart';
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
    return StudySessionActionRowLayout(
      children: actions
          .map(
            (StudyModeActionViewModel action) => StudySessionRecallActionButton(
              action: action,
              selectionState: selectionState,
              onActionPressed: onActionPressed,
            ),
          )
          .toList(growable: false),
    );
  }
}
