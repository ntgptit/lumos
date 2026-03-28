import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';

abstract final class LumosSegmentedButtonTheme {
  static SegmentedButtonThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
    TextTheme textTheme,
  ) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        iconSize: WidgetStatePropertyAll(dims.iconSize.md),
        minimumSize: WidgetStatePropertyAll(
          Size(0, dims.componentSize.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: dims.shapes.control),
        ),
        side: WidgetStatePropertyAll(BorderSide(color: palette.outline)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSecondaryContainer;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }
}
