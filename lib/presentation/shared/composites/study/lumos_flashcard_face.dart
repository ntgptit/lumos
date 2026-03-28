import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_surface.dart';

class LumosFlashcardFace extends StatelessWidget {
  const LumosFlashcardFace({
    super.key,
    required this.front,
    required this.back,
    required this.isRevealed,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.minHeight,
    this.elevation,
    this.duration = AppMotionTokens.medium,
    this.curve = AppMotionTokens.standardCurve,
  });

  final Widget front;
  final Widget back;
  final bool isRevealed;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? minHeight;
  final double? elevation;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final resolvedRadius = borderRadius ?? context.shapes.hero;
    final resolvedPadding =
        padding ?? EdgeInsets.all(context.component.cardPadding);
    final resolvedMinHeight = minHeight ?? context.component.cardMinHeight;

    return LumosSurface(
      elevation: elevation ?? 0,
      shape: RoundedRectangleBorder(borderRadius: resolvedRadius),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: resolvedMinHeight),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: resolvedPadding,
              child: AnimatedCrossFade(
                firstChild: Align(alignment: Alignment.topLeft, child: front),
                secondChild: Align(alignment: Alignment.topLeft, child: back),
                crossFadeState: isRevealed
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: duration,
                sizeCurve: curve,
                firstCurve: curve,
                secondCurve: curve,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
