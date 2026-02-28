import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class AppBarThemeConst {
  static const bool centerTitle = false;
  static const double elevation = WidgetSizes.none;
  static const double scrolledUnderElevation = 3.0;
}

abstract final class AppBarThemes {
  static AppBarTheme build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return AppBarTheme(
      centerTitle: AppBarThemeConst.centerTitle,
      elevation: AppBarThemeConst.elevation,
      scrolledUnderElevation: AppBarThemeConst.scrolledUnderElevation,
      toolbarHeight: WidgetSizes.appBarHeight,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: colorScheme.surfaceTint,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }
}
