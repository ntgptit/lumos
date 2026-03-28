import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

enum LumosCardVariant { elevated, filled, outlined }

class LumosCard extends StatelessWidget {
  const LumosCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.variant = LumosCardVariant.elevated,
    this.borderRadius,
    this.isSelected = false,
    this.elevation,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final LumosCardVariant variant;
  final BorderRadiusGeometry? borderRadius;
  final bool isSelected;
  final double? elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderRadius = borderRadius is BorderRadius
        ? borderRadius! as BorderRadius
        : BorderRadius.circular(context.radius.lg);
    final childWidget = ConstrainedBox(
      constraints: BoxConstraints(minHeight: context.component.cardMinHeight),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.component.cardPadding),
        child: child,
      ),
    );

    final content = onTap == null
        ? childWidget
        : InkWell(
            onTap: onTap,
            borderRadius: resolvedBorderRadius,
            child: childWidget,
          );

    return Card(
      margin: margin,
      elevation:
          elevation ?? (variant == LumosCardVariant.elevated ? null : 0),
      clipBehavior: Clip.antiAlias,
      color: switch (variant) {
        LumosCardVariant.filled => context.colorScheme.surfaceContainerHighest,
        _ => null,
      },
      shape: RoundedRectangleBorder(
        borderRadius: resolvedBorderRadius,
        side: variant == LumosCardVariant.outlined || isSelected
            ? BorderSide(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outlineVariant,
              )
            : BorderSide.none,
      ),
      child: content,
    );
  }
}
