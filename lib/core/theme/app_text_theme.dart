import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumos/core/theme/app_color_scheme.dart';
import 'package:lumos/core/theme/responsive/adaptive_typography.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class AppTextTheme {
  static TextTheme light(AdaptiveTypography typography) {
    return build(AppColorScheme.light(), typography);
  }

  static TextTheme dark(AdaptiveTypography typography) {
    return build(AppColorScheme.dark(), typography);
  }

  static TextTheme build(
    ColorScheme colorScheme,
    AdaptiveTypography typography,
  ) {
    final baseMaterialText = colorScheme.brightness == Brightness.dark
        ? Typography.material2021(platform: defaultTargetPlatform).white
        : Typography.material2021(platform: defaultTargetPlatform).black;

    final baseTextTheme = GoogleFonts.notoSansTextTheme(baseMaterialText).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return baseTextTheme.copyWith(
      displayLarge: _displayStyle(
        colorScheme,
        size: typography.display,
        weight: AppTypographyTokens.bold,
      ),
      displayMedium: _displayStyle(
        colorScheme,
        size: typography.displayMedium,
        weight: AppTypographyTokens.semibold,
      ),
      headlineLarge: _titleStyle(
        colorScheme,
        size: typography.headlineLarge,
        weight: AppTypographyTokens.bold,
      ),
      headlineMedium: _titleStyle(
        colorScheme,
        size: typography.headline,
        weight: AppTypographyTokens.bold,
      ),
      titleLarge: _titleStyle(
        colorScheme,
        size: typography.title,
        weight: AppTypographyTokens.semibold,
      ),
      titleMedium: _titleStyle(
        colorScheme,
        size: typography.titleMedium,
        weight: AppTypographyTokens.semibold,
      ),
      bodyLarge: _style(
        colorScheme,
        size: typography.body,
        weight: AppTypographyTokens.regular,
        height: AppTypographyTokens.bodyHeight,
      ),
      bodyMedium: _style(
        colorScheme,
        size: typography.bodyMedium,
        weight: AppTypographyTokens.regular,
        color: colorScheme.onSurfaceVariant,
        height: AppTypographyTokens.bodyHeight,
      ),
      labelLarge: _style(
        colorScheme,
        size: typography.label,
        weight: AppTypographyTokens.medium,
        color: colorScheme.onSurfaceVariant,
        height: AppTypographyTokens.labelHeight,
      ),
      labelMedium: _style(
        colorScheme,
        size: typography.labelMedium,
        weight: AppTypographyTokens.medium,
        color: colorScheme.onSurfaceVariant,
        height: AppTypographyTokens.labelHeight,
      ),
    );
  }

  static TextStyle _style(
    ColorScheme colorScheme, {
    required double size,
    required FontWeight weight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.notoSans(
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? colorScheme.onSurface,
        height: height,
      ),
    );
  }

  static TextStyle _titleStyle(
    ColorScheme colorScheme, {
    required double size,
    required FontWeight weight,
    Color? color,
  }) {
    return GoogleFonts.interTight(
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? colorScheme.onSurface,
        height: AppTypographyTokens.titleHeight,
      ),
    );
  }

  static TextStyle _displayStyle(
    ColorScheme colorScheme, {
    required double size,
    required FontWeight weight,
    Color? color,
  }) {
    return GoogleFonts.dmSerifDisplay(
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? colorScheme.onSurface,
        height: AppTypographyTokens.displayHeight,
      ),
    );
  }
}
