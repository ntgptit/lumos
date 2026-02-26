import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import 'component_themes/app_bar_theme.dart';
import 'component_themes/bottom_navigation_bar_theme.dart';
import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/dialog_theme.dart';
import 'component_themes/input_decoration_theme.dart';
import 'component_themes/navigation_bar_theme.dart';
import 'color_schemes.dart';
import 'typography.dart';

class AppThemeConst {
  const AppThemeConst._();

  static const String allowNoDynamicColorMarker =
      'theme-guard: allow-no-dynamic-color';
  static const TargetPlatform iosPlatform = TargetPlatform.iOS;
  static const TargetPlatform macOsPlatform = TargetPlatform.macOS;
  static const TargetPlatform androidPlatform = TargetPlatform.android;
  static const TargetPlatform linuxPlatform = TargetPlatform.linux;
  static const TargetPlatform windowsPlatform = TargetPlatform.windows;
  static const TargetPlatform fuchsiaPlatform = TargetPlatform.fuchsia;
}

class AppTheme {
  const AppTheme._();

  // theme-guard: allow-no-dynamic-color
  static ThemeData lightTheme({Color? seedColor}) {
    return _buildThemeData(
      colorScheme: buildLightColorScheme(seedColor: seedColor),
    );
  }

  // theme-guard: allow-no-dynamic-color
  static ThemeData darkTheme({Color? seedColor}) {
    return _buildThemeData(
      colorScheme: buildDarkColorScheme(seedColor: seedColor),
    );
  }

  static ThemeData _buildThemeData({required ColorScheme colorScheme}) {
    final TextTheme textTheme = AppTypography.textTheme(
      colorScheme: colorScheme,
    );
    final TextTheme primaryTextTheme = AppTypography.primaryTextTheme(
      colorScheme: colorScheme,
    );
    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      pageTransitionsTheme: _buildPageTransitionsTheme(),
      visualDensity: const VisualDensity(
        horizontal: WidgetSizes.none,
        vertical: WidgetSizes.none,
      ),
    );
    return _buildComponentThemeData(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static ThemeData _buildComponentThemeData({
    required ThemeData baseTheme,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final _ButtonThemeBundle buttonThemes = _buildButtonThemes(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
    return _copyWithComponentThemeData(
      baseTheme: baseTheme,
      buttonThemes: buttonThemes,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static ThemeData _copyWithComponentThemeData({
    required ThemeData baseTheme,
    required _ButtonThemeBundle buttonThemes,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return baseTheme.copyWith(
      appBarTheme: _buildAppBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      elevatedButtonTheme: buttonThemes.elevatedButtonTheme,
      outlinedButtonTheme: buttonThemes.outlinedButtonTheme,
      filledButtonTheme: buttonThemes.filledButtonTheme,
      textButtonTheme: buttonThemes.textButtonTheme,
      inputDecorationTheme: _buildInputDecorationTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      cardTheme: CardThemes.build(colorScheme: colorScheme),
      dialogTheme: _buildDialogTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      navigationBarTheme: _buildNavigationBarTheme(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );
  }

  static PageTransitionsTheme _buildPageTransitionsTheme() {
    // Keep Cupertino transition on Apple platforms, Material transition elsewhere.
    return const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        AppThemeConst.iosPlatform: CupertinoPageTransitionsBuilder(),
        AppThemeConst.macOsPlatform: CupertinoPageTransitionsBuilder(),
        AppThemeConst.androidPlatform: FadeUpwardsPageTransitionsBuilder(),
        AppThemeConst.linuxPlatform: FadeUpwardsPageTransitionsBuilder(),
        AppThemeConst.windowsPlatform: FadeUpwardsPageTransitionsBuilder(),
        AppThemeConst.fuchsiaPlatform: FadeUpwardsPageTransitionsBuilder(),
      },
    );
  }

  static AppBarTheme _buildAppBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return AppBarThemes.build(colorScheme: colorScheme, textTheme: textTheme);
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return InputDecorationThemes.build(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static DialogThemeData _buildDialogTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return DialogThemes.build(colorScheme: colorScheme, textTheme: textTheme);
  }

  static NavigationBarThemeData _buildNavigationBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return NavigationBarThemes.build(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return BottomNavigationBarThemes.build(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static _ButtonThemeBundle _buildButtonThemes({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final ElevatedButtonThemeData elevatedButtonTheme = ButtonThemes.elevated(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
    final OutlinedButtonThemeData outlinedButtonTheme = ButtonThemes.outlined(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
    final FilledButtonThemeData filledButtonTheme = ButtonThemes.filled(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
    final TextButtonThemeData textButtonTheme = ButtonThemes.text(
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
    return _ButtonThemeBundle(
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      filledButtonTheme: filledButtonTheme,
      textButtonTheme: textButtonTheme,
    );
  }
}

class _ButtonThemeBundle {
  const _ButtonThemeBundle({
    required this.elevatedButtonTheme,
    required this.outlinedButtonTheme,
    required this.filledButtonTheme,
    required this.textButtonTheme,
  });

  final ElevatedButtonThemeData elevatedButtonTheme;
  final OutlinedButtonThemeData outlinedButtonTheme;
  final FilledButtonThemeData filledButtonTheme;
  final TextButtonThemeData textButtonTheme;
}
