import 'package:flutter/material.dart';

import '../tokens/size_tokens.dart';
import 'responsive_scale.dart';

@immutable
final class AdaptiveComponentSize {
  const AdaptiveComponentSize({
    required this.minTouchTarget,
    required this.buttonHeightSmall,
    required this.buttonHeightMedium,
    required this.buttonHeightLarge,
    required this.buttonMinWidth,
    required this.dialogMinWidth,
    required this.appBarHeight,
    required this.navigationBarHeight,
    required this.maxContentWidth,
    required this.overlayMaxWidthTablet,
    required this.overlayMaxWidthDesktop,
    required this.progressTrackHeight,
    required this.sliderTrackHeight,
  });

  factory AdaptiveComponentSize.fromScale(ResponsiveScale scale) {
    return AdaptiveComponentSize(
      minTouchTarget: SizeTokens.minTouchTarget * scale.component,
      buttonHeightSmall: SizeTokens.buttonHeightSmall * scale.component,
      buttonHeightMedium: SizeTokens.buttonHeightMedium * scale.component,
      buttonHeightLarge: SizeTokens.buttonHeightLarge * scale.component,
      buttonMinWidth: SizeTokens.buttonMinWidth * scale.component,
      dialogMinWidth: SizeTokens.dialogMinWidth * scale.component,
      appBarHeight: SizeTokens.appBarHeight * scale.component,
      navigationBarHeight: SizeTokens.navigationBarHeight * scale.component,
      maxContentWidth: SizeTokens.maxContentWidth,
      overlayMaxWidthTablet: SizeTokens.overlayMaxWidthTablet,
      overlayMaxWidthDesktop: SizeTokens.overlayMaxWidthDesktop,
      progressTrackHeight: SizeTokens.progressTrackHeight,
      sliderTrackHeight: SizeTokens.sliderTrackHeight,
    );
  }

  final double minTouchTarget;
  final double buttonHeightSmall;
  final double buttonHeightMedium;
  final double buttonHeightLarge;
  final double buttonMinWidth;
  final double dialogMinWidth;
  final double appBarHeight;
  final double navigationBarHeight;
  final double maxContentWidth;
  final double overlayMaxWidthTablet;
  final double overlayMaxWidthDesktop;
  final double progressTrackHeight;
  final double sliderTrackHeight;

  AdaptiveComponentSize copyWith({
    double? minTouchTarget,
    double? buttonHeightSmall,
    double? buttonHeightMedium,
    double? buttonHeightLarge,
    double? buttonMinWidth,
    double? dialogMinWidth,
    double? appBarHeight,
    double? navigationBarHeight,
    double? maxContentWidth,
    double? overlayMaxWidthTablet,
    double? overlayMaxWidthDesktop,
    double? progressTrackHeight,
    double? sliderTrackHeight,
  }) {
    return AdaptiveComponentSize(
      minTouchTarget: minTouchTarget ?? this.minTouchTarget,
      buttonHeightSmall: buttonHeightSmall ?? this.buttonHeightSmall,
      buttonHeightMedium: buttonHeightMedium ?? this.buttonHeightMedium,
      buttonHeightLarge: buttonHeightLarge ?? this.buttonHeightLarge,
      buttonMinWidth: buttonMinWidth ?? this.buttonMinWidth,
      dialogMinWidth: dialogMinWidth ?? this.dialogMinWidth,
      appBarHeight: appBarHeight ?? this.appBarHeight,
      navigationBarHeight: navigationBarHeight ?? this.navigationBarHeight,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      overlayMaxWidthTablet:
          overlayMaxWidthTablet ?? this.overlayMaxWidthTablet,
      overlayMaxWidthDesktop:
          overlayMaxWidthDesktop ?? this.overlayMaxWidthDesktop,
      progressTrackHeight: progressTrackHeight ?? this.progressTrackHeight,
      sliderTrackHeight: sliderTrackHeight ?? this.sliderTrackHeight,
    );
  }
}
