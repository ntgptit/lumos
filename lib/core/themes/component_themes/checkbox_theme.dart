import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class CheckboxThemes {
  static CheckboxThemeData build({required ColorScheme colorScheme}) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled) &&
            states.contains(WidgetState.selected)) {
          return colorScheme.onSurface.withValues(
            alpha: WidgetOpacities.disabledContent,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surface.withValues(
          alpha: WidgetOpacities.transparent,
        );
      }),
      checkColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(
            alpha: WidgetOpacities.disabledContent,
          );
        }
        return colorScheme.onPrimary;
      }),
      side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return BorderSide(
            color: colorScheme.outline.withValues(
              alpha: WidgetOpacities.transparent,
            ),
          );
        }
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colorScheme.onSurface.withValues(
              alpha: WidgetOpacities.disabledContent,
            ),
          );
        }
        return BorderSide(color: colorScheme.outline);
      }),
    );
  }
}
