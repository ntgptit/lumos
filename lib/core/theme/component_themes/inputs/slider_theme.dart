import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosSliderTheme {
  static SliderThemeData build(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;

    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: isLight
          ? colorScheme.surfaceContainerHighest
          : AppColorTokens.darkSurfaceContainerHigh,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(
        alpha: AppOpacityTokens.subtle,
      ),
    );
  }
}
