import 'package:flutter/material.dart';

import '../../themes/builders/app_button_style_builder.dart';
import '../extensions/component_theme_ext.dart';

abstract final class AppButtonTheme {
  static ElevatedButtonThemeData elevated({required ThemeData theme}) {
    final ComponentThemeExt componentTheme = _componentTheme(theme);
    return AppButtonStyleBuilder.elevated(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      buttonTokens: componentTheme.button,
    );
  }

  static FilledButtonThemeData filled({required ThemeData theme}) {
    final ComponentThemeExt componentTheme = _componentTheme(theme);
    return AppButtonStyleBuilder.filled(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      buttonTokens: componentTheme.button,
    );
  }

  static OutlinedButtonThemeData outlined({required ThemeData theme}) {
    final ComponentThemeExt componentTheme = _componentTheme(theme);
    return AppButtonStyleBuilder.outlined(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      buttonTokens: componentTheme.button,
    );
  }

  static TextButtonThemeData text({required ThemeData theme}) {
    final ComponentThemeExt componentTheme = _componentTheme(theme);
    return AppButtonStyleBuilder.text(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      buttonTokens: componentTheme.button,
    );
  }

  static IconButtonThemeData icon({required ThemeData theme}) {
    final ComponentThemeExt componentTheme = _componentTheme(theme);
    return AppButtonStyleBuilder.icon(
      colorScheme: theme.colorScheme,
      buttonTokens: componentTheme.button,
    );
  }

  static ComponentThemeExt _componentTheme(ThemeData theme) {
    return theme.extension<ComponentThemeExt>() ??
        ComponentThemeExt.fromTheme(theme);
  }
}
