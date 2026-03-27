import 'package:lumos/core/utils/number_utils.dart';

extension NumExt on num {
  bool get isZeroValue => this == 0;

  double clampToDouble(num min, num max) {
    return NumberUtils.clampDouble(this, min: min, max: max);
  }

  int clampToInt(int min, int max) {
    return NumberUtils.clampInt(this, min: min, max: max);
  }

  bool isBetween(num min, num max, {bool inclusive = true}) {
    return NumberUtils.isBetween(
      this,
      min: min,
      max: max,
      inclusive: inclusive,
    );
  }

  String percentageLabelOf(num total, {int fractionDigits = 0}) {
    return NumberUtils.percentageLabel(
      value: this,
      total: total,
      fractionDigits: fractionDigits,
    );
  }

  Duration get milliseconds => Duration(milliseconds: round());

  Duration get seconds {
    return Duration(
      milliseconds: (this * Duration.millisecondsPerSecond).round(),
    );
  }
}
