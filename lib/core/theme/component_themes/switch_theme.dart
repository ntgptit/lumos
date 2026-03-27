import 'package:flutter/material.dart';

import '../../themes/builders/app_control_theme_builder.dart';

abstract final class AppSwitchTheme {
  static SwitchThemeData build({required ThemeData theme}) {
    return AppControlThemeBuilder.switchTheme(colorScheme: theme.colorScheme);
  }
}
