import 'package:flutter/material.dart';

class CheckboxThemes {
  const CheckboxThemes._();

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
