import 'package:flutter/material.dart';

import '../tokens/radius_tokens.dart';
import 'responsive_scale.dart';

@immutable
final class AdaptiveRadius {
  const AdaptiveRadius({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  factory AdaptiveRadius.fromScale(ResponsiveScale scale) {
    return AdaptiveRadius(
      none: RadiusTokens.none,
      xs: RadiusTokens.xs * scale.radius,
      sm: RadiusTokens.sm * scale.radius,
      md: RadiusTokens.md * scale.radius,
      lg: RadiusTokens.lg * scale.radius,
      xl: RadiusTokens.xl * scale.radius,
      pill: RadiusTokens.pill,
    );
  }

  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;

  BorderRadius circular(double radius) {
    return BorderRadius.circular(radius);
  }

  AdaptiveRadius copyWith({
    double? none,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? pill,
  }) {
    return AdaptiveRadius(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      pill: pill ?? this.pill,
    );
  }
}
