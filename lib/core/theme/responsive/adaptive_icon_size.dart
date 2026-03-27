import 'package:flutter/material.dart';

import '../tokens/icon_tokens.dart';
import 'responsive_scale.dart';

@immutable
final class AdaptiveIconSize {
  const AdaptiveIconSize({
    required this.small,
    required this.medium,
    required this.large,
    required this.xLarge,
    required this.appBar,
    required this.bottomNavigation,
    required this.button,
  });

  factory AdaptiveIconSize.fromScale(ResponsiveScale scale) {
    return AdaptiveIconSize(
      small: IconTokens.small * scale.component,
      medium: IconTokens.medium * scale.component,
      large: IconTokens.large * scale.component,
      xLarge: IconTokens.xLarge * scale.component,
      appBar: IconTokens.appBar * scale.component,
      bottomNavigation: IconTokens.bottomNavigation * scale.component,
      button: IconTokens.button * scale.component,
    );
  }

  final double small;
  final double medium;
  final double large;
  final double xLarge;
  final double appBar;
  final double bottomNavigation;
  final double button;

  AdaptiveIconSize copyWith({
    double? small,
    double? medium,
    double? large,
    double? xLarge,
    double? appBar,
    double? bottomNavigation,
    double? button,
  }) {
    return AdaptiveIconSize(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
      appBar: appBar ?? this.appBar,
      bottomNavigation: bottomNavigation ?? this.bottomNavigation,
      button: button ?? this.button,
    );
  }
}
