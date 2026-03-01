import 'dart:ui';

import 'package:flutter/material.dart';

import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';

@immutable
class AppDialogTokens extends ThemeExtension<AppDialogTokens> {
  const AppDialogTokens({
    required this.insetPaddingMobile,
    required this.insetPaddingTablet,
    required this.insetPaddingDesktop,
    required this.maxWidthTablet,
    required this.maxWidthDesktop,
    required this.radius,
  });

  final EdgeInsets insetPaddingMobile;
  final EdgeInsets insetPaddingTablet;
  final EdgeInsets insetPaddingDesktop;
  final double maxWidthTablet;
  final double maxWidthDesktop;
  final double radius;

  static const AppDialogTokens defaults = AppDialogTokens(
    insetPaddingMobile: EdgeInsets.symmetric(
      horizontal: AppSpacing.xxxl,
      vertical: AppSpacing.xxl,
    ),
    insetPaddingTablet: EdgeInsets.symmetric(
      horizontal: AppSpacing.xxxl * 3,
      vertical: AppSpacing.xxl,
    ),
    insetPaddingDesktop: EdgeInsets.symmetric(
      horizontal: AppSpacing.xxxl * 6,
      vertical: AppSpacing.xxl,
    ),
    maxWidthTablet: 480.0,
    maxWidthDesktop: 560.0,
    radius: AppRadius.lg,
  );

  @override
  AppDialogTokens copyWith({
    EdgeInsets? insetPaddingMobile,
    EdgeInsets? insetPaddingTablet,
    EdgeInsets? insetPaddingDesktop,
    double? maxWidthTablet,
    double? maxWidthDesktop,
    double? radius,
  }) {
    return AppDialogTokens(
      insetPaddingMobile: insetPaddingMobile ?? this.insetPaddingMobile,
      insetPaddingTablet: insetPaddingTablet ?? this.insetPaddingTablet,
      insetPaddingDesktop: insetPaddingDesktop ?? this.insetPaddingDesktop,
      maxWidthTablet: maxWidthTablet ?? this.maxWidthTablet,
      maxWidthDesktop: maxWidthDesktop ?? this.maxWidthDesktop,
      radius: radius ?? this.radius,
    );
  }

  @override
  AppDialogTokens lerp(ThemeExtension<AppDialogTokens>? other, double t) {
    if (other is! AppDialogTokens) {
      return this;
    }
    return AppDialogTokens(
      insetPaddingMobile:
          EdgeInsets.lerp(insetPaddingMobile, other.insetPaddingMobile, t) ??
          insetPaddingMobile,
      insetPaddingTablet:
          EdgeInsets.lerp(insetPaddingTablet, other.insetPaddingTablet, t) ??
          insetPaddingTablet,
      insetPaddingDesktop:
          EdgeInsets.lerp(insetPaddingDesktop, other.insetPaddingDesktop, t) ??
          insetPaddingDesktop,
      maxWidthTablet:
          lerpDouble(maxWidthTablet, other.maxWidthTablet, t) ?? maxWidthTablet,
      maxWidthDesktop:
          lerpDouble(maxWidthDesktop, other.maxWidthDesktop, t) ??
          maxWidthDesktop,
      radius: lerpDouble(radius, other.radius, t) ?? radius,
    );
  }
}
