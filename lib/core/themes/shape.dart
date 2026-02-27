import 'package:flutter/material.dart';

import 'constants/dimensions.dart';

class AppShape {
  const AppShape._();

  static RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radius.radiusButton),
    );
  }

  static RoundedRectangleBorder cardShape({BorderSide side = BorderSide.none}) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radius.radiusCard),
      side: side,
    );
  }

  static RoundedRectangleBorder dialogShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radius.radiusDialog),
    );
  }

  static ContinuousRectangleBorder navigationShape() {
    return ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(Radius.radiusMedium),
    );
  }

  static OutlineInputBorder inputShape({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radius.radiusMedium),
      borderSide: BorderSide(color: borderColor),
    );
  }
}
