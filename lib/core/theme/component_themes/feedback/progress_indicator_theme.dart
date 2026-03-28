import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';

abstract final class lumosProgressIndicatorTheme {
  static ProgressIndicatorThemeData build(ColorScheme colorScheme) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: palette.controlTrack,
      circularTrackColor: palette.controlTrack,
    );
  }
}
