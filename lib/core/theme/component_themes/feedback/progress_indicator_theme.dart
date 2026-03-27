import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosProgressIndicatorTheme {
  static ProgressIndicatorThemeData build(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;

    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: isLight
          ? colorScheme.surfaceContainerHighest
          : AppColorTokens.darkSurfaceContainerHigh,
      circularTrackColor: isLight
          ? colorScheme.surfaceContainerHighest
          : AppColorTokens.darkSurfaceContainerHigh,
    );
  }
}
