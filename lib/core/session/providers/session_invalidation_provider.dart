import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_invalidation_provider.g.dart';

/// Monotonically-incrementing counter. Listeners react to any increment by
/// treating the session as invalid (e.g. signed out by the server).
@Riverpod(keepAlive: true)
class SessionInvalidationController extends _$SessionInvalidationController {
  @override
  int build() => 0;

  void invalidate() {
    state = state + 1;
  }
}
