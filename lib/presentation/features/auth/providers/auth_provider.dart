import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final authControllerProvider = Provider<AuthControllerState>((ref) {
  return const AuthControllerState.signedOut();
});
