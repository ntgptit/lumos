abstract interface class ClockService {
  DateTime now();
}

class SystemClockService implements ClockService {
  const SystemClockService();

  @override
  DateTime now() => DateTime.now();
}
