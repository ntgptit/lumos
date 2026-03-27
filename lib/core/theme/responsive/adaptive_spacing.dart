import 'package:flutter/material.dart';

import '../tokens/spacing_tokens.dart';
import 'responsive_scale.dart';

@immutable
final class AdaptiveSpacing {
  const AdaptiveSpacing({
    required this.none,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.section,
    required this.page,
    required this.canvas,
  });

  factory AdaptiveSpacing.fromScale(ResponsiveScale scale) {
    return AdaptiveSpacing(
      none: SpacingTokens.none,
      xxs: SpacingTokens.xxs * scale.spacing,
      xs: SpacingTokens.xs * scale.spacing,
      sm: SpacingTokens.sm * scale.spacing,
      md: SpacingTokens.md * scale.spacing,
      lg: SpacingTokens.lg * scale.spacing,
      xl: SpacingTokens.xl * scale.spacing,
      xxl: SpacingTokens.xxl * scale.spacing,
      xxxl: SpacingTokens.xxxl * scale.spacing,
      section: SpacingTokens.section * scale.spacing,
      page: SpacingTokens.page * scale.spacing,
      canvas: SpacingTokens.canvas * scale.spacing,
    );
  }

  final double none;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double section;
  final double page;
  final double canvas;

  EdgeInsets get pageInsets {
    return EdgeInsets.symmetric(horizontal: lg, vertical: md);
  }

  AdaptiveSpacing copyWith({
    double? none,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? section,
    double? page,
    double? canvas,
  }) {
    return AdaptiveSpacing(
      none: none ?? this.none,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      section: section ?? this.section,
      page: page ?? this.page,
      canvas: canvas ?? this.canvas,
    );
  }
}
