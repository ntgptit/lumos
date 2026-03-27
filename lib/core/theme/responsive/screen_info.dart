import 'package:flutter/material.dart';

import 'screen_class.dart';

@immutable
final class ScreenInfo {
  const ScreenInfo({
    required this.width,
    required this.height,
    required this.textScaleFactor,
    required this.orientation,
    required this.screenClass,
    required this.platformBrightness,
  });

  factory ScreenInfo.fromMediaQueryData(MediaQueryData mediaQueryData) {
    return ScreenInfo(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height,
      textScaleFactor: mediaQueryData.textScaler.scale(1),
      orientation: mediaQueryData.orientation,
      screenClass: ScreenClass.fromWidth(mediaQueryData.size.width),
      platformBrightness: mediaQueryData.platformBrightness,
    );
  }

  final double width;
  final double height;
  final double textScaleFactor;
  final Orientation orientation;
  final ScreenClass screenClass;
  final Brightness platformBrightness;

  double get shortestSide {
    if (width <= height) {
      return width;
    }
    return height;
  }

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isCompact => screenClass.isCompact;
  bool get isMedium => screenClass.isMedium;
  bool get isExpanded => screenClass.isExpanded;
  bool get isLarge => screenClass.isLarge;

  ScreenInfo copyWith({
    double? width,
    double? height,
    double? textScaleFactor,
    Orientation? orientation,
    ScreenClass? screenClass,
    Brightness? platformBrightness,
  }) {
    return ScreenInfo(
      width: width ?? this.width,
      height: height ?? this.height,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      orientation: orientation ?? this.orientation,
      screenClass: screenClass ?? this.screenClass,
      platformBrightness: platformBrightness ?? this.platformBrightness,
    );
  }
}
