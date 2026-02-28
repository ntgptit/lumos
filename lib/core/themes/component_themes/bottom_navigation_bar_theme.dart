import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class BottomNavigationBarThemeConst {
  static const bool showUnselectedLabels = true;
  static const BottomNavigationBarType type = BottomNavigationBarType.fixed;
  static const double elevation = 0.0;
}

abstract final class BottomNavigationBarThemes {
  static BottomNavigationBarThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return BottomNavigationBarThemeData(
      elevation: BottomNavigationBarThemeConst.elevation,
      showUnselectedLabels: BottomNavigationBarThemeConst.showUnselectedLabels,
      type: BottomNavigationBarThemeConst.type,
      backgroundColor: colorScheme.surfaceContainer,
      selectedItemColor: colorScheme.onSecondaryContainer,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      selectedIconTheme: IconThemeData(size: IconSizes.iconBottomNavBar),
      unselectedIconTheme: IconThemeData(size: IconSizes.iconBottomNavBar),
      selectedLabelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSecondaryContainer,
      ),
      unselectedLabelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
