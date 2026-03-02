import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../component/app_card_tokens.dart';
import '../component/app_dialog_tokens.dart';
import '../component/app_input_tokens.dart';
import '../component/app_navigation_bar_tokens.dart';
import '../component/app_theme_contract_tokens.dart';
import '../semantic/app_color_tokens.dart';
import '../semantic/app_text_tokens.dart';

@immutable
final class AppThemeExtensionsBundle {
  const AppThemeExtensionsBundle({
    required this.contractTokens,
    required this.colorTokens,
    required this.textTokens,
    required this.buttonTokens,
    required this.inputTokens,
    required this.cardTokens,
    required this.dialogTokens,
    required this.navigationBarTokens,
  });

  final AppThemeContractTokens contractTokens;
  final AppColorTokens colorTokens;
  final AppTextTokens textTokens;
  final AppButtonTokens buttonTokens;
  final AppInputTokens inputTokens;
  final AppCardTokens cardTokens;
  final AppDialogTokens dialogTokens;
  final AppNavigationBarTokens navigationBarTokens;

  List<ThemeExtension<dynamic>> toThemeExtensions() {
    final List<ThemeExtension<dynamic>> extensions = <ThemeExtension<dynamic>>[
      contractTokens,
      colorTokens,
      textTokens,
      buttonTokens,
      inputTokens,
      cardTokens,
      dialogTokens,
      navigationBarTokens,
    ];

    assert(() {
      final int extensionCount = extensions.length;
      final int uniqueTypeCount = extensions
          .map((ThemeExtension<dynamic> extension) => extension.runtimeType)
          .toSet()
          .length;
      if (extensionCount == uniqueTypeCount) {
        return true;
      }
      throw FlutterError(
        'Theme extension contract violated: duplicate runtimeType detected.',
      );
    }());

    return List<ThemeExtension<dynamic>>.unmodifiable(extensions);
  }
}

abstract final class AppThemeExtensionsBuilder {
  static AppThemeExtensionsBundle light(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return _build(colorScheme: colorScheme, textTheme: textTheme);
  }

  static AppThemeExtensionsBundle dark(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return _build(colorScheme: colorScheme, textTheme: textTheme);
  }

  static AppThemeExtensionsBundle _build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return AppThemeExtensionsBundle(
      contractTokens: AppThemeContractTokens.defaults,
      colorTokens: AppColorTokens.fromColorScheme(colorScheme: colorScheme),
      textTokens: AppTextTokens.fromTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      buttonTokens: AppButtonTokens.defaults,
      inputTokens: AppInputTokens.defaults,
      cardTokens: AppCardTokens.defaults,
      dialogTokens: AppDialogTokens.defaults,
      navigationBarTokens: AppNavigationBarTokens.defaults,
    );
  }
}
