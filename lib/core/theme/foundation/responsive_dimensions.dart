import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';

abstract final class ResponsiveDimensions {
  static const double compactInsetScale = 0.9;
  static const double compactLargeInsetScale = 0.94;
  static const double compactVerticalInsetScale = 0.88;
  static const double compactOuterInsetScale = 0.84;

  static double compactValue({
    required BuildContext context,
    required double baseValue,
    required double minScale,
  }) {
    final ScreenInfo screenInfo = ScreenInfo.fromContext(context);
    if (!screenInfo.isCompact) {
      return baseValue;
    }

    const double baselineWidth = 390;
    final double widthScale = (screenInfo.width / baselineWidth).clamp(
      minScale,
      1.0,
    );
    return baseValue * widthScale;
  }

  static EdgeInsets compactInsets({
    required BuildContext context,
    required EdgeInsets baseInsets,
    double minScale = compactInsetScale,
  }) {
    return EdgeInsets.fromLTRB(
      compactValue(
        context: context,
        baseValue: baseInsets.left,
        minScale: minScale,
      ),
      compactValue(
        context: context,
        baseValue: baseInsets.top,
        minScale: minScale,
      ),
      compactValue(
        context: context,
        baseValue: baseInsets.right,
        minScale: minScale,
      ),
      compactValue(
        context: context,
        baseValue: baseInsets.bottom,
        minScale: minScale,
      ),
    );
  }
}
