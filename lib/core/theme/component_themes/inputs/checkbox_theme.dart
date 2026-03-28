import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';

abstract final class lumosCheckboxTheme {
  static CheckboxThemeData build(ColorScheme colorScheme) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return palette.surface;
      }),
      checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
      side: BorderSide(color: palette.outline),
    );
  }
}
