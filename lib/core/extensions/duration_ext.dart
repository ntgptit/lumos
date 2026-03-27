import 'package:lumos/core/utils/duration_utils.dart';

extension DurationExt on Duration {
  int get totalSeconds => inSeconds;
  int get totalMinutes => DurationUtils.inWholeMinutes(this);
  bool get isZeroDuration => this == Duration.zero;

  String toClockText() => DurationUtils.formatClock(this);

  String toShortText() => DurationUtils.formatShort(this);
}
