import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosSliderTheme {
  static SliderThemeData build(ColorScheme colorScheme) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: palette.controlTrack,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(
        alpha: AppOpacityTokens.subtle,
      ),
    );
  }
}
