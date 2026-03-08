import 'dart:ui';

import 'package:flutter/material.dart';

import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';

@immutable
class AppNavigationBarTokens extends ThemeExtension<AppNavigationBarTokens> {
  const AppNavigationBarTokens({
    required this.height,
    required this.iconSize,
    required this.indicatorRadius,
    required this.labelPadding,
  });

  final double height;
  final double iconSize;
  final double indicatorRadius;
  final EdgeInsets labelPadding;

  static const AppNavigationBarTokens defaults = AppNavigationBarTokens(
    height: AppSpacing.xxxl + AppSpacing.xxl + AppSpacing.xxl,
    iconSize: AppSpacing.xxl,
    indicatorRadius: AppRadius.md,
    labelPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xxs,
    ),
  );

  @override
  AppNavigationBarTokens copyWith({
    double? height,
    double? iconSize,
    double? indicatorRadius,
    EdgeInsets? labelPadding,
  }) {
    return AppNavigationBarTokens(
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      indicatorRadius: indicatorRadius ?? this.indicatorRadius,
      labelPadding: labelPadding ?? this.labelPadding,
    );
  }

  @override
  AppNavigationBarTokens lerp(
    ThemeExtension<AppNavigationBarTokens>? other,
    double t,
  ) {
    if (other is! AppNavigationBarTokens) {
      return this;
    }
    return AppNavigationBarTokens(
      height: lerpDouble(height, other.height, t) ?? height,
      iconSize: lerpDouble(iconSize, other.iconSize, t) ?? iconSize,
      indicatorRadius:
          lerpDouble(indicatorRadius, other.indicatorRadius, t) ??
          indicatorRadius,
      labelPadding:
          EdgeInsets.lerp(labelPadding, other.labelPadding, t) ?? labelPadding,
    );
  }

  @override
  int get hashCode =>
      Object.hash(height, iconSize, indicatorRadius, labelPadding);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppNavigationBarTokens &&
        other.height == height &&
        other.iconSize == iconSize &&
        other.indicatorRadius == indicatorRadius &&
        other.labelPadding == labelPadding;
  }
}
