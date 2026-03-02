import 'dart:ui';

import 'package:flutter/material.dart';

import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';
import '../foundation/app_stroke.dart';

@immutable
class AppCardTokens extends ThemeExtension<AppCardTokens> {
  const AppCardTokens({
    required this.paddingSm,
    required this.paddingMd,
    required this.paddingLg,
    required this.radius,
    required this.borderWidth,
  });

  final EdgeInsets paddingSm;
  final EdgeInsets paddingMd;
  final EdgeInsets paddingLg;
  final double radius;
  final double borderWidth;

  static const AppCardTokens defaults = AppCardTokens(
    paddingSm: EdgeInsets.all(AppSpacing.sm),
    paddingMd: EdgeInsets.all(AppSpacing.md),
    paddingLg: EdgeInsets.all(AppSpacing.lg),
    radius: AppRadius.lg,
    borderWidth: AppStroke.thin,
  );

  @override
  AppCardTokens copyWith({
    EdgeInsets? paddingSm,
    EdgeInsets? paddingMd,
    EdgeInsets? paddingLg,
    double? radius,
    double? borderWidth,
  }) {
    return AppCardTokens(
      paddingSm: paddingSm ?? this.paddingSm,
      paddingMd: paddingMd ?? this.paddingMd,
      paddingLg: paddingLg ?? this.paddingLg,
      radius: radius ?? this.radius,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  AppCardTokens lerp(ThemeExtension<AppCardTokens>? other, double t) {
    if (other is! AppCardTokens) {
      return this;
    }
    return AppCardTokens(
      paddingSm: EdgeInsets.lerp(paddingSm, other.paddingSm, t) ?? paddingSm,
      paddingMd: EdgeInsets.lerp(paddingMd, other.paddingMd, t) ?? paddingMd,
      paddingLg: EdgeInsets.lerp(paddingLg, other.paddingLg, t) ?? paddingLg,
      radius: lerpDouble(radius, other.radius, t) ?? radius,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
    );
  }

  @override
  int get hashCode =>
      Object.hash(paddingSm, paddingMd, paddingLg, radius, borderWidth);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppCardTokens &&
        other.paddingSm == paddingSm &&
        other.paddingMd == paddingMd &&
        other.paddingLg == paddingLg &&
        other.radius == radius &&
        other.borderWidth == borderWidth;
  }
}
