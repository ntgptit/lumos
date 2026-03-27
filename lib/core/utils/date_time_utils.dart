abstract final class DateTimeUtils {
  static DateTime startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59, 999, 999);
  }

  static bool isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  static DateTime startOfWeek(
    DateTime value, {
    int firstDayOfWeek = DateTime.monday,
  }) {
    final normalized = startOfDay(value);
    final diff = (normalized.weekday - firstDayOfWeek) % DateTime.daysPerWeek;
    return normalized.subtract(Duration(days: diff));
  }

  static DateTime endOfWeek(
    DateTime value, {
    int firstDayOfWeek = DateTime.monday,
  }) {
    return endOfDay(
      startOfWeek(
        value,
        firstDayOfWeek: firstDayOfWeek,
      ).add(const Duration(days: DateTime.daysPerWeek - 1)),
    );
  }

  static bool isToday(DateTime value, {DateTime? now}) {
    return isSameDate(value, now ?? DateTime.now());
  }

  static int daysBetween(DateTime start, DateTime end) {
    return startOfDay(end).difference(startOfDay(start)).inDays.abs();
  }
}
