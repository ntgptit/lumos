import 'package:flutter/material.dart';

abstract final class CheckboxThemes {
  static CheckboxThemeData build({required ColorScheme colorScheme}) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerHighest;
      }),
      checkColor: WidgetStatePropertyAll<Color>(colorScheme.onPrimary),
      side: BorderSide(color: colorScheme.outline),
    );
  }
}
