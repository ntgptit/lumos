import 'package:flutter/material.dart';

import '../extensions/theme_extensions.dart';

abstract final class RadioThemes {
  static RadioThemeData build({required ColorScheme colorScheme}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContentColor;
        }
        if (states.isSelected) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
    );
  }
}
