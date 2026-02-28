import 'package:flutter/material.dart';

import 'semantic_colors_extension.dart';

export 'color_scheme_state_extensions.dart';
export 'semantic_colors_extension.dart';
export 'typography_extensions.dart';
export 'widget_state_extensions.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  TextStyle? get headlineSmall => textTheme.headlineSmall;

  TextStyle? get bodyMedium => textTheme.bodyMedium;

  AppBarThemeData get appBarTheme => theme.appBarTheme;

  ElevatedButtonThemeData get elevatedButtonTheme => theme.elevatedButtonTheme;

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      theme.bottomNavigationBarTheme;

  NavigationBarThemeData get navigationBarTheme => theme.navigationBarTheme;

  AppSemanticColors get semanticColors {
    final AppSemanticColors? colors = theme.extension<AppSemanticColors>();
    if (colors != null) {
      return colors;
    }
    return AppSemanticColors.fromColorScheme(colorScheme: colorScheme);
  }
}

extension ColorSchemeCompatibilityExtension on ColorScheme {
  // Compatibility alias to keep project contract naming stable.
  Color get inverseOnSurface => onInverseSurface;
}
