import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

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
      if (states.isDisabled) {
        return colorScheme.disabledContentColor;
      }
      if (states.isSelected) {
        return colorScheme.onPrimary;
      }
      return colorScheme.outline;
    });
  }

  static WidgetStateProperty<Color?> _trackColor({
    required ColorScheme colorScheme,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.isDisabled) {
        return colorScheme.disabledContainerColor;
      }
      if (states.isSelected) {
        return colorScheme.primary;
      }
      return colorScheme.surfaceContainerHighest;
    });
  }

  static WidgetStateProperty<Color?> _trackOutlineColor({
    required ColorScheme colorScheme,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.isSelected) {
        return colorScheme.primary.withValues(
          alpha: WidgetOpacities.transparent,
        );
      }
      if (states.isDisabled) {
        return colorScheme.disabledContentColor;
      }
      return colorScheme.outline;
    });
  }

  static WidgetStateProperty<Color?> _overlayColor({
    required ColorScheme colorScheme,
  }) {
    return colorScheme.primary.asInteractiveOverlayProperty();
  }
}
