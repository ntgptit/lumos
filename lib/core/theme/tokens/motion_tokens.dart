import 'package:flutter/animation.dart';

import '../../themes/foundation/app_motion.dart';

export '../../themes/foundation/app_motion.dart' show AppMotion;
export '../../themes/foundation/app_motion_tokens.dart'
    show AppDurations, MotionDurations;

abstract final class MotionTokens {
  static Duration get instant => AppMotion.instant;
  static Duration get fast => AppMotion.fast;
  static Duration get medium => AppMotion.medium;
  static Duration get slow => AppMotion.slow;
  static Duration get verySlow => AppMotion.verySlow;

  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeOutCubic;
  static const Curve decelerateCurve = Curves.easeOut;
  static const Curve accelerateCurve = Curves.easeIn;
}
