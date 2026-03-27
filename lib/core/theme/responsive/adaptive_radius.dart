import 'package:flutter/foundation.dart';
import 'package:lumos/core/theme/responsive/responsive_scale.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

@immutable
class AdaptiveRadius {
  const AdaptiveRadius({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  factory AdaptiveRadius.fromScreen(ScreenClass screenClass) {
    final scale = ResponsiveScale.radius(screenClass);

    return AdaptiveRadius(
      xs: AppRadiusTokens.xs * scale,
      sm: AppRadiusTokens.sm * scale,
      md: AppRadiusTokens.md * scale,
      lg: AppRadiusTokens.lg * scale,
      xl: AppRadiusTokens.xl * scale,
      pill: AppRadiusTokens.pill,
    );
  }

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;
}
