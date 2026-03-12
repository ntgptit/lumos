import '../../entities/auth/auth_models.dart';

abstract class AuthRepository {
  Future<AuthSession?> bootstrapSession();

  Future<AuthSession> login({
    required String identifier,
    required String password,
  });

  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logout();
}
