import 'package:lumos/core/utils/date_time_utils.dart';

extension DateTimeExt on DateTime {
  DateTime get dateOnly => DateTimeUtils.startOfDay(this);
  DateTime get startOfDay => DateTimeUtils.startOfDay(this);
  DateTime get endOfDay => DateTimeUtils.endOfDay(this);

  bool isSameDate(DateTime other) {
    return DateTimeUtils.isSameDate(this, other);
  }

  bool isToday({DateTime? now}) {
    return DateTimeUtils.isToday(this, now: now);
  }

  DateTime startOfWeek({int firstDayOfWeek = DateTime.monday}) {
    return DateTimeUtils.startOfWeek(this, firstDayOfWeek: firstDayOfWeek);
  }

  DateTime endOfWeek({int firstDayOfWeek = DateTime.monday}) {
    return DateTimeUtils.endOfWeek(this, firstDayOfWeek: firstDayOfWeek);
  }

  int daysUntil(DateTime other) {
    return DateTimeUtils.daysBetween(this, other);
  }
}
