import 'package:flutter/animation.dart';
import 'package:lumos/core/theme/tokens/interaction/motion_tokens.dart';
import 'package:lumos/core/theme/tokens/layout/border_tokens.dart';
import 'package:lumos/core/theme/tokens/visual/opacity_tokens.dart';

abstract final class AppDurations {
  static const Duration fast = AppMotionTokens.fast;
  static const Duration medium = AppMotionTokens.medium;
  static const Duration slow = AppMotionTokens.slow;
  static const Duration toast = Duration(seconds: 3);
  static const Duration stagger = Duration(milliseconds: 50);
}

abstract final class AppMotion {
  static const Duration fast = AppMotionTokens.fast;
  static const Duration medium = AppMotionTokens.medium;
  static const Duration slow = AppMotionTokens.slow;
  static const Duration verySlow = AppMotionTokens.emphasized;

  static const Curve standardCurve = AppMotionTokens.standardCurve;
  static const Curve emphasizedCurve = AppMotionTokens.emphasizedCurve;
}

abstract final class AppOpacity {
  static const double transparent = 0;
  static const double subtle = AppOpacityTokens.subtle;
  static const double lowEmphasis = AppOpacityTokens.muted;
  static const double stateHover = AppOpacityTokens.subtle;
  static const double strong = AppOpacityTokens.strong;
  static const double scrimLight = AppOpacityTokens.outline;
}

abstract final class AppStroke {
  static const double thin = AppBorderTokens.thin;
}
