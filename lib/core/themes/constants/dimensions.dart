import 'dart:ui' as ui;

import 'package:flutter/material.dart';

abstract final class Material3SpacingTokens {
  static const double none = 0;
  static const double xSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xLarge = 20;
  static const double xxLarge = 24;
  static const double xxxLarge = 32;
  static const double section = 40;
  static const double page = 48;
  static const double canvas = 64;
}

abstract final class Material3ShapeTokens {
  static const double none = 0;
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double extraLarge = 20;
  static const double full = 100;
}

abstract final class Material3ComponentSizeTokens {
  static const double borderWidth = 1;
  static const double minTouchTarget = 48;

  static const double buttonHeight = 40;
  static const double buttonHeightLarge = 48;
  static const double buttonMinWidth = 64;
  static const double dialogMinWidth = 340;
  static const double swipeActionWidth = 72;
  static const double progressIndicatorStrokeWidth = 2;
  static const double selectionElevationBoost = 1;

  static const double fabRegular = 56;
  static const double fabSmall = 40;

  static const double appBarSmallHeight = 64;
  static const double navigationBarHeight = 80;

  static const double avatarSmall = 24;
  static const double avatarMedium = 32;
  static const double avatarLarge = 48;

  static const double overlayMaxWidthTablet = 480;
  static const double overlayMaxWidthDesktop = 560;

  static const double progressTrackHeight = 4;
  static const double sliderTrackHeight = 4;

  static const double maxContentWidth = 1200;
}

abstract final class Material3StateOpacityTokens {
  static const double transparent = 0;

  static const double divider = 0.12;
  static const double disabledContent = 0.38;

  static const double stateHover = 0.08;
  static const double stateFocus = 0.12;
  static const double statePress = 0.12;
  static const double stateDrag = 0.16;

  static const double scrimLight = 0.32;
  static const double scrimDark = 0.4;

  static const double lowEmphasis = 0.6;
  static const double hint = 0.38;
}

abstract final class Material3ElevationOpacityTokens {
  static const double level1 = 0.05;
  static const double level2 = 0.08;
  static const double level3 = 0.11;
  static const double level4 = 0.12;
  static const double level5 = 0.14;
}

abstract final class Material3BreakpointTokens {
  static const double compactMaxWidth = 600;
  static const double mediumMaxWidth = 840;
}

abstract final class Insets {
  static const double spacing0 = Material3SpacingTokens.none;
  static const double spacing4 = Material3SpacingTokens.xSmall;
  static const double spacing8 = Material3SpacingTokens.small;
  static const double spacing12 = Material3SpacingTokens.medium;
  static const double spacing16 = Material3SpacingTokens.large;
  static const double spacing20 = Material3SpacingTokens.xLarge;
  static const double spacing24 = Material3SpacingTokens.xxLarge;
  static const double spacing32 = Material3SpacingTokens.xxxLarge;
  static const double spacing40 = Material3SpacingTokens.section;
  static const double spacing48 = Material3SpacingTokens.page;
  static const double spacing64 = Material3SpacingTokens.canvas;

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
  static const double radiusNone = Material3ShapeTokens.none;
  static const double radiusSmall = Material3ShapeTokens.extraSmall;
  static const double radiusMedium = Material3ShapeTokens.small;
  static const double radiusLarge = Material3ShapeTokens.medium;
  static const double radiusXLarge = Material3ShapeTokens.large;
  static const double radiusXXLarge = Material3ShapeTokens.extraLarge;
  static const double radiusCircle = Material3ShapeTokens.full;

  static const double radiusSurface = radiusLarge;

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
  static const double borderWidthRegular =
      Material3ComponentSizeTokens.borderWidth;
  static const double minTouchTarget =
      Material3ComponentSizeTokens.minTouchTarget;

  static const double buttonHeightSmall =
      Material3ComponentSizeTokens.buttonHeight;
  static const double buttonHeightMedium =
      Material3ComponentSizeTokens.buttonHeight;
  static const double buttonHeightLarge =
      Material3ComponentSizeTokens.buttonHeightLarge;
  static const double buttonMinWidth =
      Material3ComponentSizeTokens.buttonMinWidth;
  static const double dialogMinWidth =
      Material3ComponentSizeTokens.dialogMinWidth;
  static const double swipeActionWidth =
      Material3ComponentSizeTokens.swipeActionWidth;
  static const double progressIndicatorStrokeWidth =
      Material3ComponentSizeTokens.progressIndicatorStrokeWidth;
  static const double selectionElevationBoost =
      Material3ComponentSizeTokens.selectionElevationBoost;

  static const double fabRegular = Material3ComponentSizeTokens.fabRegular;
  static const double fabSmall = Material3ComponentSizeTokens.fabSmall;

  static const double maxContentWidth =
      Material3ComponentSizeTokens.maxContentWidth;
  static const double appBarHeight =
      Material3ComponentSizeTokens.appBarSmallHeight;
  static const double avatarSmall = Material3ComponentSizeTokens.avatarSmall;
  static const double avatarMedium = Material3ComponentSizeTokens.avatarMedium;
  static const double avatarLarge = Material3ComponentSizeTokens.avatarLarge;
  static const double navigationBarHeight =
      Material3ComponentSizeTokens.navigationBarHeight;
  static const double overlayMaxWidthTablet =
      Material3ComponentSizeTokens.overlayMaxWidthTablet;
  static const double overlayMaxWidthDesktop =
      Material3ComponentSizeTokens.overlayMaxWidthDesktop;
  static const double progressTrackHeight =
      Material3ComponentSizeTokens.progressTrackHeight;
  static const double sliderTrackHeight =
      Material3ComponentSizeTokens.sliderTrackHeight;
}

abstract final class WidgetRatios {
  static const double none = Insets.spacing0;
  static const double half = 0.5;
  static const double full = 1;
  static const double transitionSlideOffsetY = 0.06;

  static const double swipeRevealExtent = 0.25;
  static const double swipeRevealThreshold = 0.35;

  static const double dialogWidthFactor = 0.84;
  static const double bottomSheetInitialHeightFactor = 0.9;

  static const double shimmerLineWidthShort = 0.6;
  static const double shimmerLineWidthMedium = 0.8;
  static const double shimmerLineWidthFull = full;
  static const double shimmerSecondaryBlendScale = 0.7;
  static const double shimmerTertiaryBlendScale = half;
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
  static const Duration slow = Duration(milliseconds: 360);
}

abstract final class MotionDurations {
  static const Duration animationFast = Duration(milliseconds: 180);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 360);
  static const Duration snackbar = Duration(seconds: 3);
  static const Duration tip = Duration(seconds: 5);
}

abstract final class FontSizes {
  static const double fontSizeSmall = 12;
  static const double fontSizeMedium = 14;
  static const double fontSizeLarge = 16;
  static const double fontSizeXLarge = 20;
  static const double fontSizeDisplay = 34;
}

abstract final class Breakpoints {
  static const double kMobileMaxWidth =
      Material3BreakpointTokens.compactMaxWidth;
  static const double kTabletMaxWidth =
      Material3BreakpointTokens.mediumMaxWidth;
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
