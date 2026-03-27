import 'package:flutter/material.dart';

import '../../themes/builders/app_control_theme_builder.dart';

abstract final class AppSliderTheme {
  static SliderThemeData build({required ThemeData theme}) {
    return AppControlThemeBuilder.sliderTheme(colorScheme: theme.colorScheme);
  }
}
