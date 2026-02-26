import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'text_styles.dart';

class AppTextThemeBuilder {
  const AppTextThemeBuilder._();

  static TextTheme buildTextTheme({
    required ColorScheme colorScheme,
    required String fontFamily,
    Color? textColor,
  }) {
    if (fontFamily.isEmpty) {
      throw ArgumentError.value(
        fontFamily,
        'fontFamily',
        'fontFamily must not be empty',
      );
    }
    final Color resolvedTextColor = textColor ?? colorScheme.onSurface;
    final TextTheme displayTheme = _buildDisplayTheme(
      color: resolvedTextColor,
      fontFamily: fontFamily,
    );
    final TextTheme headlineTheme = _buildHeadlineTheme(
      color: resolvedTextColor,
      fontFamily: fontFamily,
    );
    final TextTheme titleTheme = _buildTitleTheme(
      color: resolvedTextColor,
      fontFamily: fontFamily,
    );
    final TextTheme bodyTheme = _buildBodyTheme(
      color: resolvedTextColor,
      fontFamily: fontFamily,
    );
    final TextTheme labelTheme = _buildLabelTheme(
      color: resolvedTextColor,
      fontFamily: fontFamily,
    );
    return displayTheme.copyWith(
      headlineLarge: headlineTheme.headlineLarge,
      headlineMedium: headlineTheme.headlineMedium,
      headlineSmall: headlineTheme.headlineSmall,
      titleLarge: titleTheme.titleLarge,
      titleMedium: titleTheme.titleMedium,
      titleSmall: titleTheme.titleSmall,
      bodyLarge: bodyTheme.bodyLarge,
      bodyMedium: bodyTheme.bodyMedium,
      bodySmall: bodyTheme.bodySmall,
      labelLarge: labelTheme.labelLarge,
      labelMedium: labelTheme.labelMedium,
      labelSmall: labelTheme.labelSmall,
    );
  }

  static TextTheme buildPrimaryTextTheme({
    required ColorScheme colorScheme,
    required String fontFamily,
  }) {
    return buildTextTheme(
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      textColor: colorScheme.onPrimary,
    );
  }

  static TextTheme _buildDisplayTheme({
    required Color color,
    required String fontFamily,
  }) {
    return TextTheme(
      displayLarge: _style(
        config: AppTypographyConst.displayLargeStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      displayMedium: _style(
        config: AppTypographyConst.displayMediumStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      displaySmall: _style(
        config: AppTypographyConst.displaySmallStyle,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static TextTheme _buildHeadlineTheme({
    required Color color,
    required String fontFamily,
  }) {
    return TextTheme(
      headlineLarge: _style(
        config: AppTypographyConst.headlineLargeStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      headlineMedium: _style(
        config: AppTypographyConst.headlineMediumStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      headlineSmall: _style(
        config: AppTypographyConst.headlineSmallStyle,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static TextTheme _buildTitleTheme({
    required Color color,
    required String fontFamily,
  }) {
    return TextTheme(
      titleLarge: _style(
        config: AppTypographyConst.titleLargeStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      titleMedium: _style(
        config: AppTypographyConst.titleMediumStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      titleSmall: _style(
        config: AppTypographyConst.titleSmallStyle,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static TextTheme _buildBodyTheme({
    required Color color,
    required String fontFamily,
  }) {
    return TextTheme(
      bodyLarge: _style(
        config: AppTypographyConst.bodyLargeStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      bodyMedium: _style(
        config: AppTypographyConst.bodyMediumStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      bodySmall: _style(
        config: AppTypographyConst.bodySmallStyle,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static TextTheme _buildLabelTheme({
    required Color color,
    required String fontFamily,
  }) {
    return TextTheme(
      labelLarge: _style(
        config: AppTypographyConst.labelLargeStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      labelMedium: _style(
        config: AppTypographyConst.labelMediumStyle,
        color: color,
        fontFamily: fontFamily,
      ),
      labelSmall: _style(
        config: AppTypographyConst.labelSmallStyle,
        color: color,
        fontFamily: fontFamily,
      ),
    );
  }

  static TextStyle _style({
    required AppTextStyleConfig config,
    required Color color,
    required String fontFamily,
  }) {
    final TextStyle baseStyle = TextStyle(
      fontSize: config.fontSize,
      fontWeight: config.fontWeight,
      letterSpacing: config.letterSpacing,
      height: config.lineHeight / config.fontSize,
      color: color,
      fontFamily: fontFamily,
      fontFamilyFallback: AppTypographyConst.kFallbackFonts,
    );
    return _applyGoogleFont(fontFamily: fontFamily, textStyle: baseStyle);
  }

  static TextStyle _applyGoogleFont({
    required String fontFamily,
    required TextStyle textStyle,
  }) {
    if (fontFamily == AppTypographyConst.kDefaultFontFamily) {
      return GoogleFonts.roboto(textStyle: textStyle);
    }
    if (fontFamily == AppTypographyConst.kGoogleFontInter) {
      return GoogleFonts.inter(textStyle: textStyle);
    }
    if (fontFamily == AppTypographyConst.kGoogleFontPoppins) {
      return GoogleFonts.poppins(textStyle: textStyle);
    }
    return textStyle;
  }
}
