abstract interface class CrashlyticsService {
  Future<void> initialize();

  Future<void> log(String message);

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  });
}

class NoopCrashlyticsService implements CrashlyticsService {
  const NoopCrashlyticsService();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {}
}
