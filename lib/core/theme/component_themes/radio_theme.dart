import 'package:flutter/material.dart';

import '../../themes/builders/app_control_theme_builder.dart';

abstract final class AppRadioTheme {
  static RadioThemeData build({required ThemeData theme}) {
    return AppControlThemeBuilder.radioTheme(colorScheme: theme.colorScheme);
  }
}
