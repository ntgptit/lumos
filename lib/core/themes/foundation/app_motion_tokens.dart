import 'app_motion.dart';

abstract final class AppDurations {
  static const Duration fast = AppMotion.fast;
  static const Duration medium = AppMotion.medium;
  static const Duration slow = AppMotion.slow;
}

abstract final class MotionDurations {
  static const Duration animationFast = AppMotion.fast;
  static const Duration animationMedium = AppMotion.medium;
  static const Duration animationSlow = AppMotion.slow;
  static const Duration snackbar = Duration(seconds: 3);
  static const Duration tip = Duration(seconds: 5);
}
