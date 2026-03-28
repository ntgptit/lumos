import 'package:flutter/services.dart';

mixin HapticFeedbackMixin {
  void hapticLight() => HapticFeedback.lightImpact();

  void hapticMedium() => HapticFeedback.mediumImpact();

  void hapticHeavy() => HapticFeedback.heavyImpact();

  void hapticSelection() => HapticFeedback.selectionClick();

  void hapticVibrate() => HapticFeedback.vibrate();
}
