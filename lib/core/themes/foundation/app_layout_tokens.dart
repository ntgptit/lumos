import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'app_radius.dart';

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
  static const double none = 0.0;
  static const double borderWidthRegular = 1.0;
  static const double minTouchTarget = 48.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightLarge = 48.0;
  static const double buttonMinWidth = 64.0;
  static const double dialogMinWidth = 340.0;
  static const double swipeActionWidth = 72.0;
  static const double progressIndicatorStrokeWidth = 2.0;
  static const double selectionElevationBoost = 1.0;
  static const double fabRegular = 56.0;
  static const double fabSmall = 40.0;
  static const double maxContentWidth = 1200.0;
  static const double appBarHeight = 64.0;
  static const double avatarSmall = 24.0;
  static const double avatarMedium = 32.0;
  static const double avatarLarge = 48.0;
  static const double navigationBarHeight = 80.0;
  static const double overlayMaxWidthTablet = 480.0;
  static const double overlayMaxWidthDesktop = 560.0;
  static const double progressTrackHeight = 4.0;
  static const double sliderTrackHeight = 4.0;
}

abstract final class WidgetRatios {
  static const double none = 0.0;
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
