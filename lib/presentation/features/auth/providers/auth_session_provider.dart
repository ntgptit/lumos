import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../../domain/entities/auth/auth_models.dart';
import '../../../../domain/repositories/auth/auth_repository.dart';

part 'auth_session_provider.g.dart';

class AuthViewState {
  const AuthViewState({
    required this.session,
    required this.isBusy,
    required this.errorMessage,
  });

  const AuthViewState.signedOut()
    : session = null,
      isBusy = false,
      errorMessage = null;

  final AuthSession? session;
  final bool isBusy;
  final String? errorMessage;

  bool get isAuthenticated => session?.authenticated ?? false;

  AuthViewState copyWith({
    AuthSession? session,
    bool? isBusy,
    Object? errorMessage = _unsetValue,
  }) {
    return AuthViewState(
      session: session ?? this.session,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: identical(errorMessage, _unsetValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const Object _unsetValue = Object();

@Riverpod(keepAlive: true)
class AuthScreenModeController extends _$AuthScreenModeController {
  @override
  AuthScreenModeState build() {
    return AuthScreenModeState.login;
  }

  void setMode(AuthScreenModeState mode) {
    state = mode;
  }
}

enum AuthScreenModeState { login, register }

@Riverpod(keepAlive: true)
class AuthSessionController extends _$AuthSessionController {
  @override
  Future<AuthViewState> build() async {
    final AuthRepository repository = ref.read(authRepositoryProvider);
    final AuthSession? session = await repository.bootstrapSession();
    if (session == null) {
      return const AuthViewState.signedOut();
    }
    return AuthViewState(session: session, isBusy: false, errorMessage: null);
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    return _runMutation(() async {
      final AuthRepository repository = ref.read(authRepositoryProvider);
      final AuthSession session = await repository.login(
        identifier: identifier,
        password: password,
      );
      return session;
    });
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return _runMutation(() async {
      final AuthRepository repository = ref.read(authRepositoryProvider);
      final AuthSession session = await repository.register(
        username: username,
        email: email,
        password: password,
      );
      return session;
    });
  }

  Future<void> logout() async {
    final AuthViewState currentState =
        state.asData?.value ?? const AuthViewState.signedOut();
    state = AsyncData<AuthViewState>(
      currentState.copyWith(isBusy: true, errorMessage: null),
    );
    try {
      final AuthRepository repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AsyncData<AuthViewState>(AuthViewState.signedOut());
    } on Object catch (error, stackTrace) {
      state = AsyncError<AuthViewState>(error, stackTrace);
      rethrow;
    }
  }

  Future<bool> _runMutation(Future<AuthSession> Function() action) async {
    final AuthViewState currentState =
        state.asData?.value ?? const AuthViewState.signedOut();
    state = AsyncData<AuthViewState>(
      currentState.copyWith(isBusy: true, errorMessage: null),
    );
    try {
      final AuthSession session = await action();
      state = AsyncData<AuthViewState>(
        AuthViewState(session: session, isBusy: false, errorMessage: null),
      );
      return true;
    } on Object catch (error) {
      state = AsyncData<AuthViewState>(
        currentState.copyWith(isBusy: false, errorMessage: error.toString()),
      );
      return false;
    }
  }
}
