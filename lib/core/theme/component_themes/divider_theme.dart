import 'package:flutter/material.dart';

import '../../themes/builders/app_surface_theme_builder.dart';

abstract final class AppDividerTheme {
  static DividerThemeData build({required ThemeData theme}) {
    return AppSurfaceThemeBuilder.dividerTheme(colorScheme: theme.colorScheme);
  }
}
