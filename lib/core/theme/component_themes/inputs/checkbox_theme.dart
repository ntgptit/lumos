import 'package:flutter/material.dart';

abstract final class LumosCheckboxTheme {
  static CheckboxThemeData build(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surface;
      }),
      checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
      side: BorderSide(color: colorScheme.outline),
    );
  }
}
