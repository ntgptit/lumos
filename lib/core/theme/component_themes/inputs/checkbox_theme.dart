import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosCheckboxTheme {
  static CheckboxThemeData build(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;

    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return isLight ? colorScheme.surface : AppColorTokens.darkSurface;
      }),
      checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
      side: BorderSide(
        color: isLight
            ? colorScheme.outlineVariant
            : AppColorTokens.darkOutline,
      ),
    );
  }
}
