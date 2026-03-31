import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../mode/study_mode_action_button_style.dart';
import '../../../../../mode/study_mode_action_view_model.dart';
import '../../widgets/study_session_action_row_layout.dart';
import '../../widgets/study_session_layout_metrics.dart';

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
          text: resolvedSecondaryLabel,
          onPressed: resolvedSecondaryPressed,
          size: LumosButtonSize.large,
          expand: true,
        ),
        LumosPrimaryButton(
          text: resolvedPrimaryLabel,
          onPressed: resolvedPrimaryPressed,
          size: LumosButtonSize.large,
          expand: true,
        ),
      ];
    }
    if (actionButtons.isEmpty && hasPrimaryOverride) {
      actionButtons = <Widget>[
        LumosPrimaryButton(
          text: resolvedPrimaryLabel,
          onPressed: resolvedPrimaryPressed,
          size: LumosButtonSize.large,
          expand: true,
        ),
      ];
    }
    if (actionButtons.isEmpty && showsSubmitAction && actions.isEmpty) {
      actionButtons = <Widget>[
        LumosPrimaryButton(
          text: resolvedSubmitLabel,
          onPressed: resolvedSubmitPressed,
          size: LumosButtonSize.large,
          expand: true,
        ),
      ];
    }
    if (actionButtons.isEmpty && showsSubmitAction) {
      actionButtons = <Widget>[
        switch (actions.first.style) {
          StudyModeActionButtonStyle.primary => LumosPrimaryButton(
            text: actions.first.label,
            onPressed: () => onActionPressed(actions.first.actionId),
            size: LumosButtonSize.large,
            icon: actions.first.icon,
            expand: true,
          ),
          StudyModeActionButtonStyle.secondary => LumosSecondaryButton(
            text: actions.first.label,
            onPressed: () => onActionPressed(actions.first.actionId),
            size: LumosButtonSize.large,
            icon: actions.first.icon,
            expand: true,
          ),
          StudyModeActionButtonStyle.outline => LumosOutlineButton(
            text: actions.first.label,
            onPressed: () => onActionPressed(actions.first.actionId),
            size: LumosButtonSize.large,
            icon: actions.first.icon,
            expand: true,
          ),
        },
        LumosPrimaryButton(
          text: resolvedSubmitLabel,
          onPressed: resolvedSubmitPressed,
          size: LumosButtonSize.large,
          expand: true,
        ),
      ];
    }
    if (actionButtons.isEmpty) {
      actionButtons = actions
          .map(
            (StudyModeActionViewModel action) => switch (action.style) {
              StudyModeActionButtonStyle.primary => LumosPrimaryButton(
                text: action.label,
                onPressed: () => onActionPressed(action.actionId),
                size: LumosButtonSize.large,
                icon: action.icon,
                expand: true,
              ),
              StudyModeActionButtonStyle.secondary => LumosSecondaryButton(
                text: action.label,
                onPressed: () => onActionPressed(action.actionId),
                size: LumosButtonSize.large,
                icon: action.icon,
                expand: true,
              ),
              StudyModeActionButtonStyle.outline => LumosOutlineButton(
                text: action.label,
                onPressed: () => onActionPressed(action.actionId),
                size: LumosButtonSize.large,
                icon: action.icon,
                expand: true,
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
