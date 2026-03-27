import 'package:flutter/foundation.dart';

abstract final class DeviceUtils {
  static bool get isWeb => kIsWeb;

  static TargetPlatform get platform => defaultTargetPlatform;

  static bool get isAndroid => platform == TargetPlatform.android;

  static bool get isIOS => platform == TargetPlatform.iOS;

  static bool get isApplePlatform {
    return switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => true,
      _ => false,
    };
  }

  static bool get isMobile {
    return switch (platform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }

  static bool get isDesktop {
    return switch (platform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      _ => false,
    };
  }
}
