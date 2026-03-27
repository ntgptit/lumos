import 'package:flutter/animation.dart';

abstract final class AppMotionTokens {
  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
  static const emphasized = Duration(milliseconds: 550);

  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutCubicEmphasized;
  static const Curve entranceCurve = Curves.easeOutQuart;
  static const Curve exitCurve = Curves.easeInQuart;
}
