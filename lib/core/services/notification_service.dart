import 'package:flutter/foundation.dart';

@immutable
class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    this.payload = const <String, String>{},
  });

  final String id;
  final String title;
  final String body;
  final Map<String, String> payload;
}

abstract interface class NotificationService {
  Future<void> initialize();

  Future<bool> requestPermission();

  Future<void> show(NotificationMessage message);
}

class NoopNotificationService implements NotificationService {
  const NoopNotificationService();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async {
    return false;
  }

  @override
  Future<void> show(NotificationMessage message) async {}
}
