import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class LumosHeroBanner extends StatelessWidget {
  const LumosHeroBanner({
    required this.child,
    super.key,
    this.padding,
    this.minHeight,
    this.gradientColors,
    this.borderRadius,
    this.borderWidth = AppStroke.regular,
    this.showDecorativeBlob = true,
    this.decorativeBlobColor,
    this.showShadow = false,
    this.shadowBlurRadius = 48,
    this.shadowOffsetY = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;
  final List<Color>? gradientColors;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final bool showDecorativeBlob;
  final Color? decorativeBlobColor;
  final bool showShadow;
  final double shadowBlurRadius;
  final double shadowOffsetY;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final BorderRadius resolvedBorderRadius =
        borderRadius ?? context.shapes.hero;
    final List<Color> resolvedGradientColors =
        gradientColors ??
        <Color>[colorScheme.primaryContainer, colorScheme.surfaceContainer];
    final double blobOffset = context.compactValue(
      baseValue:
          context.spacing.xxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double blobSize = context.compactValue(
      baseValue: 96 + context.spacing.xxxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );

    return Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      decoration: BoxDecoration(
        borderRadius: resolvedBorderRadius,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: borderWidth,
        ),
        boxShadow: showShadow
            ? <BoxShadow>[
                BoxShadow(
                  color: colorScheme.shadow.withValues(
                    alpha: AppOpacity.subtle,
                  ),
                  blurRadius: shadowBlurRadius,
                  offset: Offset(0, shadowOffsetY),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: resolvedBorderRadius,
        child: LumosDecorativeBackground(
          gradientColors: resolvedGradientColors,
          blobs: showDecorativeBlob
              ? <LumosDecorativeBlob>[
                  LumosDecorativeBlob(
                    top: -blobOffset,
                    right: -blobOffset,
                    fill: decorativeBlobColor ?? colorScheme.tertiaryContainer,
                    size: blobSize,
                  ),
                ]
              : const <LumosDecorativeBlob>[],
          child: Padding(
            padding: padding ?? EdgeInsets.all(context.component.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
