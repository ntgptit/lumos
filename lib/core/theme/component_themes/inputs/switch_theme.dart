import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosSwitchTheme {
  static SwitchThemeData build(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isLight ? colorScheme.onPrimary : AppColorTokens.darkPrimary;
        }
        return isLight ? colorScheme.outline : AppColorTokens.darkSurface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isLight
              ? colorScheme.primary
              : AppColorTokens.darkPrimaryContainerStrong;
        }
        return isLight
            ? colorScheme.surfaceContainerHighest
            : AppColorTokens.darkSurfaceContainerLow;
      }),
    );
  }
}
