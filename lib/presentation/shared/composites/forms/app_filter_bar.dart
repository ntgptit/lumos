import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_surface.dart';

class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    super.key,
    required this.filters,
    this.title,
    this.leading,
    this.trailing,
    this.clearAction,
    this.padding,
    this.spacing,
    this.runSpacing,
    this.backgroundColor,
  });

  final List<Widget> filters;
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? clearAction;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final double? runSpacing;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? context.spacing.sm;
    final lineGap = runSpacing ?? context.spacing.sm;
    final hasHeader =
        title != null ||
        leading != null ||
        trailing != null ||
        clearAction != null;

    return AppSurface(
      color: backgroundColor ?? context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasHeader) ...[
              Row(
                children: [
                  if (leading != null) ...[leading!, SizedBox(width: gap)],
                  if (title != null) Expanded(child: title!),
                  if (trailing != null) ...[SizedBox(width: gap), trailing!],
                  if (clearAction != null) ...[
                    SizedBox(width: gap),
                    clearAction!,
                  ],
                ],
              ),
              SizedBox(height: lineGap),
            ],
            Wrap(spacing: gap, runSpacing: lineGap, children: filters),
          ],
        ),
      ),
    );
  }
}
