import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

abstract final class CheckboxThemes {
  static CheckboxThemeData build({required ColorScheme colorScheme}) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled && states.isSelected) {
          return colorScheme.disabledContentColor;
        }
        if (states.isSelected) {
          return colorScheme.primary;
        }
        return colorScheme.transparentSurfaceColor;
      }),
      checkColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContentColor;
        }
        return colorScheme.onPrimary;
      }),
      side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
        if (states.isSelected) {
          return BorderSide(
            color: colorScheme.outline.withValues(
              alpha: WidgetOpacities.transparent,
            ),
          );
        }
        if (states.isDisabled) {
          return BorderSide(color: colorScheme.disabledContentColor);
        }
        return BorderSide(color: colorScheme.outline);
      }),
    );
  }
}
