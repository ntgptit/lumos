import 'app_material3_tokens.dart';

abstract final class Breakpoints {
  static const double kMobileMaxWidth =
      Material3BreakpointTokens.compactMaxWidth;
  static const double kTabletMaxWidth =
      Material3BreakpointTokens.mediumMaxWidth;
}

enum DeviceType { mobile, tablet, desktop }

abstract final class DeviceTypeHelper {
  static DeviceType fromWidth({required double width}) {
    if (width <= Breakpoints.kMobileMaxWidth) {
      return DeviceType.mobile;
    }
    if (width <= Breakpoints.kTabletMaxWidth) {
      return DeviceType.tablet;
    }
    return DeviceType.desktop;
  }
}
