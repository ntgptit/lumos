import 'dart:ui' as ui;

import 'package:flutter/material.dart';

abstract final class Insets {
  static const double spacing0 = 0;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  static const double paddingScreen = spacing16;
  static const double gapBetweenItems = spacing12;
  static const double gapBetweenSections = spacing24;

  static const EdgeInsets screenPadding = EdgeInsets.all(paddingScreen);
  static const EdgeInsets itemGapPadding = EdgeInsets.all(gapBetweenItems);
  static const EdgeInsets sectionGapPadding = EdgeInsets.all(
    gapBetweenSections,
  );
}

abstract final class Radius {
  static const double radiusNone = 0;
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  static const double radiusCircle = 100;
  static const double radiusSurface = radiusMedium;

  static const double radiusButton = radiusSurface;
  static const double radiusCard = radiusSurface;
  static const double radiusDialog = radiusSurface;
}

abstract final class BorderRadii {
  static const BorderRadius medium = BorderRadius.all(
    ui.Radius.circular(Radius.radiusMedium),
  );
  static const BorderRadius large = BorderRadius.all(
    ui.Radius.circular(Radius.radiusLarge),
  );
  static const BorderRadius topMedium = BorderRadius.only(
    topLeft: ui.Radius.circular(Radius.radiusMedium),
    topRight: ui.Radius.circular(Radius.radiusMedium),
  );
}

abstract final class IconSizes {
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  static const double iconAppBar = iconMedium;
  static const double iconBottomNavBar = iconMedium;
  static const double iconButton = iconSmall;
}

abstract final class WidgetSizes {
  static const double none = Insets.spacing0;
  static const double borderWidthRegular = 1.2;
  static const double minTouchTarget = 48;

  static const double buttonHeightSmall = 32;
  static const double buttonHeightMedium = 40;
  static const double buttonHeightLarge = 48;
  static const double maxContentWidth = 1200;
  static const double appBarHeight = kToolbarHeight;
  static const double avatarSmall = 24;
  static const double avatarMedium = 32;
  static const double avatarLarge = 48;
  static const double navigationBarHeight = appBarHeight + Radius.radiusLarge;
}

abstract final class WidgetOpacities {
  static const double transparent = Insets.spacing0;

  static const double divider = 0.12;

  static const double scrimLight = 0.32;
  static const double scrimDark = 0.4;

  static const double disabledContent = 0.38;

  static const double stateHover = 0.08;
  static const double stateFocus = 0.12;
  static const double statePress = 0.12;
  static const double stateDrag = 0.16;

  static const double elevationLevel1 = 0.05;
  static const double elevationLevel2 = 0.08;
  static const double elevationLevel3 = 0.11;
  static const double elevationLevel4 = 0.12;
  static const double elevationLevel5 = 0.14;

  static const double lowEmphasis = Insets.spacing0;
  static const double hint = Insets.spacing0;
  static const double hintCustom = 0.38;
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 250);
}

abstract final class MotionDurations {
  static const Duration animationFast = Duration(milliseconds: 180);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration snackbar = Duration(seconds: 3);
  static const Duration tip = Duration(seconds: 5);
}

abstract final class FontSizes {
  static const double fontSizeSmall = 12;
  static const double fontSizeMedium = 14;
  static const double fontSizeLarge = 16;
  static const double fontSizeXLarge = 20;
  static const double fontSizeDisplay = 24;
}

abstract final class Breakpoints {
  static const double kMobileMaxWidth = 600;
  static const double kTabletMaxWidth = 1200;
}

enum DeviceType { mobile, tablet, desktop }

abstract final class DeviceTypeHelper {
  static DeviceType fromWidth({required double width}) {
    if (width <= Breakpoints.kMobileMaxWidth) {
      return DeviceType.mobile;
    }
    if (width <= Breakpoints.kTabletMaxWidth) {
      return DeviceType.tablet;
    }
    return DeviceType.desktop;
  }
}

abstract final class ResponsiveDimensions {
  static const double baseDesignWidth = 390;
  static const double minScaleFactor = 0.9;
  static const double maxScaleFactor = 1.2;
  static const double minPercentage = 0;
  static const double maxPercentage = 1;

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
