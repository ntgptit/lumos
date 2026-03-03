import 'app_opacity.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_stroke.dart';

abstract final class Material3SpacingTokens {
  static const double none = AppSpacing.none;
  static const double xSmall = AppSpacing.xs;
  static const double small = AppSpacing.sm;
  static const double medium = AppSpacing.md;
  static const double large = AppSpacing.lg;
  static const double xLarge = AppSpacing.xl;
  static const double xxLarge = AppSpacing.xxl;
  static const double xxxLarge = AppSpacing.xxxl;
  static const double section = 40.0;
  static const double page = 48.0;
  static const double canvas = 64.0;
}

abstract final class Material3ShapeTokens {
  static const double none = AppSpacing.none;
  static const double extraSmall = AppRadius.xs;
  static const double small = AppRadius.sm;
  static const double medium = AppRadius.md;
  static const double large = AppRadius.lg;
  static const double extraLarge = AppRadius.xl;
  static const double full = AppRadius.pill;
}

abstract final class Material3ComponentSizeTokens {
  static const double borderWidth = AppStroke.thin;
  static const double minTouchTarget = 48.0;
  static const double buttonHeight = 40.0;
  static const double buttonHeightLarge = 48.0;
  static const double buttonMinWidth = 64.0;
  static const double dialogMinWidth = 340.0;
  static const double swipeActionWidth = 72.0;
  static const double progressIndicatorStrokeWidth = 2.0;
  static const double selectionElevationBoost = 1.0;
  static const double fabRegular = 56.0;
  static const double fabSmall = 40.0;
  static const double appBarSmallHeight = 64.0;
  static const double navigationBarHeight = 80.0;
  static const double avatarSmall = 24.0;
  static const double avatarMedium = 32.0;
  static const double avatarLarge = 48.0;
  static const double overlayMaxWidthTablet = 480.0;
  static const double overlayMaxWidthDesktop = 560.0;
  static const double progressTrackHeight = 4.0;
  static const double sliderTrackHeight = 4.0;
  static const double maxContentWidth = 1200.0;
}

abstract final class Material3StateOpacityTokens {
  static const double transparent = 0.0;
  static const double divider = AppOpacity.soft;
  static const double disabledContent = AppOpacity.disabled;
  static const double stateHover = AppOpacity.subtle;
  static const double stateFocus = AppOpacity.soft;
  static const double statePress = AppOpacity.soft;
  static const double stateDrag = AppOpacity.medium;
  static const double scrimLight = 0.32;
  static const double scrimDark = 0.40;
  static const double lowEmphasis = 0.60;
  static const double hint = AppOpacity.disabled;
}

abstract final class Material3ElevationOpacityTokens {
  static const double level1 = 0.05;
  static const double level2 = 0.08;
  static const double level3 = 0.11;
  static const double level4 = 0.12;
  static const double level5 = 0.14;
}

abstract final class Material3BreakpointTokens {
  static const double compactMaxWidth = 600.0;
  static const double mediumMaxWidth = 840.0;
}
