import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class SwitchThemes {
  static SwitchThemeData build({required ColorScheme colorScheme}) {
    return SwitchThemeData(
      thumbColor: _thumbColor(colorScheme: colorScheme),
      trackColor: _trackColor(colorScheme: colorScheme),
      trackOutlineColor: _trackOutlineColor(colorScheme: colorScheme),
      overlayColor: _overlayColor(colorScheme: colorScheme),
    );
  }

  static WidgetStateProperty<Color?> _thumbColor({
    required ColorScheme colorScheme,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colorScheme.onSurface.withValues(
          alpha: WidgetOpacities.disabledContent,
        );
      }
      if (states.contains(WidgetState.selected)) return colorScheme.onPrimary;
      return colorScheme.outline;
    });
  }

  static WidgetStateProperty<Color?> _trackColor({
    required ColorScheme colorScheme,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colorScheme.onSurface.withValues(alpha: WidgetOpacities.divider);
      }
      if (states.contains(WidgetState.selected)) return colorScheme.primary;
      return colorScheme.surfaceContainerHighest;
    });
  }

  static WidgetStateProperty<Color?> _trackOutlineColor({
    required ColorScheme colorScheme,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary.withValues(
          alpha: WidgetOpacities.transparent,
        );
      }
      if (states.contains(WidgetState.disabled)) {
        return colorScheme.onSurface.withValues(
          alpha: WidgetOpacities.disabledContent,
        );
      }
      return colorScheme.outline;
    });
  }

  static WidgetStateProperty<Color?> _overlayColor({
    required ColorScheme colorScheme,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
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
    });
  }
}
