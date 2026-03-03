import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'app_material3_tokens.dart';

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
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
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
  static const double full = 1.0;
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
