import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_invalidation_provider.g.dart';

@Riverpod(keepAlive: true)
class SessionInvalidationController extends _$SessionInvalidationController {
  @override
  int build() {
    return 0;
  }

  void invalidateSession() {
    state = state + 1;
  }
}
