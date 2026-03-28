import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../mode/study_mode_action_button_style.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import '../../widgets/study_session_action_row_layout.dart';

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
        switch (actions.first.style) {
          StudyModeActionButtonStyle.primary => LumosPrimaryButton(
            label: actions.first.label,
            onPressed: () => onActionPressed(actions.first.actionId),
            size: LumosButtonSize.large,
            icon: actions.first.icon,
            expanded: true,
          ),
          StudyModeActionButtonStyle.secondary => LumosSecondaryButton(
            label: actions.first.label,
            onPressed: () => onActionPressed(actions.first.actionId),
            size: LumosButtonSize.large,
            icon: actions.first.icon,
            expanded: true,
          ),
          StudyModeActionButtonStyle.outline => LumosOutlineButton(
            label: actions.first.label,
            onPressed: () => onActionPressed(actions.first.actionId),
            size: LumosButtonSize.large,
            icon: actions.first.icon,
            expanded: true,
          ),
        },
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
            (StudyModeActionViewModel action) => switch (action.style) {
              StudyModeActionButtonStyle.primary => LumosPrimaryButton(
                label: action.label,
                onPressed: () => onActionPressed(action.actionId),
                size: LumosButtonSize.large,
                icon: action.icon,
                expanded: true,
              ),
              StudyModeActionButtonStyle.secondary => LumosSecondaryButton(
                label: action.label,
                onPressed: () => onActionPressed(action.actionId),
                size: LumosButtonSize.large,
                icon: action.icon,
                expanded: true,
              ),
              StudyModeActionButtonStyle.outline => LumosOutlineButton(
                label: action.label,
                onPressed: () => onActionPressed(action.actionId),
                size: LumosButtonSize.large,
                icon: action.icon,
                expanded: true,
              ),
            },
          )
          .toList(growable: false);
    }
    if (actionButtons.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactWidth = constraints.maxWidth < 380;
        return StudySessionActionRowLayout(
          gap: compactWidth ? LumosSpacing.md : LumosSpacing.lg,
          rowHeight: compactWidth ? 56 : 64,
          verticalSpacing: compactWidth ? LumosSpacing.xs : LumosSpacing.sm,
          singleWidthFactor: compactWidth ? 0.56 : 0.42,
          children: actionButtons,
        );
      },
    );
  }
}
