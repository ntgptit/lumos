import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderColor,
  });

  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.radius.pill),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Padding(
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: context.spacing.md,
              vertical: context.spacing.xs,
            ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: foregroundColor ?? context.colorScheme.onSurface,
          ),
          child: child,
        ),
      ),
    );
  }
}
