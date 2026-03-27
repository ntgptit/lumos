import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppResponsiveContainer extends StatelessWidget {
  const AppResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
    this.constrainWidth = true,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final bool constrainWidth;

  @override
  Widget build(BuildContext context) {
    final resolvedMaxWidth = maxWidth ?? context.layout.contentMaxWidth;
    final resolvedPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: context.layout.pageHorizontalPadding,
          vertical: context.layout.pageVerticalPadding,
        );

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: constrainWidth
            ? BoxConstraints(maxWidth: resolvedMaxWidth)
            : const BoxConstraints(),
        child: Padding(padding: resolvedPadding, child: child),
      ),
    );
  }
}
