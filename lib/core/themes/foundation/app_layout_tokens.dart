import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'app_material3_tokens.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

abstract final class BorderRadii {
  static const BorderRadius small = BorderRadius.all(
    ui.Radius.circular(AppRadius.xs),
  );
  static const BorderRadius medium = BorderRadius.all(
    ui.Radius.circular(AppRadius.sm),
  );
  static const BorderRadius large = BorderRadius.all(
    ui.Radius.circular(AppRadius.md),
  );
  static const BorderRadius xLarge = BorderRadius.all(
    ui.Radius.circular(AppRadius.md),
  );
  static const BorderRadius xxLarge = BorderRadius.all(
    ui.Radius.circular(AppRadius.md),
  );
  static const BorderRadius pill = BorderRadius.all(
    ui.Radius.circular(AppRadius.pill),
  );
  static const BorderRadius topMedium = BorderRadius.only(
    topLeft: ui.Radius.circular(AppRadius.sm),
    topRight: ui.Radius.circular(AppRadius.sm),
  );
  static const BorderRadius topLarge = BorderRadius.only(
    topLeft: ui.Radius.circular(AppRadius.md),
    topRight: ui.Radius.circular(AppRadius.md),
  );
  static const BorderRadius topXLarge = BorderRadius.only(
    topLeft: ui.Radius.circular(AppRadius.md),
    topRight: ui.Radius.circular(AppRadius.md),
  );

  static BorderRadius circular(double radius) {
    return BorderRadius.all(ui.Radius.circular(radius));
  }

  static BorderRadius top(double radius) {
    return BorderRadius.only(
      topLeft: ui.Radius.circular(radius),
      topRight: ui.Radius.circular(radius),
    );
  }
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
  static const double none = AppSpacing.none;
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
  static const double none = AppSpacing.none;
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
