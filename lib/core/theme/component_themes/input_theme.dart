import 'package:flutter/material.dart';

import '../../themes/builders/app_input_theme_builder.dart';
import '../extensions/component_theme_ext.dart';

abstract final class AppInputTheme {
  static InputDecorationTheme build({required ThemeData theme}) {
    final ComponentThemeExt componentTheme =
        theme.extension<ComponentThemeExt>() ??
        ComponentThemeExt.fromTheme(theme);
    return AppInputThemeBuilder.inputDecorationTheme(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      inputTokens: componentTheme.input,
    );
  }
}
