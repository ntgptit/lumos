import 'dart:ui';

import 'package:flutter/material.dart';

import '../foundation/app_opacity.dart';
import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';

@immutable
class AppButtonTokens extends ThemeExtension<AppButtonTokens> {
  const AppButtonTokens({
    required this.heightSm,
    required this.heightMd,
    required this.heightLg,
    required this.paddingSm,
    required this.paddingMd,
    required this.paddingLg,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.iconSizeSm,
    required this.iconSizeMd,
    required this.iconSizeLg,
    required this.disabledOpacity,
  });

  final double heightSm;
  final double heightMd;
  final double heightLg;

  final EdgeInsets paddingSm;
  final EdgeInsets paddingMd;
  final EdgeInsets paddingLg;

  final double radiusSm;
  final double radiusMd;
  final double radiusLg;

  final double iconSizeSm;
  final double iconSizeMd;
  final double iconSizeLg;
  final double disabledOpacity;

  static const AppButtonTokens defaults = AppButtonTokens(
    heightSm: 40.0,
    heightMd: 40.0,
    heightLg: 48.0,
    paddingSm: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.xs,
    ),
    paddingMd: EdgeInsets.symmetric(
      horizontal: AppSpacing.xxl,
      vertical: AppSpacing.sm,
    ),
    paddingLg: EdgeInsets.symmetric(
      horizontal: AppSpacing.xxl,
      vertical: AppSpacing.md,
    ),
    radiusSm: AppRadius.xl,
    radiusMd: AppRadius.xl,
    radiusLg: AppRadius.xl,
    iconSizeSm: 16.0,
    iconSizeMd: 24.0,
    iconSizeLg: 32.0,
    disabledOpacity: AppOpacity.disabled,
  );

  @override
  AppButtonTokens copyWith({
    double? heightSm,
    double? heightMd,
    double? heightLg,
    EdgeInsets? paddingSm,
    EdgeInsets? paddingMd,
    EdgeInsets? paddingLg,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? iconSizeSm,
    double? iconSizeMd,
    double? iconSizeLg,
    double? disabledOpacity,
  }) {
    return AppButtonTokens(
      heightSm: heightSm ?? this.heightSm,
      heightMd: heightMd ?? this.heightMd,
      heightLg: heightLg ?? this.heightLg,
      paddingSm: paddingSm ?? this.paddingSm,
      paddingMd: paddingMd ?? this.paddingMd,
      paddingLg: paddingLg ?? this.paddingLg,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      iconSizeSm: iconSizeSm ?? this.iconSizeSm,
      iconSizeMd: iconSizeMd ?? this.iconSizeMd,
      iconSizeLg: iconSizeLg ?? this.iconSizeLg,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  @override
  AppButtonTokens lerp(ThemeExtension<AppButtonTokens>? other, double t) {
    if (other is! AppButtonTokens) {
      return this;
    }
    return AppButtonTokens(
      heightSm: lerpDouble(heightSm, other.heightSm, t) ?? heightSm,
      heightMd: lerpDouble(heightMd, other.heightMd, t) ?? heightMd,
      heightLg: lerpDouble(heightLg, other.heightLg, t) ?? heightLg,
      paddingSm: EdgeInsets.lerp(paddingSm, other.paddingSm, t) ?? paddingSm,
      paddingMd: EdgeInsets.lerp(paddingMd, other.paddingMd, t) ?? paddingMd,
      paddingLg: EdgeInsets.lerp(paddingLg, other.paddingLg, t) ?? paddingLg,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t) ?? radiusSm,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t) ?? radiusMd,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t) ?? radiusLg,
      iconSizeSm: lerpDouble(iconSizeSm, other.iconSizeSm, t) ?? iconSizeSm,
      iconSizeMd: lerpDouble(iconSizeMd, other.iconSizeMd, t) ?? iconSizeMd,
      iconSizeLg: lerpDouble(iconSizeLg, other.iconSizeLg, t) ?? iconSizeLg,
      disabledOpacity:
          lerpDouble(disabledOpacity, other.disabledOpacity, t) ??
          disabledOpacity,
    );
  }
}
