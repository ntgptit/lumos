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
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.primaryLabel,
    this.onPrimaryPressed,
    super.key,
  });

  final List<StudyModeActionViewModel> actions;
  final ValueChanged<String> onActionPressed;
  final String? submitLabel;
  final VoidCallback? onSubmitPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final String? primaryLabel;
  final VoidCallback? onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final String? resolvedPrimaryLabel = primaryLabel;
    final VoidCallback? resolvedPrimaryPressed = onPrimaryPressed;
    final String? resolvedSecondaryLabel = secondaryLabel;
    final VoidCallback? resolvedSecondaryPressed = onSecondaryPressed;
    final bool hasPrimaryOverride =
        resolvedPrimaryLabel != null && resolvedPrimaryPressed != null;
    final bool hasSecondaryOverride =
        resolvedSecondaryLabel != null && resolvedSecondaryPressed != null;
    final String? resolvedSubmitLabel = submitLabel;
    final VoidCallback? resolvedSubmitPressed = onSubmitPressed;
    final bool showsSubmitAction =
        resolvedSubmitLabel != null && resolvedSubmitPressed != null;
    List<Widget> actionButtons = <Widget>[];
    if (hasPrimaryOverride && hasSecondaryOverride) {
      actionButtons = <Widget>[
        LumosSecondaryButton(
          label: resolvedSecondaryLabel,
          onPressed: resolvedSecondaryPressed,
          size: LumosButtonSize.large,
          expanded: true,
        ),
        LumosPrimaryButton(
          label: resolvedPrimaryLabel,
          onPressed: resolvedPrimaryPressed,
          size: LumosButtonSize.large,
          expanded: true,
        ),
      ];
    }
    if (actionButtons.isEmpty && hasPrimaryOverride) {
      actionButtons = <Widget>[
        LumosPrimaryButton(
          label: resolvedPrimaryLabel,
          onPressed: resolvedPrimaryPressed,
          size: LumosButtonSize.large,
          expanded: true,
        ),
      ];
    }
    if (actionButtons.isEmpty && showsSubmitAction && actions.isEmpty) {
      actionButtons = <Widget>[
        LumosPrimaryButton(
          label: resolvedSubmitLabel,
          onPressed: resolvedSubmitPressed,
          size: LumosButtonSize.large,
          expanded: true,
        ),
      ];
    }
    if (actionButtons.isEmpty && showsSubmitAction) {
      actionButtons = <Widget>[
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
    if (actionButtons.isEmpty) {
      actionButtons = actions
          .map(
            (StudyModeActionViewModel action) => StudySessionFillActionButton(
              action: action,
              onActionPressed: onActionPressed,
            ),
          )
          .toList(growable: false);
    }
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
}
