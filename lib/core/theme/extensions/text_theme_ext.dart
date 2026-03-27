import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/adaptive_typography.dart';

@immutable
class TextThemeExt extends ThemeExtension<TextThemeExt> {
  const TextThemeExt({required this.typography});

  final AdaptiveTypography typography;

  @override
  TextThemeExt copyWith({AdaptiveTypography? typography}) {
    return TextThemeExt(typography: typography ?? this.typography);
  }

  @override
  TextThemeExt lerp(ThemeExtension<TextThemeExt>? other, double t) {
    if (other is! TextThemeExt) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
