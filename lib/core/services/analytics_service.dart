abstract interface class AnalyticsService {
  Future<void> initialize();

  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  });

  Future<void> setUserId(String? userId);
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}
