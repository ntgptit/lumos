import 'dart:ui';

import 'package:flutter/material.dart';

import '../foundation/app_radius.dart';
import '../foundation/app_spacing.dart';
import '../foundation/app_stroke.dart';

@immutable
class AppInputTokens extends ThemeExtension<AppInputTokens> {
  const AppInputTokens({
    required this.minHeight,
    required this.contentPadding,
    required this.borderRadius,
    required this.borderWidth,
    required this.focusedBorderWidth,
    required this.iconSize,
    required this.labelGap,
  });

  final double minHeight;
  final EdgeInsets contentPadding;
  final double borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;
  final double iconSize;
  final double labelGap;

  static const AppInputTokens defaults = AppInputTokens(
    minHeight: AppSpacing.xxxl + AppSpacing.lg,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    borderRadius: AppRadius.md,
    borderWidth: AppStroke.thin,
    focusedBorderWidth: AppStroke.medium,
    iconSize: AppSpacing.xl,
    labelGap: AppSpacing.xs,
  );

  @override
  AppInputTokens copyWith({
    double? minHeight,
    EdgeInsets? contentPadding,
    double? borderRadius,
    double? borderWidth,
    double? focusedBorderWidth,
    double? iconSize,
    double? labelGap,
  }) {
    return AppInputTokens(
      minHeight: minHeight ?? this.minHeight,
      contentPadding: contentPadding ?? this.contentPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      iconSize: iconSize ?? this.iconSize,
      labelGap: labelGap ?? this.labelGap,
    );
  }

  @override
  AppInputTokens lerp(ThemeExtension<AppInputTokens>? other, double t) {
    if (other is! AppInputTokens) {
      return this;
    }
    return AppInputTokens(
      minHeight: lerpDouble(minHeight, other.minHeight, t) ?? minHeight,
      contentPadding:
          EdgeInsets.lerp(contentPadding, other.contentPadding, t) ??
          contentPadding,
      borderRadius:
          lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      focusedBorderWidth:
          lerpDouble(focusedBorderWidth, other.focusedBorderWidth, t) ??
          focusedBorderWidth,
      iconSize: lerpDouble(iconSize, other.iconSize, t) ?? iconSize,
      labelGap: lerpDouble(labelGap, other.labelGap, t) ?? labelGap,
    );
  }

  @override
  int get hashCode => Object.hash(
    minHeight,
    contentPadding,
    borderRadius,
    borderWidth,
    focusedBorderWidth,
    iconSize,
    labelGap,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppInputTokens &&
        other.minHeight == minHeight &&
        other.contentPadding == contentPadding &&
        other.borderRadius == borderRadius &&
        other.borderWidth == borderWidth &&
        other.focusedBorderWidth == focusedBorderWidth &&
        other.iconSize == iconSize &&
        other.labelGap == labelGap;
  }
}
