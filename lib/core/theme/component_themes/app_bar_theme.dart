import 'package:flutter/material.dart';

import '../../themes/builders/app_surface_theme_builder.dart';

abstract final class AppBarThemeFactory {
  static AppBarTheme build({required ThemeData theme}) {
    return AppSurfaceThemeBuilder.appBarTheme(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
    );
  }
}
