import 'package:flutter/material.dart';

import '../responsive/adaptive_component_size.dart';
import '../responsive/adaptive_icon_size.dart';
import '../responsive/adaptive_layout.dart';
import '../responsive/adaptive_radius.dart';
import '../responsive/adaptive_spacing.dart';
import '../responsive/responsive_scale.dart';
import '../responsive/screen_info.dart';

@immutable
final class DimensionThemeExt extends ThemeExtension<DimensionThemeExt> {
  const DimensionThemeExt({
    required this.screenInfo,
    required this.scale,
    required this.spacing,
    required this.radius,
    required this.iconSize,
    required this.componentSize,
    required this.layout,
  });

  factory DimensionThemeExt.fromMediaQueryData(MediaQueryData mediaQueryData) {
    final ScreenInfo screenInfo = ScreenInfo.fromMediaQueryData(mediaQueryData);
    final ResponsiveScale scale = ResponsiveScale.fromScreenInfo(screenInfo);
    final AdaptiveSpacing spacing = AdaptiveSpacing.fromScale(scale);
    final AdaptiveRadius radius = AdaptiveRadius.fromScale(scale);
    final AdaptiveIconSize iconSize = AdaptiveIconSize.fromScale(scale);
    final AdaptiveComponentSize componentSize = AdaptiveComponentSize.fromScale(
      scale,
    );
    final AdaptiveLayout layout = AdaptiveLayout.fromScreenInfo(
      screenInfo: screenInfo,
      spacing: spacing,
      componentSize: componentSize,
    );
    return DimensionThemeExt(
      screenInfo: screenInfo,
      scale: scale,
      spacing: spacing,
      radius: radius,
      iconSize: iconSize,
      componentSize: componentSize,
      layout: layout,
    );
  }

  final ScreenInfo screenInfo;
  final ResponsiveScale scale;
  final AdaptiveSpacing spacing;
  final AdaptiveRadius radius;
  final AdaptiveIconSize iconSize;
  final AdaptiveComponentSize componentSize;
  final AdaptiveLayout layout;

  @override
  DimensionThemeExt copyWith({
    ScreenInfo? screenInfo,
    ResponsiveScale? scale,
    AdaptiveSpacing? spacing,
    AdaptiveRadius? radius,
    AdaptiveIconSize? iconSize,
    AdaptiveComponentSize? componentSize,
    AdaptiveLayout? layout,
  }) {
    return DimensionThemeExt(
      screenInfo: screenInfo ?? this.screenInfo,
      scale: scale ?? this.scale,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
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
    if (t < 0.5) {
      return this;
    }
    return other;
  }
}
