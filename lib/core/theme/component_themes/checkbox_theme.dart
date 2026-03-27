import 'package:flutter/material.dart';

import '../../themes/builders/app_control_theme_builder.dart';

abstract final class AppCheckboxTheme {
  static CheckboxThemeData build({required ThemeData theme}) {
    return AppControlThemeBuilder.checkboxTheme(colorScheme: theme.colorScheme);
  }
}
