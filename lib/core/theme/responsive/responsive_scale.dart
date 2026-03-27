import 'package:flutter/foundation.dart';

import '../../themes/foundation/app_responsive.dart';
import 'screen_info.dart';

@immutable
final class ResponsiveScale {
  const ResponsiveScale({
    required this.component,
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.spacing,
    required this.radius,
  });

  factory ResponsiveScale.fromScreenInfo(ScreenInfo screenInfo) {
    final double componentScale = _resolveScale(
      screenWidth: screenInfo.width,
      minimumScale: 0.85,
    );
    return ResponsiveScale(
      component: componentScale,
      display: _resolveScale(screenWidth: screenInfo.width, minimumScale: 0.78),
      headline: _resolveScale(
        screenWidth: screenInfo.width,
        minimumScale: 0.80,
      ),
      title: _resolveScale(screenWidth: screenInfo.width, minimumScale: 0.84),
      body: _resolveScale(screenWidth: screenInfo.width, minimumScale: 0.86),
      spacing: _resolveScale(screenWidth: screenInfo.width, minimumScale: 0.84),
      radius: _resolveRadiusScale(componentScale: componentScale),
    );
  }

  final double component;
  final double display;
  final double headline;
  final double title;
  final double body;
  final double spacing;
  final double radius;

  ResponsiveScale copyWith({
    double? component,
    double? display,
    double? headline,
    double? title,
    double? body,
    double? spacing,
    double? radius,
  }) {
    return ResponsiveScale(
      component: component ?? this.component,
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
    );
  }
}

double _resolveScale({
  required double screenWidth,
  required double minimumScale,
}) {
  const double maximumScale = 1.0;
  final double rawScale = screenWidth / ResponsiveDimensions.baseDesignWidth;
  if (rawScale <= minimumScale) {
    return minimumScale;
  }
  if (rawScale >= maximumScale) {
    return maximumScale;
  }
  return rawScale;
}

double _resolveRadiusScale({required double componentScale}) {
  const double maximumScale = 1.0;
  const double minimumRadiusScale = 0.94;
  final double radiusReduction = maximumScale - componentScale;
  final double candidate = maximumScale - (radiusReduction * 0.6);
  if (candidate <= minimumRadiusScale) {
    return minimumRadiusScale;
  }
  return candidate;
}
