import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class AppColorScheme {
  static const FlexSchemeColor _lightFlexColors = FlexSchemeColor(
    primary: AppColorTokens.lightPrimary,
    primaryContainer: AppColorTokens.lightPrimaryContainer,
    secondary: AppColorTokens.lightSecondary,
    secondaryContainer: AppColorTokens.lightSecondaryContainer,
    tertiary: AppColorTokens.tertiary,
    tertiaryContainer: AppColorTokens.tertiaryContainer,
  );

  static const FlexSchemeColor _darkFlexColors = FlexSchemeColor(
    primary: AppColorTokens.darkPrimary,
    primaryContainer: AppColorTokens.darkPrimaryContainerOpaque,
    primaryLightRef: AppColorTokens.darkPrimary,
    secondary: AppColorTokens.darkSecondary,
    secondaryContainer: AppColorTokens.darkSecondaryContainerOpaque,
    secondaryLightRef: AppColorTokens.darkSecondary,
    tertiary: AppColorTokens.darkInfo,
    tertiaryContainer: AppColorTokens.darkInfoContainerStrong,
    tertiaryLightRef: AppColorTokens.darkInfo,
  );

  static ColorScheme light() {
    return _applySurfaceTokens(
      _materialScheme(Brightness.light),
      brightness: Brightness.light,
    );
  }

  static ColorScheme dark() {
    return _applySurfaceTokens(
      _materialScheme(Brightness.dark),
      brightness: Brightness.dark,
    );
  }

  static ColorScheme build(Brightness brightness) {
    return brightness == Brightness.dark ? dark() : light();
  }

  static ColorScheme _materialScheme(Brightness brightness) {
    final theme = brightness == Brightness.dark
        ? FlexThemeData.dark(
            useMaterial3: true,
            colors: _darkFlexColors,
            visualDensity: VisualDensity.standard,
          )
        : FlexThemeData.light(
            useMaterial3: true,
            colors: _lightFlexColors,
            visualDensity: VisualDensity.standard,
          );

    return theme.colorScheme;
  }

  static ColorScheme _applySurfaceTokens(
    ColorScheme scheme, {
    required Brightness brightness,
  }) {
    if (brightness == Brightness.dark) {
      return scheme.copyWith(
        primary: AppColorTokens.darkPrimary,
        onPrimary: AppColorTokens.white,
        primaryContainer: AppColorTokens.darkPrimaryContainer,
        onPrimaryContainer: AppColorTokens.darkPrimaryGlow,
        secondary: AppColorTokens.darkSecondary,
        onSecondary: AppColorTokens.white,
        secondaryContainer: AppColorTokens.darkSecondaryContainer,
        onSecondaryContainer: AppColorTokens.darkTextPrimary,
        tertiary: AppColorTokens.darkInfo,
        onTertiary: AppColorTokens.white,
        tertiaryContainer: AppColorTokens.darkInfoContainer,
        onTertiaryContainer: AppColorTokens.darkInfo,
        error: AppColorTokens.darkError,
        onError: AppColorTokens.darkOnError,
        errorContainer: AppColorTokens.darkErrorContainer,
        onErrorContainer: AppColorTokens.darkOnErrorContainer,
        onSurface: AppColorTokens.darkTextPrimary,
        onSurfaceVariant: AppColorTokens.darkTextSecondary,
        surface: AppColorTokens.darkSurface,
        surfaceContainerLowest: AppColorTokens.darkSurface,
        surfaceContainerLow: AppColorTokens.darkSurfaceContainerLow,
        surfaceContainer: AppColorTokens.darkSurfaceContainer,
        surfaceContainerHigh: AppColorTokens.darkSurfaceContainerHigh,
        surfaceContainerHighest: AppColorTokens.darkSurfaceContainerHighest,
        outline: AppColorTokens.darkOutline,
        outlineVariant: AppColorTokens.darkOutlineVariant,
        shadow: AppColorTokens.darkShadow,
      );
    }

    return scheme.copyWith(
      primary: AppColorTokens.lightPrimary,
      onPrimary: AppColorTokens.white,
      primaryContainer: AppColorTokens.lightPrimaryContainer,
      onPrimaryContainer: AppColorTokens.lightPrimaryDark,
      secondary: AppColorTokens.lightSecondary,
      onSecondary: AppColorTokens.white,
      secondaryContainer: AppColorTokens.lightSecondaryContainer,
      onSecondaryContainer: AppColorTokens.lightSecondaryDark,
      onSurface: AppColorTokens.lightTextPrimary,
      onSurfaceVariant: AppColorTokens.lightTextSecondary,
      surface: AppColorTokens.lightSurface,
      surfaceContainerLowest: AppColorTokens.lightSurface,
      surfaceContainerLow: AppColorTokens.lightSurfaceContainerLow,
      surfaceContainer: AppColorTokens.lightSurfaceContainer,
      surfaceContainerHigh: AppColorTokens.lightSurfaceContainerHigh,
      surfaceContainerHighest: AppColorTokens.lightSurfaceContainerHighest,
      outline: AppColorTokens.lightOutline,
      outlineVariant: AppColorTokens.lightOutlineVariant,
      shadow: AppColorTokens.lightShadow,
    );
  }
}
