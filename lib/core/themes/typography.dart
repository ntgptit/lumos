import 'package:flutter/material.dart';

import 'component_themes/text_theme.dart';
import 'constants/text_styles.dart';

export 'constants/text_styles.dart';
export 'extensions/typography_extensions.dart';

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
