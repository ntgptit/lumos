import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import 'study_session_fill_action_button.dart';

const double _fillSingleActionWidthFactor = 0.42;
const double _fillActionGap = AppSpacing.lg;
const double _fillActionRowHeight = 64;

class StudySessionFillActionRow extends StatelessWidget {
  const StudySessionFillActionRow({
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
        height: _fillActionRowHeight,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: _fillSingleActionWidthFactor,
            child: StudySessionFillActionButton(
              action: actions.first,
              onActionPressed: onActionPressed,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: _fillActionRowHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: StudySessionFillActionButton(
              action: actions.first,
              onActionPressed: onActionPressed,
            ),
          ),
          const SizedBox(width: _fillActionGap),
          Expanded(
            child: StudySessionFillActionButton(
              action: actions.last,
              onActionPressed: onActionPressed,
            ),
          ),
        ],
      ),
    );
  }
}
