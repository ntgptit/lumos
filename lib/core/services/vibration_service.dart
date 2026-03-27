abstract interface class VibrationService {
  Future<void> lightImpact();

  Future<void> mediumImpact();

  Future<void> heavyImpact();
}

class NoopVibrationService implements VibrationService {
  const NoopVibrationService();

  @override
  Future<void> lightImpact() async {}

  @override
  Future<void> mediumImpact() async {}

  @override
  Future<void> heavyImpact() async {}
}
