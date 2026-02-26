import 'package:flutter/material.dart';

import '../../constants/dimensions.dart';

class BottomNavigationBarThemeConst {
  const BottomNavigationBarThemeConst._();

  static const bool showUnselectedLabels = true;
  static const BottomNavigationBarType type = BottomNavigationBarType.fixed;
}

class BottomNavigationBarThemes {
  const BottomNavigationBarThemes._();

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
