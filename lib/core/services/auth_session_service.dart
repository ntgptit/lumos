import 'dart:async';

enum AuthSessionEvent { expired }

class AuthSessionService {
  AuthSessionService();

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast(sync: true);

  Stream<AuthSessionEvent> get events => _controller.stream;

  void notifyExpired() {
    if (_controller.isClosed) {
      return;
    }

    _controller.add(AuthSessionEvent.expired);
  }

  Future<void> dispose() {
    return _controller.close();
  }
}
