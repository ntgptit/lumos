import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';

abstract final class LumosSegmentedButtonTheme {
  static SegmentedButtonThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
    TextTheme textTheme,
  ) {
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
        side: WidgetStatePropertyAll(BorderSide(color: colorScheme.outline)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondaryContainer;
          }
          return colorScheme.surfaceContainerHigh;
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
