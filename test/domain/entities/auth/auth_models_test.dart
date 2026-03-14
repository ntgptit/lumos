import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/auth/auth_models.dart';

void main() {
  group('Auth models', () {
    test('AuthUser.fromJson maps fields with defaults', () {
      final AuthUser user = AuthUser.fromJson(<String, dynamic>{
        'id': 7,
        'username': 'tester',
        'email': 'tester@mail.com',
        'accountStatus': 'ACTIVE',
      });

      expect(user.id, 7);
      expect(user.username, 'tester');
      expect(user.email, 'tester@mail.com');
      expect(user.accountStatus, 'ACTIVE');
    });

    test('AuthSession.fromJson maps nested user and session fields', () {
      final AuthSession session = AuthSession.fromJson(<String, dynamic>{
        'user': <String, dynamic>{
          'id': 7,
          'username': 'tester',
          'email': 'tester@mail.com',
          'accountStatus': 'ACTIVE',
        },
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
        'expiresIn': 900,
        'authenticated': true,
      });

      expect(session.user.username, 'tester');
      expect(session.accessToken, 'access-token');
      expect(session.refreshToken, 'refresh-token');
      expect(session.expiresIn, 900);
      expect(session.authenticated, isTrue);
    });
  });
}
