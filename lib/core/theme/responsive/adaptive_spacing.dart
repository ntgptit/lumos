import 'package:flutter/foundation.dart';
import 'package:lumos/core/theme/responsive/responsive_scale.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

@immutable
class AdaptiveSpacing {
  const AdaptiveSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.section,
    required this.gutter,
    required this.gridGap,
  });

  factory AdaptiveSpacing.fromScreen(ScreenClass screenClass) {
    final scale = ResponsiveScale.spacing(screenClass);

    return AdaptiveSpacing(
      xxs: AppSpacingTokens.xxs * scale,
      xs: AppSpacingTokens.xs * scale,
      sm: AppSpacingTokens.sm * scale,
      md: AppSpacingTokens.md * scale,
      lg: AppSpacingTokens.lg * scale,
      xl: AppSpacingTokens.xl * scale,
      xxl: AppSpacingTokens.xxl * scale,
      xxxl: AppSpacingTokens.xxxl * scale,
      section: AppSpacingTokens.section * scale,
      gutter: AppSpacingTokens.gutter * scale,
      gridGap: AppSpacingTokens.gridGap * scale,
    );
  }

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double section;
  final double gutter;
  final double gridGap;
}
