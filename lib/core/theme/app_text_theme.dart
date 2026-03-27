import 'package:flutter/material.dart';

import '../themes/builders/app_text_theme_builder.dart';

abstract final class AppTextTheme {
  static TextTheme build({
    required Brightness brightness,
    required ColorScheme colorScheme,
  }) {
    return switch (brightness) {
      Brightness.light => light(colorScheme),
      Brightness.dark => dark(colorScheme),
    };
  }

  static TextTheme light(ColorScheme colorScheme) {
    return AppTextThemeBuilder.light(colorScheme);
  }

  static TextTheme dark(ColorScheme colorScheme) {
    return AppTextThemeBuilder.dark(colorScheme);
  }

  static TextTheme primary(ColorScheme colorScheme) {
    return AppTextThemeBuilder.primary(colorScheme);
  }
}
