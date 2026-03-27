import 'app_layout_tokens.dart';

abstract final class Material3ComponentSizeTokens {
  static double get borderWidth => WidgetSizes.borderWidthRegular;
  static double get minTouchTarget => WidgetSizes.minTouchTarget;
  static double get buttonHeight => WidgetSizes.buttonHeightSmall;
  static double get buttonHeightLarge => WidgetSizes.buttonHeightLarge;
  static double get buttonMinWidth => WidgetSizes.buttonMinWidth;
  static double get dialogMinWidth => WidgetSizes.dialogMinWidth;
  static double get swipeActionWidth => WidgetSizes.swipeActionWidth;
  static double get progressIndicatorStrokeWidth =>
      WidgetSizes.progressIndicatorStrokeWidth;
  static double get selectionElevationBoost =>
      WidgetSizes.selectionElevationBoost;
  static double get fabRegular => WidgetSizes.fabRegular;
  static double get fabSmall => WidgetSizes.fabSmall;
  static double get appBarSmallHeight => WidgetSizes.appBarHeight;
  static double get navigationBarHeight => WidgetSizes.navigationBarHeight;
  static double get avatarSmall => WidgetSizes.avatarSmall;
  static double get avatarMedium => WidgetSizes.avatarMedium;
  static double get avatarLarge => WidgetSizes.avatarLarge;
  static double get overlayMaxWidthTablet => WidgetSizes.overlayMaxWidthTablet;
  static double get overlayMaxWidthDesktop =>
      WidgetSizes.overlayMaxWidthDesktop;
  static double get progressTrackHeight => WidgetSizes.progressTrackHeight;
  static double get sliderTrackHeight => WidgetSizes.sliderTrackHeight;
  static double get maxContentWidth => WidgetSizes.maxContentWidth;
}

abstract final class Material3BreakpointTokens {
  static const double compactMaxWidth = 600.0;
  static const double mediumMaxWidth = 840.0;
}
