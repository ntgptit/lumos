import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import 'study_session_recall_action_button.dart';

const double _recallSingleActionWidthFactor = 0.42;
const double _recallActionGap = AppSpacing.lg;
const double _recallActionRowHeight = 64;

class StudySessionRecallActionRow extends StatelessWidget {
  const StudySessionRecallActionRow({
    required this.actions,
    required this.onActionPressed,
    super.key,
  });

  final List<StudyModeActionViewModel> actions;
  final ValueChanged<String> onActionPressed;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    if (actions.length == 1) {
      return SizedBox(
        height: _recallActionRowHeight,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: _recallSingleActionWidthFactor,
            child: StudySessionRecallActionButton(
              action: actions.first,
              onActionPressed: onActionPressed,
            ),
          ),
        ),
      );
    }
    if (actions.length == 2) {
      return SizedBox(
        height: _recallActionRowHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              child: StudySessionRecallActionButton(
                action: actions.first,
                onActionPressed: onActionPressed,
              ),
            ),
            const SizedBox(width: _recallActionGap),
            Expanded(
              child: StudySessionRecallActionButton(
                action: actions.last,
                onActionPressed: onActionPressed,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: actions
          .map(
            (StudyModeActionViewModel action) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: StudySessionRecallActionButton(
                action: action,
                onActionPressed: onActionPressed,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
