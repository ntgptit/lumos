import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class NavigationBarThemes {
  static NavigationBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return NavigationBarThemeData(
      elevation: WidgetSizes.none,
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: colorScheme.secondaryContainer,
      height: WidgetSizes.navigationBarHeight,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelMedium?.copyWith(
            color: colorScheme.onSecondaryContainer,
          );
        }
        return textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.onSecondaryContainer);
        }
        return IconThemeData(color: colorScheme.onSurfaceVariant);
      }),
    );
  }
}
