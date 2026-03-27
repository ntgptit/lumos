import 'package:flutter/material.dart';

import 'responsive_scale.dart';

@immutable
final class AdaptiveTypography {
  const AdaptiveTypography({
    required this.displayScale,
    required this.headlineScale,
    required this.titleScale,
    required this.bodyScale,
  });

  factory AdaptiveTypography.fromScale(ResponsiveScale scale) {
    return AdaptiveTypography(
      displayScale: scale.display,
      headlineScale: scale.headline,
      titleScale: scale.title,
      bodyScale: scale.body,
    );
  }

  final double displayScale;
  final double headlineScale;
  final double titleScale;
  final double bodyScale;

  TextTheme scaleTextTheme(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: _scaleTextStyle(textTheme.displayLarge, displayScale),
      displayMedium: _scaleTextStyle(textTheme.displayMedium, displayScale),
      displaySmall: _scaleTextStyle(textTheme.displaySmall, displayScale),
      headlineLarge: _scaleTextStyle(textTheme.headlineLarge, headlineScale),
      headlineMedium: _scaleTextStyle(textTheme.headlineMedium, headlineScale),
      headlineSmall: _scaleTextStyle(textTheme.headlineSmall, headlineScale),
      titleLarge: _scaleTextStyle(textTheme.titleLarge, titleScale),
      titleMedium: _scaleTextStyle(textTheme.titleMedium, titleScale),
      titleSmall: _scaleTextStyle(textTheme.titleSmall, titleScale),
      bodyLarge: _scaleTextStyle(textTheme.bodyLarge, bodyScale),
      bodyMedium: _scaleTextStyle(textTheme.bodyMedium, bodyScale),
      bodySmall: textTheme.bodySmall,
      labelLarge: _scaleTextStyle(textTheme.labelLarge, bodyScale),
      labelMedium: _scaleTextStyle(textTheme.labelMedium, bodyScale),
      labelSmall: textTheme.labelSmall,
    );
  }

  AdaptiveTypography copyWith({
    double? displayScale,
    double? headlineScale,
    double? titleScale,
    double? bodyScale,
  }) {
    return AdaptiveTypography(
      displayScale: displayScale ?? this.displayScale,
      headlineScale: headlineScale ?? this.headlineScale,
      titleScale: titleScale ?? this.titleScale,
      bodyScale: bodyScale ?? this.bodyScale,
    );
  }
}

TextStyle? _scaleTextStyle(TextStyle? style, double scale) {
  if (style == null) {
    return null;
  }
  if (style.fontSize == null) {
    return style;
  }
  return style.copyWith(fontSize: style.fontSize! * scale);
}
