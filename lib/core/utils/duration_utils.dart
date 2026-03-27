abstract final class DurationUtils {
  static String formatClock(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours <= 0) {
      return '$minutes:$seconds';
    }

    return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
  }

  static String formatShort(Duration duration) {
    final totalSeconds = duration.inSeconds.abs();
    final days = totalSeconds ~/ Duration.secondsPerDay;
    final hours =
        (totalSeconds % Duration.secondsPerDay) ~/ Duration.secondsPerHour;
    final minutes =
        (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
    final seconds = totalSeconds % Duration.secondsPerMinute;

    if (days > 0) {
      return '${days}d ${hours}h';
    }
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  static int inWholeMinutes(Duration duration) {
    return duration.inSeconds ~/ Duration.secondsPerMinute;
  }
}
