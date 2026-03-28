import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/theme/app_color_scheme.dart';
import 'package:lumos/core/theme/app_text_theme.dart';
import 'package:lumos/core/theme/component_themes/component_themes.dart';
import 'package:lumos/core/theme/app_theme_mode.dart';
import 'package:lumos/core/theme/responsive/responsive_theme_factory.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class AppTheme {
  static ThemeData light({required ScreenInfo screenInfo}) {
    return _build(brightness: Brightness.light, screenInfo: screenInfo);
  }

  static ThemeData dark({required ScreenInfo screenInfo}) {
    return _build(brightness: Brightness.dark, screenInfo: screenInfo);
  }

  static ThemeData resolve({
    required AppThemeMode mode,
    required ScreenInfo screenInfo,
    required Brightness platformBrightness,
  }) {
    return _build(
      brightness: mode.resolveBrightness(platformBrightness),
      screenInfo: screenInfo,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ScreenInfo screenInfo,
  }) {
    final baseTheme = brightness == Brightness.dark
        ? FlexThemeData.dark(
            useMaterial3: true,
            visualDensity: VisualDensity.standard,
          )
        : FlexThemeData.light(
            useMaterial3: true,
            visualDensity: VisualDensity.standard,
          );
    final colorScheme = brightness == Brightness.dark
        ? AppColorScheme.dark()
        : AppColorScheme.light();
    final dimensions = ResponsiveThemeFactory.create(screenInfo.screenClass);
    final textTheme = AppTextTheme.build(colorScheme, dimensions.typography);

    return baseTheme.copyWith(
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColorTokens.background(brightness),
      canvasColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.outlineVariant,
      appBarTheme: LumosAppBarTheme.build(
        colorScheme: colorScheme,
        dims: dimensions,
      ),
      filledButtonTheme: LumosButtonThemes.filled(colorScheme, dimensions),
      outlinedButtonTheme: LumosButtonThemes.outlined(
        colorScheme,
        dimensions,
      ),
      textButtonTheme: LumosButtonThemes.text(colorScheme, dimensions),
      inputDecorationTheme: LumosInputTheme.build(colorScheme, dimensions),
      cardTheme: LumosCardTheme.build(colorScheme, dimensions),
      dialogTheme: LumosDialogTheme.build(colorScheme, dimensions),
      chipTheme: LumosChipTheme.build(colorScheme, dimensions),
      dividerTheme: LumosDividerTheme.build(colorScheme),
      checkboxTheme: LumosCheckboxTheme.build(colorScheme),
      radioTheme: LumosRadioTheme.build(colorScheme),
      switchTheme: LumosSwitchTheme.build(colorScheme),
      sliderTheme: LumosSliderTheme.build(colorScheme),
      progressIndicatorTheme: LumosProgressIndicatorTheme.build(colorScheme),
      bottomSheetTheme: LumosBottomSheetTheme.build(colorScheme, dimensions),
      navigationBarTheme: LumosNavigationTheme.bar(
        colorScheme: colorScheme,
        dimensions: dimensions,
        textTheme: textTheme,
      ),
      navigationRailTheme: LumosNavigationTheme.rail(
        colorScheme: colorScheme,
        dimensions: dimensions,
        textTheme: textTheme,
      ),
      extensions: ResponsiveThemeFactory.extensions(
        dimensions: dimensions,
        brightness: brightness,
      ),
    );
  }
}
