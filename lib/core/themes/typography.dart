import 'package:flutter/material.dart';

import 'text_theme.dart';
import 'text_styles.dart';

export 'text_styles.dart';
export 'typography_extensions.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme({required ColorScheme colorScheme}) {
    return AppTextThemeBuilder.buildTextTheme(
      colorScheme: colorScheme,
      fontFamily: AppTypographyConst.kDefaultFontFamily,
    );
  }

  static TextTheme primaryTextTheme({required ColorScheme colorScheme}) {
    return AppTextThemeBuilder.buildPrimaryTextTheme(
      colorScheme: colorScheme,
      fontFamily: AppTypographyConst.kDefaultFontFamily,
    );
  }

  static TextTheme buildTextTheme({
    required ColorScheme colorScheme,
    required String fontFamily,
    Color? textColor,
  }) {
    return AppTextThemeBuilder.buildTextTheme(
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      textColor: textColor,
    );
  }

  static TextTheme buildPrimaryTextTheme({
    required ColorScheme colorScheme,
    required String fontFamily,
  }) {
    return AppTextThemeBuilder.buildPrimaryTextTheme(
      colorScheme: colorScheme,
      fontFamily: fontFamily,
    );
  }
}
