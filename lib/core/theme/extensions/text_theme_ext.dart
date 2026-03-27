import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';

extension TextThemeExt on TextTheme {
  TextStyle get bodyMediumStrong {
    final TextStyle baseStyle = bodyMedium ?? const TextStyle();
    return baseStyle.copyWith(fontWeight: AppTypographyConst.kFontWeightBold);
  }

  TextStyle get bodySmallMuted {
    return bodySmall ?? const TextStyle();
  }

  TextStyle get labelMediumLink {
    final TextStyle baseStyle = labelMedium ?? const TextStyle();
    return baseStyle.copyWith(decoration: TextDecoration.underline);
  }
}
