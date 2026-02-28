import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class BottomNavigationBarThemeConst {
  static const bool showUnselectedLabels = true;
  static const BottomNavigationBarType type = BottomNavigationBarType.fixed;
}

abstract final class BottomNavigationBarThemes {
  static BottomNavigationBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return BottomNavigationBarThemeData(
      elevation: WidgetSizes.none,
      showUnselectedLabels: BottomNavigationBarThemeConst.showUnselectedLabels,
      type: BottomNavigationBarThemeConst.type,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      selectedLabelStyle: textTheme.labelSmall,
      unselectedLabelStyle: textTheme.labelSmall,
    );
  }
}
