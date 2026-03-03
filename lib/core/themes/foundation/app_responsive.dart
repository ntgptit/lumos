import 'package:flutter/material.dart';

import 'app_breakpoint_tokens.dart';
import 'app_layout_tokens.dart';

abstract final class ResponsiveDimensions {
  static const double baseDesignWidth = 390.0;
  static const double minScaleFactor = 0.9;
  static const double maxScaleFactor = 1.2;
  static const double minPercentage = 0.0;
  static const double maxPercentage = 1.0;

  static double adaptive({
    required BuildContext context,
    required double baseValue,
    double minScale = minScaleFactor,
    double maxScale = maxScaleFactor,
  }) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double rawScale = screenWidth / baseDesignWidth;
    if (rawScale < minScale) {
      return baseValue * minScale;
    }
    if (rawScale > maxScale) {
      return baseValue * maxScale;
    }
    return baseValue * rawScale;
  }

  static EdgeInsets pagePadding({required BuildContext context}) {
    return EdgeInsets.symmetric(
      horizontal: adaptive(context: context, baseValue: Insets.paddingScreen),
      vertical: adaptive(context: context, baseValue: Insets.gapBetweenItems),
    );
  }

  static double screenWidthPercentage({
    required BuildContext context,
    required double percentage,
  }) {
    if (percentage < minPercentage) {
      throw ArgumentError.value(
        percentage,
        'percentage',
        'percentage must be between 0 and 1',
      );
    }
    if (percentage > maxPercentage) {
      throw ArgumentError.value(
        percentage,
        'percentage',
        'percentage must be between 0 and 1',
      );
    }
    return MediaQuery.sizeOf(context).width * percentage;
  }

  static double screenHeightPercentage({
    required BuildContext context,
    required double percentage,
  }) {
    if (percentage < minPercentage) {
      throw ArgumentError.value(
        percentage,
        'percentage',
        'percentage must be between 0 and 1',
      );
    }
    if (percentage > maxPercentage) {
      throw ArgumentError.value(
        percentage,
        'percentage',
        'percentage must be between 0 and 1',
      );
    }
    return MediaQuery.sizeOf(context).height * percentage;
  }
}

extension ResponsiveContextX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  double screenWidthPercentage(double percentage) {
    return ResponsiveDimensions.screenWidthPercentage(
      context: this,
      percentage: percentage,
    );
  }

  double screenHeightPercentage(double percentage) {
    return ResponsiveDimensions.screenHeightPercentage(
      context: this,
      percentage: percentage,
    );
  }

  DeviceType get deviceType {
    return DeviceTypeHelper.fromWidth(width: screenWidth);
  }

  bool get isMobile {
    return deviceType == DeviceType.mobile;
  }

  bool get isTablet {
    return deviceType == DeviceType.tablet;
  }

  bool get isDesktop {
    return deviceType == DeviceType.desktop;
  }
}

extension ResponsiveConstraintsX on BoxConstraints {
  DeviceType get deviceType {
    return DeviceTypeHelper.fromWidth(width: maxWidth);
  }

  bool get isMobile {
    return deviceType == DeviceType.mobile;
  }

  bool get isTablet {
    return deviceType == DeviceType.tablet;
  }

  bool get isDesktop {
    return deviceType == DeviceType.desktop;
  }
}

extension PercentDimensionX on double {
  double percentWidth(BuildContext context) {
    return ResponsiveDimensions.screenWidthPercentage(
      context: context,
      percentage: this,
    );
  }

  double percentHeight(BuildContext context) {
    return ResponsiveDimensions.screenHeightPercentage(
      context: context,
      percentage: this,
    );
  }
}
