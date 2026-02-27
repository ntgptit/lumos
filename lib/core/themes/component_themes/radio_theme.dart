import 'package:flutter/material.dart';

class RadioThemes {
  const RadioThemes._();

  static RadioThemeData build({required ColorScheme colorScheme}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
    );
  }
}
