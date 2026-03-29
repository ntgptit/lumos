import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';

class LumosDialogIcon extends StatelessWidget {
  const LumosDialogIcon(this.icon, {super.key}) : isDestructive = false;

  const LumosDialogIcon.destructive(this.icon, {super.key})
    : isDestructive = true;

  final IconData icon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _resolveBackgroundColor(context);
    final Color foregroundColor = _resolveForegroundColor(context);
    final double containerSize =
        context.component.chipHeight + context.spacing.sm;
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: context.shapes.pill,
      ),
      alignment: Alignment.center,
      child: LumosIcon(icon, size: context.iconSize.md, color: foregroundColor),
    );
  }

  Color _resolveBackgroundColor(BuildContext context) {
    if (isDestructive) {
      return context.colorScheme.errorContainer;
    }
    return context.colorScheme.primaryContainer;
  }

  Color _resolveForegroundColor(BuildContext context) {
    if (isDestructive) {
      return context.colorScheme.onErrorContainer;
    }
    return context.colorScheme.onPrimaryContainer;
  }
}
