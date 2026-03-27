import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';

@immutable
class ScreenInfo {
  const ScreenInfo({
    required this.width,
    required this.height,
    required this.orientation,
    required this.screenClass,
  });

  const ScreenInfo.fallback()
    : width = 390,
      height = 844,
      orientation = Orientation.portrait,
      screenClass = ScreenClass.compact;

  factory ScreenInfo.fromContext(BuildContext context) {
    return ScreenInfo.fromSize(
      MediaQuery.sizeOf(context),
      orientation: MediaQuery.orientationOf(context),
    );
  }

  factory ScreenInfo.fromSize(Size size, {Orientation? orientation}) {
    final resolvedOrientation =
        orientation ??
        (size.width >= size.height
            ? Orientation.landscape
            : Orientation.portrait);

    return ScreenInfo(
      width: size.width,
      height: size.height,
      orientation: resolvedOrientation,
      screenClass: ScreenClass.fromWidth(size.width),
    );
  }

  final double width;
  final double height;
  final Orientation orientation;
  final ScreenClass screenClass;

  bool get isCompact => screenClass == ScreenClass.compact;
  bool get isMedium => screenClass == ScreenClass.medium;
  bool get isExpanded => screenClass == ScreenClass.expanded;
  bool get isLarge => screenClass == ScreenClass.large;
}
