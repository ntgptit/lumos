import 'package:flutter/material.dart';
import 'package:lumos/core/theme/responsive/breakpoints.dart';

enum DeviceType { mobile, tablet, desktop }

extension DeviceTypeContextExt on BuildContext {
  DeviceType get deviceType {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppBreakpoints.largeMinWidth) {
      return DeviceType.desktop;
    }
    if (width >= AppBreakpoints.mediumMinWidth) {
      return DeviceType.tablet;
    }
    return DeviceType.mobile;
  }
}

extension DeviceTypeBoxConstraintsExt on BoxConstraints {
  bool get isDesktop => maxWidth >= AppBreakpoints.largeMinWidth;
  bool get isTablet {
    return maxWidth >= AppBreakpoints.mediumMinWidth &&
        maxWidth < AppBreakpoints.largeMinWidth;
  }
}
