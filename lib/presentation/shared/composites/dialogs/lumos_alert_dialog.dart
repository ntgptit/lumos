import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosAlertDialog extends StatelessWidget {
  const LumosAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.type = DialogType.info,
    this.icon,
    this.actions,
    this.constraints,
  });

  final String title;
  final Widget? content;
  final DialogType type;
  final Widget? icon;
  final List<Widget>? actions;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      iconPadding: EdgeInsets.only(top: context.spacing.xs),
      title: Text(title),
      content: content,
      actions: actions,
      insetPadding: _resolveInsetPadding(context),
      constraints: constraints ?? _resolveConstraints(context),
      backgroundColor: _resolveBackgroundColor(context),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: context.shapes.dialog),
    );
  }

  EdgeInsets _resolveInsetPadding(BuildContext context) {
    final double inset = context.component.dialogPadding;
    return EdgeInsets.all(inset);
  }

  BoxConstraints _resolveConstraints(BuildContext context) {
    final EdgeInsets insetPadding = _resolveInsetPadding(context);
    final double availableWidth =
        MediaQuery.sizeOf(context).width - insetPadding.horizontal;
    final double safeAvailableWidth = math.max(0.0, availableWidth);
    final double dialogWidth = math.min(
      context.layout.dialogMaxWidth,
      safeAvailableWidth,
    );
    return BoxConstraints(minWidth: dialogWidth, maxWidth: dialogWidth);
  }

  Color _resolveBackgroundColor(BuildContext context) {
    return switch (type) {
      DialogType.info => context.colorScheme.surface,
      DialogType.warning => context.colorScheme.surface,
      DialogType.error => context.colorScheme.surface,
      DialogType.confirm => context.colorScheme.surface,
    };
  }
}
