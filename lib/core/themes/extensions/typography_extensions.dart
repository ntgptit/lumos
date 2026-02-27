import 'package:flutter/material.dart';

import '../constants/text_styles.dart';

extension AppTextThemeExtension on TextTheme {
  TextStyle get emphasisValue {
    final TextStyle baseStyle = bodyLarge ?? const TextStyle();
    return baseStyle.copyWith(fontWeight: AppTypographyConst.kFontWeightBold);
  }
}
