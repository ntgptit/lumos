import 'package:flutter/material.dart';

import '../../themes/builders/app_content_component_theme_builder.dart';

abstract final class AppChipTheme {
  static ChipThemeData build({required ThemeData theme}) {
    return AppContentComponentThemeBuilder.chipTheme(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
    );
  }
}
