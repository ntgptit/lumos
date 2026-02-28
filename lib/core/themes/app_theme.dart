import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'component_themes/component_theme_data_builder.dart';
import 'constants/color_schemes.dart';
import 'constants/dimensions.dart';
import 'typography.dart';

abstract final class AppThemeConst {
  static const String allowNoDynamicColorMarker =
      'theme-guard: allow-no-dynamic-color';
  static const TargetPlatform iosPlatform = TargetPlatform.iOS;
  static const TargetPlatform macOsPlatform = TargetPlatform.macOS;
  static const TargetPlatform androidPlatform = TargetPlatform.android;
  static const TargetPlatform linuxPlatform = TargetPlatform.linux;
  static const TargetPlatform windowsPlatform = TargetPlatform.windows;
  static const TargetPlatform fuchsiaPlatform = TargetPlatform.fuchsia;
}

abstract final class AppTheme {
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
    final ThemeData flexTheme = _buildFlexTheme(colorScheme: colorScheme);
    final TextTheme textTheme = AppTypography.textTheme(
      colorScheme: colorScheme,
    );
    final TextTheme primaryTextTheme = AppTypography.primaryTextTheme(
      colorScheme: colorScheme,
    );

    final ThemeData baseTheme = flexTheme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      pageTransitionsTheme: _buildPageTransitionsTheme(),
      visualDensity: const VisualDensity(
        horizontal: WidgetSizes.none,
        vertical: WidgetSizes.none,
      ),
    );

    return ComponentThemeDataBuilder.apply(
      baseTheme: baseTheme,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static ThemeData _buildFlexTheme({required ColorScheme colorScheme}) {
    final FlexSchemeColor flexSchemeColor = _toFlexSchemeColor(
      colorScheme: colorScheme,
    );

    if (colorScheme.brightness == Brightness.dark) {
      return FlexColorScheme.dark(
        colors: flexSchemeColor,
        useMaterial3: true,
      ).toTheme;
    }

    return FlexColorScheme.light(
      colors: flexSchemeColor,
      useMaterial3: true,
    ).toTheme;
  }

  static FlexSchemeColor _toFlexSchemeColor({
    required ColorScheme colorScheme,
  }) {
    return FlexSchemeColor(
      primary: colorScheme.primary,
      primaryContainer: colorScheme.primaryContainer,
      secondary: colorScheme.secondary,
      secondaryContainer: colorScheme.secondaryContainer,
      tertiary: colorScheme.tertiary,
      tertiaryContainer: colorScheme.tertiaryContainer,
      appBarColor: colorScheme.surface,
      error: colorScheme.error,
      errorContainer: colorScheme.errorContainer,
    );
  }

  static PageTransitionsTheme _buildPageTransitionsTheme() {
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
}
