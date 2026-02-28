import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class SwitchThemes {
  static SwitchThemeData build({required ColorScheme colorScheme}) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerHighest;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primaryContainer;
        }
        return colorScheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary.withValues(
            alpha: WidgetOpacities.stateFocus,
          );
        }
        return colorScheme.outlineVariant;
      }),
    );
  }
}
