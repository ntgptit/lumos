import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import 'study_session_fill_action_button.dart';

const double _fillSingleActionWidthFactor = 0.42;
const double _fillActionGap = AppSpacing.lg;
const double _fillActionRowHeight = 64;

class StudySessionFillActionRow extends StatelessWidget {
  const StudySessionFillActionRow({
    required this.actions,
    required this.onActionPressed,
    this.submitLabel,
    this.onSubmitPressed,
    super.key,
  });

  final List<StudyModeActionViewModel> actions;
  final ValueChanged<String> onActionPressed;
  final String? submitLabel;
  final VoidCallback? onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actionButtons = _buildActionButtons();
    if (actionButtons.isEmpty) {
      return const SizedBox.shrink();
    }
    if (actionButtons.length == 1) {
      return SizedBox(
        height: _fillActionRowHeight,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: _fillSingleActionWidthFactor,
            child: actionButtons.first,
          ),
        ),
      );
    }
    return SizedBox(
      height: _fillActionRowHeight,
      child: Row(
        children: <Widget>[
          Expanded(child: actionButtons.first),
          const SizedBox(width: _fillActionGap),
          Expanded(child: actionButtons.last),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final String? resolvedSubmitLabel = submitLabel;
    final VoidCallback? resolvedSubmitPressed = onSubmitPressed;
    final bool showsSubmitAction =
        resolvedSubmitLabel != null && resolvedSubmitPressed != null;
    if (showsSubmitAction) {
      if (actions.isEmpty) {
        return <Widget>[
          LumosPrimaryButton(
            label: resolvedSubmitLabel,
            onPressed: resolvedSubmitPressed,
            size: LumosButtonSize.large,
            expanded: true,
          ),
        ];
      }
      return <Widget>[
        StudySessionFillActionButton(
          action: actions.first,
          onActionPressed: onActionPressed,
        ),
        LumosPrimaryButton(
          label: resolvedSubmitLabel,
          onPressed: resolvedSubmitPressed,
          size: LumosButtonSize.large,
          expanded: true,
        ),
      ];
    }
    return actions
        .map(
          (StudyModeActionViewModel action) => StudySessionFillActionButton(
            action: action,
            onActionPressed: onActionPressed,
          ),
        )
        .toList(growable: false);
  }
}
