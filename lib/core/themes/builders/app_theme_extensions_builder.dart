import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../component/app_card_tokens.dart';
import '../component/app_dialog_tokens.dart';
import '../component/app_input_tokens.dart';
import '../component/app_navigation_bar_tokens.dart';
import '../semantic/app_color_tokens.dart';
import '../semantic/app_text_tokens.dart';

final class AppThemeExtensionsBuilder {
  static List<ThemeExtension<dynamic>> light(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return _build(colorScheme: colorScheme, textTheme: textTheme);
  }

  static List<ThemeExtension<dynamic>> dark(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return _build(colorScheme: colorScheme, textTheme: textTheme);
  }

  static List<ThemeExtension<dynamic>> _build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return <ThemeExtension<dynamic>>[
      AppColorTokens.fromColorScheme(colorScheme: colorScheme),
      AppTextTokens.fromTheme(colorScheme: colorScheme, textTheme: textTheme),
      AppButtonTokens.defaults,
      AppInputTokens.defaults,
      AppCardTokens.defaults,
      AppDialogTokens.defaults,
      AppNavigationBarTokens.defaults,
    ];
  }
}
