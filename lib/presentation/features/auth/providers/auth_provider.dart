import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumos/presentation/features/auth/providers/auth_session_provider.dart';

part 'auth_provider.g.dart';

class AuthControllerState {
  const AuthControllerState({
    required this.isCheckingSession,
    required this.isAuthenticated,
  });

  const AuthControllerState.signedOut()
    : isCheckingSession = false,
      isAuthenticated = false;

  final bool isCheckingSession;
  final bool isAuthenticated;
}

@Riverpod(keepAlive: true)
AuthControllerState authController(Ref ref) {
  final authAsync = ref.watch(authSessionControllerProvider);

  return authAsync.when(
    loading: () => const AuthControllerState(
      isCheckingSession: true,
      isAuthenticated: false,
    ),
    error: (_, _) => const AuthControllerState.signedOut(),
    data: (authState) => AuthControllerState(
      isCheckingSession: false,
      isAuthenticated: authState.isAuthenticated,
    ),
  );
}
