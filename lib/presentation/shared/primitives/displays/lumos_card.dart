import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/foundation/app_motion.dart';

enum LumosCardVariant { elevated, filled, outlined }

abstract final class _LumosCardConst {
  static const double pressedScale = 0.97;
}

class LumosCard extends StatefulWidget {
  const LumosCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.minHeight,
    this.variant = LumosCardVariant.elevated,
    this.borderRadius,
    this.isSelected = false,
    this.elevation,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? minHeight;
  final LumosCardVariant variant;
  final BorderRadiusGeometry? borderRadius;
  final bool isSelected;
  final double? elevation;
  final VoidCallback? onTap;

  @override
  State<LumosCard> createState() => _LumosCardState();
}

class _LumosCardState extends State<LumosCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final resolvedBorderRadius = widget.borderRadius is BorderRadius
        ? widget.borderRadius! as BorderRadius
        : context.shapes.card;
    final childWidget = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? context.component.cardMinHeight,
      ),
      child: Padding(
        padding:
            widget.padding ?? EdgeInsets.all(context.component.cardPadding),
        child: widget.child,
      ),
    );

    final content = widget.onTap == null
        ? childWidget
        : InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (bool highlighted) {
              setState(() => _pressed = highlighted);
            },
            borderRadius: resolvedBorderRadius,
            child: childWidget,
          );

    final card = Card(
      margin: widget.margin,
      elevation:
          widget.elevation ??
          (widget.variant == LumosCardVariant.elevated ? null : 0),
      clipBehavior: Clip.antiAlias,
      color: switch (widget.variant) {
        LumosCardVariant.filled => context.colorScheme.surfaceContainerHighest,
        _ => null,
      },
      shape: RoundedRectangleBorder(
        borderRadius: resolvedBorderRadius,
        side: widget.variant == LumosCardVariant.outlined || widget.isSelected
            ? BorderSide(
                color: widget.isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outlineVariant,
              )
            : BorderSide.none,
      ),
      child: content,
    );

    if (widget.onTap == null) {
      return card;
    }

    return AnimatedScale(
      scale: _pressed ? _LumosCardConst.pressedScale : 1.0,
      duration: AppMotion.fast,
      curve: AppMotion.standardCurve,
      child: card,
    );
  }
}
