import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';

abstract final class LumosSwitchTheme {
  static SwitchThemeData build(ColorScheme colorScheme) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.switchSelectedThumb;
        }
        return palette.switchUnselectedThumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.switchSelectedTrack;
        }
        return palette.switchUnselectedTrack;
      }),
    );
  }
}
