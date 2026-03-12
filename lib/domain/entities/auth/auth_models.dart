import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.accountStatus,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      accountStatus: json['accountStatus'] as String? ?? '',
    );
  }

  final int id;
  final String username;
  final String email;
  final String accountStatus;
}

@immutable
class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.authenticated,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AuthUser.fromJson((json['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}),
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int? ?? 0,
      authenticated: json['authenticated'] as bool? ?? false,
    );
  }

  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final bool authenticated;
}
