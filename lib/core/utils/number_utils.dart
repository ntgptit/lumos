abstract final class NumberUtils {
  static double clampDouble(num value, {required num min, required num max}) {
    return value.clamp(min, max).toDouble();
  }

  static int clampInt(num value, {required int min, required int max}) {
    return value.clamp(min, max).toInt();
  }

  static double percentage({required num value, required num total}) {
    if (total == 0) {
      return 0;
    }
    return (value / total) * 100;
  }

  static String fixed(num value, [int fractionDigits = 0]) {
    return value.toStringAsFixed(fractionDigits);
  }

  static bool isBetween(
    num value, {
    required num min,
    required num max,
    bool inclusive = true,
  }) {
    if (inclusive) {
      return value >= min && value <= max;
    }
    return value > min && value < max;
  }

  static String percentageLabel({
    required num value,
    required num total,
    int fractionDigits = 0,
  }) {
    return '${percentage(value: value, total: total).toStringAsFixed(fractionDigits)}%';
  }
}
