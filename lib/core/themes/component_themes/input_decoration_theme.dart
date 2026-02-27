import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class InputDecorationThemeConst {
  const InputDecorationThemeConst._();

  static const bool filled = true;
}

class InputDecorationThemes {
  const InputDecorationThemes._();

  static InputDecorationTheme build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final OutlineInputBorder baseBorder = AppShape.inputShape(
      borderColor: colorScheme.outline,
    );
    final OutlineInputBorder focusedBorder = baseBorder.copyWith(
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: WidgetSizes.borderWidthRegular,
      ),
    );
    return InputDecorationTheme(
      filled: InputDecorationThemeConst.filled,
      fillColor: colorScheme.onSurface.withValues(
        alpha: WidgetSizes.inputFillOpacity,
      ),
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: focusedBorder,
      labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
      errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
    );
  }
}
