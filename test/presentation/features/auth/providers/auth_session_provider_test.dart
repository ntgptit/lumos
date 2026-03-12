import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/auth/auth_repository_impl.dart';
import 'package:lumos/presentation/features/auth/providers/auth_session_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('AuthSessionController', () {
    test('build returns signed out when bootstrap has no session', () async {
      final FakeAuthRepository repository = FakeAuthRepository(
        bootstrapResult: null,
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final AuthViewState state = await container.read(
        authSessionControllerProvider.future,
      );

      expect(state.isAuthenticated, isFalse);
    });

    test('login updates authenticated state', () async {
      final FakeAuthRepository repository = FakeAuthRepository(
        bootstrapResult: null,
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authSessionControllerProvider.future);

      final bool result = await container
          .read(authSessionControllerProvider.notifier)
          .login(identifier: 'tester', password: 'password123');

      final AuthViewState state = container.read(authSessionControllerProvider).requireValue;
      expect(result, isTrue);
      expect(repository.lastIdentifier, 'tester');
      expect(state.isAuthenticated, isTrue);
      expect(state.session!.user.username, 'tester');
    });

    test('register stores error message when repository throws', () async {
      final FakeAuthRepository repository = FakeAuthRepository(
        bootstrapResult: null,
      )..registerError = StateError('register failed');
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authSessionControllerProvider.future);

      final bool result = await container
          .read(authSessionControllerProvider.notifier)
          .register(
            username: 'tester',
            email: 'tester@mail.com',
            password: 'password123',
          );

      final AuthViewState state = container.read(authSessionControllerProvider).requireValue;
      expect(result, isFalse);
      expect(state.errorMessage, contains('register failed'));
      expect(state.isAuthenticated, isFalse);
    });

    test('logout clears session state', () async {
      final FakeAuthRepository repository = FakeAuthRepository(
        bootstrapResult: sampleAuthSession(),
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authSessionControllerProvider.future);

      await container.read(authSessionControllerProvider.notifier).logout();

      final AuthViewState state = container.read(authSessionControllerProvider).requireValue;
      expect(repository.logoutCallCount, 1);
      expect(state.isAuthenticated, isFalse);
    });
  });

  group('AuthScreenModeController', () {
    test('setMode updates selected mode', () {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(authScreenModeControllerProvider.notifier)
          .setMode(AuthScreenModeState.register);

      expect(
        container.read(authScreenModeControllerProvider),
        AuthScreenModeState.register,
      );
    });
  });

  group('AuthViewState', () {
    test('copyWith updates fields and preserves session by default', () {
      final AuthViewState initial = AuthViewState(
        session: sampleAuthSession(),
        isBusy: false,
        errorMessage: null,
      );

      final AuthViewState updated = initial.copyWith(
        isBusy: true,
        errorMessage: 'failed',
      );

      expect(updated.session, same(initial.session));
      expect(updated.isBusy, isTrue);
      expect(updated.errorMessage, 'failed');
      expect(updated.isAuthenticated, isTrue);
    });
  });
}
