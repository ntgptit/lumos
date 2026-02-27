import 'package:flutter/material.dart';

class AppTypographyConst {
  const AppTypographyConst._();

  static const String kDefaultFontFamily = 'Roboto';
  static const String kGoogleFontInter = 'Inter';
  static const String kGoogleFontPoppins = 'Poppins';
  static const List<String> kFallbackFonts = <String>[
    'SF Pro Text',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static const FontWeight kFontWeightLight = FontWeight.w300;
  static const FontWeight kFontWeightRegular = FontWeight.w400;
  static const FontWeight kFontWeightMedium = FontWeight.w500;
  static const FontWeight kFontWeightSemiBold = FontWeight.w600;
  static const FontWeight kFontWeightBold = FontWeight.w700;

  static const double displayLargeFontSize = 57;
  static const double displayMediumFontSize = 45;
  static const double displaySmallFontSize = 36;
  static const double headlineLargeFontSize = 32;
  static const double headlineMediumFontSize = 28;
  static const double headlineSmallFontSize = 24;
  static const double titleLargeFontSize = 22;
  static const double titleMediumFontSize = 16;
  static const double titleSmallFontSize = 14;
  static const double bodyLargeFontSize = 16;
  static const double bodyMediumFontSize = 14;
  static const double bodySmallFontSize = 12;
  static const double labelLargeFontSize = 14;
  static const double labelMediumFontSize = 12;
  static const double labelSmallFontSize = 11;

  static const double displayLargeLineHeight = 64;
  static const double displayMediumLineHeight = 52;
  static const double displaySmallLineHeight = 44;
  static const double headlineLargeLineHeight = 40;
  static const double headlineMediumLineHeight = 36;
  static const double headlineSmallLineHeight = 32;
  static const double titleLargeLineHeight = 28;
  static const double titleMediumLineHeight = 24;
  static const double titleSmallLineHeight = 20;
  static const double bodyLargeLineHeight = 24;
  static const double bodyMediumLineHeight = 20;
  static const double bodySmallLineHeight = 16;
  static const double labelLargeLineHeight = 20;
  static const double labelMediumLineHeight = 16;
  static const double labelSmallLineHeight = 16;

  static const double displayLargeLetterSpacing = -0.25;
  static const double displayMediumLetterSpacing = 0;
  static const double displaySmallLetterSpacing = 0;
  static const double headlineLargeLetterSpacing = 0;
  static const double headlineMediumLetterSpacing = 0;
  static const double headlineSmallLetterSpacing = 0;
  static const double titleLargeLetterSpacing = 0;
  static const double titleMediumLetterSpacing = 0.15;
  static const double titleSmallLetterSpacing = 0.1;
  static const double bodyLargeLetterSpacing = 0.5;
  static const double bodyMediumLetterSpacing = 0.25;
  static const double bodySmallLetterSpacing = 0.4;
  static const double labelLargeLetterSpacing = 0.1;
  static const double labelMediumLetterSpacing = 0.5;
  static const double labelSmallLetterSpacing = 0.5;

  static const AppTextStyleConfig displayLargeStyle = AppTextStyleConfig(
    fontSize: displayLargeFontSize,
    lineHeight: displayLargeLineHeight,
    letterSpacing: displayLargeLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig displayMediumStyle = AppTextStyleConfig(
    fontSize: displayMediumFontSize,
    lineHeight: displayMediumLineHeight,
    letterSpacing: displayMediumLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig displaySmallStyle = AppTextStyleConfig(
    fontSize: displaySmallFontSize,
    lineHeight: displaySmallLineHeight,
    letterSpacing: displaySmallLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig headlineLargeStyle = AppTextStyleConfig(
    fontSize: headlineLargeFontSize,
    lineHeight: headlineLargeLineHeight,
    letterSpacing: headlineLargeLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig headlineMediumStyle = AppTextStyleConfig(
    fontSize: headlineMediumFontSize,
    lineHeight: headlineMediumLineHeight,
    letterSpacing: headlineMediumLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig headlineSmallStyle = AppTextStyleConfig(
    fontSize: headlineSmallFontSize,
    lineHeight: headlineSmallLineHeight,
    letterSpacing: headlineSmallLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig titleLargeStyle = AppTextStyleConfig(
    fontSize: titleLargeFontSize,
    lineHeight: titleLargeLineHeight,
    letterSpacing: titleLargeLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig titleMediumStyle = AppTextStyleConfig(
    fontSize: titleMediumFontSize,
    lineHeight: titleMediumLineHeight,
    letterSpacing: titleMediumLetterSpacing,
    fontWeight: kFontWeightMedium,
  );
  static const AppTextStyleConfig titleSmallStyle = AppTextStyleConfig(
    fontSize: titleSmallFontSize,
    lineHeight: titleSmallLineHeight,
    letterSpacing: titleSmallLetterSpacing,
    fontWeight: kFontWeightMedium,
  );
  static const AppTextStyleConfig bodyLargeStyle = AppTextStyleConfig(
    fontSize: bodyLargeFontSize,
    lineHeight: bodyLargeLineHeight,
    letterSpacing: bodyLargeLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig bodyMediumStyle = AppTextStyleConfig(
    fontSize: bodyMediumFontSize,
    lineHeight: bodyMediumLineHeight,
    letterSpacing: bodyMediumLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig bodySmallStyle = AppTextStyleConfig(
    fontSize: bodySmallFontSize,
    lineHeight: bodySmallLineHeight,
    letterSpacing: bodySmallLetterSpacing,
    fontWeight: kFontWeightRegular,
  );
  static const AppTextStyleConfig labelLargeStyle = AppTextStyleConfig(
    fontSize: labelLargeFontSize,
    lineHeight: labelLargeLineHeight,
    letterSpacing: labelLargeLetterSpacing,
    fontWeight: kFontWeightMedium,
  );
  static const AppTextStyleConfig labelMediumStyle = AppTextStyleConfig(
    fontSize: labelMediumFontSize,
    lineHeight: labelMediumLineHeight,
    letterSpacing: labelMediumLetterSpacing,
    fontWeight: kFontWeightMedium,
  );
  static const AppTextStyleConfig labelSmallStyle = AppTextStyleConfig(
    fontSize: labelSmallFontSize,
    lineHeight: labelSmallLineHeight,
    letterSpacing: labelSmallLetterSpacing,
    fontWeight: kFontWeightMedium,
  );
}

class AppTextStyleConfig {
  const AppTextStyleConfig({
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
    required this.fontWeight,
  });

  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final FontWeight fontWeight;
}
