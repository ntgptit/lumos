import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class AppBarThemeConst {
  static const bool centerTitle = true;
}

abstract final class AppBarThemes {
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
