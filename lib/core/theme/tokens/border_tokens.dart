import 'package:flutter/material.dart';

import '../../themes/foundation/app_stroke.dart';

export '../../themes/foundation/app_stroke.dart' show AppStroke;

abstract final class BorderTokens {
  static double get none => AppStroke.none;
  static double get thin => AppStroke.thin;
  static double get medium => AppStroke.medium;
  static double get thick => AppStroke.thick;

  static BorderSide side({
    required Color color,
    double width = AppStroke.thin,
  }) {
    return BorderSide(color: color, width: width);
  }
}
