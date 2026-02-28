import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class NavigationBarThemes {
  static NavigationBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return NavigationBarThemeData(
      elevation: WidgetSizes.none,
      backgroundColor: colorScheme.surface,
      labelTextStyle: WidgetStatePropertyAll<TextStyle?>(
        textTheme.labelSmall?.copyWith(color: colorScheme.onSurface),
      ),
      indicatorColor: colorScheme.secondaryContainer,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.onSecondaryContainer);
        }
        return IconThemeData(color: colorScheme.onSurfaceVariant);
      }),
      height: WidgetSizes.navigationBarHeight,
    );
  }
}
