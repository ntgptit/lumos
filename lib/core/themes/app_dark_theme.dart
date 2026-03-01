import 'package:flutter/material.dart';

import 'builders/app_color_scheme_builder.dart';
import 'builders/app_component_theme_builder.dart';
import 'builders/app_text_theme_builder.dart';
import 'builders/app_theme_extensions_builder.dart';
import '../constants/dimensions.dart';

final class AppDarkTheme {
  static ThemeData build({Color? seedColor}) {
    final ColorScheme colorScheme = AppColorSchemeBuilder.dark(
      seedColor: seedColor,
    );
    final TextTheme textTheme = AppTextThemeBuilder.dark(colorScheme);
    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryTextTheme: AppTextThemeBuilder.primary(colorScheme),
      visualDensity: const VisualDensity(
        horizontal: WidgetSizes.none,
        vertical: WidgetSizes.none,
      ),
      extensions: AppThemeExtensionsBuilder.dark(colorScheme, textTheme),
    );
    return AppComponentThemeBuilder.apply(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }
}
