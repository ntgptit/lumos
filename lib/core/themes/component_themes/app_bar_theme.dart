import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

class AppBarThemeConst {
  const AppBarThemeConst._();

  static const bool centerTitle = true;
}

class AppBarThemes {
  const AppBarThemes._();

  static AppBarTheme build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return AppBarTheme(
      centerTitle: AppBarThemeConst.centerTitle,
      elevation: WidgetSizes.none,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      scrolledUnderElevation: WidgetSizes.none,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }
}
