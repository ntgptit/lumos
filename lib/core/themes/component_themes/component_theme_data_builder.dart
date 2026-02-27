import 'package:flutter/material.dart';

import '../extensions/semantic_colors_extension.dart';
import 'app_bar_theme.dart';
import 'bottom_navigation_bar_theme.dart';
import 'button_theme.dart';
import 'card_theme.dart';
import 'checkbox_theme.dart';
import 'chip_theme.dart';
import 'dialog_theme.dart';
import 'divider_theme.dart';
import 'floating_action_button_theme.dart';
import 'input_decoration_theme.dart';
import 'list_tile_theme.dart';
import 'navigation_bar_theme.dart';
import 'progress_indicator_theme.dart';
import 'radio_theme.dart';
import 'scaffold_theme.dart';
import 'slider_theme.dart';
import 'snack_bar_theme.dart';
import 'switch_theme.dart';

class ComponentThemeDataBuilder {
  const ComponentThemeDataBuilder._();

  static ThemeData apply({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final List<ThemeExtension<dynamic>> extensions = _buildThemeExtensions(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
    );
    final ThemeData foundationTheme = _applyFoundationThemes(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: extensions,
    );
    return _applyInteractiveThemes(
      baseTheme: foundationTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static ThemeData _applyFoundationThemes({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required List<ThemeExtension<dynamic>> extensions,
  }) {
    return baseTheme.copyWith(
      extensions: extensions,
      appBarTheme: AppBarThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      elevatedButtonTheme: ButtonThemes.elevated(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      outlinedButtonTheme: ButtonThemes.outlined(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      filledButtonTheme: ButtonThemes.filled(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      textButtonTheme: ButtonThemes.text(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      inputDecorationTheme: InputDecorationThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      cardTheme: CardThemes.build(colorScheme: colorScheme),
      dialogTheme: DialogThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      dividerTheme: DividerThemes.build(colorScheme: colorScheme),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      scaffoldBackgroundColor: ScaffoldThemes.backgroundColor(
        colorScheme: colorScheme,
      ),
    );
  }

  static ThemeData _applyInteractiveThemes({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return baseTheme.copyWith(
      bottomNavigationBarTheme: BottomNavigationBarThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      navigationBarTheme: NavigationBarThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      chipTheme: ChipThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      listTileTheme: ListTileThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      switchTheme: SwitchThemes.build(colorScheme: colorScheme),
      checkboxTheme: CheckboxThemes.build(colorScheme: colorScheme),
      radioTheme: RadioThemes.build(colorScheme: colorScheme),
      sliderTheme: SliderThemes.build(colorScheme: colorScheme),
      progressIndicatorTheme: ProgressIndicatorThemes.build(
        colorScheme: colorScheme,
      ),
      snackBarTheme: SnackBarThemes.build(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );
  }

  static List<ThemeExtension<dynamic>> _buildThemeExtensions({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
  }) {
    final List<ThemeExtension<dynamic>> baseExtensions = baseTheme
        .extensions
        .values
        .where((ThemeExtension<dynamic> extension) {
          return extension is! AppSemanticColors;
        })
        .toList(growable: true);

    baseExtensions.add(
      AppSemanticColors.fromColorScheme(colorScheme: colorScheme),
    );
    return baseExtensions;
  }
}
