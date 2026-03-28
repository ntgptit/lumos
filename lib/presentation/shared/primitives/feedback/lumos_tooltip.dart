import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosTooltip extends StatelessWidget {
  const LumosTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow,
    this.waitDuration,
    this.showDuration,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.excludeFromSemantics = false,
  });

  final String message;
  final Widget child;
  final bool? preferBelow;
  final Duration? waitDuration;
  final Duration? showDuration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: preferBelow ?? false,
      waitDuration: waitDuration,
      showDuration: showDuration,
      verticalOffset: verticalOffset ?? context.spacing.sm,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.xs,
          ),
      margin:
          margin ??
          EdgeInsets.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.sm,
          ),
      decoration: ShapeDecoration(
        color: context.colorScheme.inverseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
      ),
      textStyle: context.textTheme.labelMedium?.copyWith(
        color: context.colorScheme.onInverseSurface,
      ),
      excludeFromSemantics: excludeFromSemantics,
      child: child,
    );
  }
}
