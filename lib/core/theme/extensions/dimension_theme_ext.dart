import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/adaptive_component_size.dart';
import 'package:lumos/core/theme/responsive/adaptive_icon_size.dart';
import 'package:lumos/core/theme/responsive/adaptive_layout.dart';
import 'package:lumos/core/theme/responsive/adaptive_radius.dart';
import 'package:lumos/core/theme/responsive/adaptive_spacing.dart';
import 'package:lumos/core/theme/responsive/adaptive_typography.dart';

@immutable
class DimensionThemeExt extends ThemeExtension<DimensionThemeExt> {
  const DimensionThemeExt({
    required this.spacing,
    required this.radius,
    required this.typography,
    required this.iconSize,
    required this.componentSize,
    required this.layout,
  });

  final AdaptiveSpacing spacing;
  final AdaptiveRadius radius;
  final AdaptiveTypography typography;
  final AdaptiveIconSize iconSize;
  final AdaptiveComponentSize componentSize;
  final AdaptiveLayout layout;

  @override
  DimensionThemeExt copyWith({
    AdaptiveSpacing? spacing,
    AdaptiveRadius? radius,
    AdaptiveTypography? typography,
    AdaptiveIconSize? iconSize,
    AdaptiveComponentSize? componentSize,
    AdaptiveLayout? layout,
  }) {
    return DimensionThemeExt(
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      typography: typography ?? this.typography,
      iconSize: iconSize ?? this.iconSize,
      componentSize: componentSize ?? this.componentSize,
      layout: layout ?? this.layout,
    );
  }

  @override
  DimensionThemeExt lerp(ThemeExtension<DimensionThemeExt>? other, double t) {
    if (other is! DimensionThemeExt) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
