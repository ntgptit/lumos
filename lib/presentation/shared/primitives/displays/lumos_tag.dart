import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosTag extends StatelessWidget {
  const LumosTag({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  final String label;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = textColor ?? context.colorScheme.onSurface;
    final resolvedIconSize =
        context.textTheme.labelSmall?.fontSize ?? context.iconSize.xs;

    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.xxs,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.radius.pill),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: IconTheme.merge(
        data: IconThemeData(size: resolvedIconSize, color: foregroundColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: context.spacing.xxs)],
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
