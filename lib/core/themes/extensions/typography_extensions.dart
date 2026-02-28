import 'package:flutter/material.dart';

import '../constants/text_styles.dart';

extension AppTextThemeExtension on TextTheme {
  TextStyle get emphasisValue {
    final TextStyle baseStyle = bodyLarge ?? const TextStyle();
    return baseStyle.copyWith(fontWeight: AppTypographyConst.kFontWeightBold);
  }
}

extension AppTextStyleExtension on TextStyle? {
  TextStyle withResolvedColor(Color color) {
    final TextStyle baseStyle = this ?? const TextStyle();
    return baseStyle.copyWith(color: color);
  }

  TextStyle withResolvedColorAndWeight({
    required Color color,
    required FontWeight fontWeight,
  }) {
    final TextStyle baseStyle = this ?? const TextStyle();
    return baseStyle.copyWith(color: color, fontWeight: fontWeight);
  }
}
