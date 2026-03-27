import 'package:flutter/foundation.dart';
import 'package:lumos/core/theme/responsive/responsive_scale.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

@immutable
class AdaptiveTypography {
  const AdaptiveTypography({
    required this.display,
    required this.displayMedium,
    required this.headline,
    required this.headlineLarge,
    required this.title,
    required this.titleMedium,
    required this.body,
    required this.bodyMedium,
    required this.label,
    required this.labelMedium,
  });

  factory AdaptiveTypography.fromScreen(ScreenClass screenClass) {
    final scale = ResponsiveScale.typography(screenClass);

    return AdaptiveTypography(
      display: AppTypographyTokens.displayLarge * scale,
      displayMedium: AppTypographyTokens.displayMedium * scale,
      headline: AppTypographyTokens.headlineMedium * scale,
      headlineLarge: AppTypographyTokens.headlineLarge * scale,
      title: AppTypographyTokens.titleLarge * scale,
      titleMedium: AppTypographyTokens.titleMedium * scale,
      body: AppTypographyTokens.bodyLarge * scale,
      bodyMedium: AppTypographyTokens.bodyMedium * scale,
      label: AppTypographyTokens.labelLarge * scale,
      labelMedium: AppTypographyTokens.labelMedium * scale,
    );
  }

  final double display;
  final double displayMedium;
  final double headline;
  final double headlineLarge;
  final double title;
  final double titleMedium;
  final double body;
  final double bodyMedium;
  final double label;
  final double labelMedium;
}
