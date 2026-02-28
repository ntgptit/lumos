import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class RadioThemes {
  static RadioThemeData build({required ColorScheme colorScheme}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(
            alpha: WidgetOpacities.disabledContent,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withValues(
            alpha: WidgetOpacities.statePress,
          );
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.primary.withValues(
            alpha: WidgetOpacities.stateHover,
          );
        }
        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary.withValues(
            alpha: WidgetOpacities.stateFocus,
          );
        }
        return null;
      }),
    );
  }
}
