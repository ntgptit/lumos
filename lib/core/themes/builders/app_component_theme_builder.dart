import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../component/app_card_tokens.dart';
import '../component/app_dialog_tokens.dart';
import '../component/app_input_tokens.dart';
import '../component/app_navigation_bar_tokens.dart';
import 'app_button_style_builder.dart';
import 'app_content_component_theme_builder.dart';
import 'app_control_theme_builder.dart';
import 'app_dialog_theme_builder.dart';
import 'app_feedback_theme_builder.dart';
import 'app_input_theme_builder.dart';
import 'app_surface_theme_builder.dart';

final class AppComponentThemeBuilder {
  static ThemeData apply({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final AppButtonTokens buttonTokens =
        baseTheme.extension<AppButtonTokens>() ?? AppButtonTokens.defaults;
    final AppInputTokens inputTokens =
        baseTheme.extension<AppInputTokens>() ?? AppInputTokens.defaults;
    final AppCardTokens cardTokens =
        baseTheme.extension<AppCardTokens>() ?? AppCardTokens.defaults;
    final AppDialogTokens dialogTokens =
        baseTheme.extension<AppDialogTokens>() ?? AppDialogTokens.defaults;
    final AppNavigationBarTokens navigationBarTokens =
        baseTheme.extension<AppNavigationBarTokens>() ??
        AppNavigationBarTokens.defaults;

    final ThemeData foundationTheme = _applyFoundationThemes(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
      buttonTokens: buttonTokens,
      inputTokens: inputTokens,
      cardTokens: cardTokens,
      dialogTokens: dialogTokens,
    );
    return _applyInteractiveThemes(
      baseTheme: foundationTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
      navigationBarTokens: navigationBarTokens,
    );
  }

  static ThemeData _applyFoundationThemes({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
    required AppInputTokens inputTokens,
    required AppCardTokens cardTokens,
    required AppDialogTokens dialogTokens,
  }) {
    final ThemeData buttonTheme = _applyButtonThemes(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
      buttonTokens: buttonTokens,
    );
    return buttonTheme.copyWith(
      appBarTheme: AppSurfaceThemeBuilder.appBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      inputDecorationTheme: AppInputThemeBuilder.inputDecorationTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
        inputTokens: inputTokens,
      ),
      searchBarTheme: AppSurfaceThemeBuilder.searchBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      cardTheme: AppContentComponentThemeBuilder.cardTheme(
        colorScheme: colorScheme,
        cardTokens: cardTokens,
      ),
      dialogTheme: AppDialogThemeBuilder.dialogTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
        dialogTokens: dialogTokens,
      ),
      bottomSheetTheme: AppDialogThemeBuilder.bottomSheetTheme(
        colorScheme: colorScheme,
        dialogTokens: dialogTokens,
      ),
      dividerTheme: AppSurfaceThemeBuilder.dividerTheme(
        colorScheme: colorScheme,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }

  static ThemeData _applyButtonThemes({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppButtonTokens buttonTokens,
  }) {
    return baseTheme.copyWith(
      elevatedButtonTheme: AppButtonStyleBuilder.elevated(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
      outlinedButtonTheme: AppButtonStyleBuilder.outlined(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
      filledButtonTheme: AppButtonStyleBuilder.filled(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
      textButtonTheme: AppButtonStyleBuilder.text(
        colorScheme: colorScheme,
        textTheme: textTheme,
        buttonTokens: buttonTokens,
      ),
      iconButtonTheme: AppButtonStyleBuilder.icon(
        colorScheme: colorScheme,
        buttonTokens: buttonTokens,
      ),
    );
  }

  static ThemeData _applyInteractiveThemes({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppNavigationBarTokens navigationBarTokens,
  }) {
    return baseTheme.copyWith(
      bottomNavigationBarTheme: AppSurfaceThemeBuilder.bottomNavigationBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      navigationBarTheme: AppSurfaceThemeBuilder.navigationBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
        navigationBarTokens: navigationBarTokens,
      ),
      floatingActionButtonTheme:
          AppSurfaceThemeBuilder.floatingActionButtonTheme(
            colorScheme: colorScheme,
          ),
      chipTheme: AppContentComponentThemeBuilder.chipTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      listTileTheme: AppContentComponentThemeBuilder.listTileTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      switchTheme: AppControlThemeBuilder.switchTheme(colorScheme: colorScheme),
      checkboxTheme: AppControlThemeBuilder.checkboxTheme(
        colorScheme: colorScheme,
      ),
      radioTheme: AppControlThemeBuilder.radioTheme(colorScheme: colorScheme),
      sliderTheme: AppControlThemeBuilder.sliderTheme(colorScheme: colorScheme),
      progressIndicatorTheme: AppFeedbackThemeBuilder.progressIndicatorTheme(
        colorScheme: colorScheme,
      ),
      snackBarTheme: AppFeedbackThemeBuilder.snackBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );
  }
}
