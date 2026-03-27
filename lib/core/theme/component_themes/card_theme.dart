import 'package:flutter/material.dart';

import '../../themes/builders/app_content_component_theme_builder.dart';
import '../extensions/component_theme_ext.dart';

abstract final class AppCardTheme {
  static CardThemeData build({required ThemeData theme}) {
    final ComponentThemeExt componentTheme =
        theme.extension<ComponentThemeExt>() ??
        ComponentThemeExt.fromTheme(theme);
    return AppContentComponentThemeBuilder.cardTheme(
      colorScheme: theme.colorScheme,
      cardTokens: componentTheme.card,
    );
  }
}
