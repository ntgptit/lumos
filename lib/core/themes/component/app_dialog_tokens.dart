import 'dart:ui';

import 'package:flutter/material.dart';

import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';

abstract final class AppDialogTokensConst {
  static const double tabletInsetHorizontalScale = 3.0;
  static const double desktopInsetHorizontalScale = 6.0;
  static const double tabletMaxWidthScale = 15.0;
  static const double desktopMaxWidthScale = 16.0;
  static const double desktopMaxWidthOffset = AppSpacing.xxl * 2;
}

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
      horizontal:
          AppSpacing.xxxl * AppDialogTokensConst.tabletInsetHorizontalScale,
      vertical: AppSpacing.xxl,
    ),
    insetPaddingDesktop: EdgeInsets.symmetric(
      horizontal:
          AppSpacing.xxxl * AppDialogTokensConst.desktopInsetHorizontalScale,
      vertical: AppSpacing.xxl,
    ),
    maxWidthTablet: AppSpacing.xxxl * AppDialogTokensConst.tabletMaxWidthScale,
    maxWidthDesktop:
        AppSpacing.xxxl * AppDialogTokensConst.desktopMaxWidthScale +
        AppDialogTokensConst.desktopMaxWidthOffset,
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

  @override
  int get hashCode => Object.hash(
    insetPaddingMobile,
    insetPaddingTablet,
    insetPaddingDesktop,
    maxWidthTablet,
    maxWidthDesktop,
    radius,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppDialogTokens &&
        other.insetPaddingMobile == insetPaddingMobile &&
        other.insetPaddingTablet == insetPaddingTablet &&
        other.insetPaddingDesktop == insetPaddingDesktop &&
        other.maxWidthTablet == maxWidthTablet &&
        other.maxWidthDesktop == maxWidthDesktop &&
        other.radius == radius;
  }
}
