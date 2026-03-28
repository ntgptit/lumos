import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/providers/network_providers.dart';
import '../../../domain/entities/auth/auth_models.dart';
import '../../../domain/repositories/auth/auth_repository.dart';

part 'auth_repository_impl.g.dart';

abstract final class AuthRepositoryImplConst {
  AuthRepositoryImplConst._();

  static const String authPath = '/api/v1/auth';
  static const String registerPath = '$authPath/register';
  static const String loginPath = '$authPath/login';
  static const String logoutPath = '$authPath/logout';
  static const String mePath = '$authPath/me';
}

class DioAuthRepository implements AuthRepository {
  const DioAuthRepository({
    required Dio dio,
    required FlutterSecureStorage storage,
  }) : _dio = dio,
       _storage = storage;

  final Dio _dio;
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> bootstrapSession() async {
    final String? accessToken = await _storage.read(
      key: StorageKeys.accessToken,
    );
    final String? refreshToken = await _storage.read(
      key: StorageKeys.refreshToken,
    );
    if ((accessToken ?? '').isEmpty && (refreshToken ?? '').isEmpty) {
      return null;
    }
    try {
      final Response<dynamic> meResponse = await _dio.get<dynamic>(
        AuthRepositoryImplConst.mePath,
      );
      final Map<String, dynamic> userJson = _castMap(meResponse.data);
      return AuthSession(
        user: AuthUser.fromJson(userJson),
        accessToken:
            await _storage.read(key: StorageKeys.accessToken) ??
            accessToken ??
            '',
        refreshToken:
            await _storage.read(key: StorageKeys.refreshToken) ??
            refreshToken ??
            '',
        expiresIn: 0,
        authenticated: true,
      );
    } on DioException catch (error) {
      if (_isUnauthorized(error)) {
        await _clearSession();
        return null;
      }

      rethrow;
    }
  }

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      AuthRepositoryImplConst.loginPath,
      data: <String, dynamic>{'identifier': identifier, 'password': password},
    );
    final AuthSession session = AuthSession.fromJson(_castMap(response.data));
    await _persistSession(session);
    return session;
  }

  @override
  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      AuthRepositoryImplConst.registerPath,
      data: <String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
      },
    );
    final AuthSession session = AuthSession.fromJson(_castMap(response.data));
    await _persistSession(session);
    return session;
  }

  @override
  Future<void> logout() async {
    final String? refreshToken = await _storage.read(
      key: StorageKeys.refreshToken,
    );
    if ((refreshToken ?? '').isEmpty) {
      await _clearSession();
      return;
    }
    try {
      await _dio.post<dynamic>(
        AuthRepositoryImplConst.logoutPath,
        data: <String, dynamic>{'refreshToken': refreshToken},
      );
    } on Object {
      await _clearSession();
      rethrow;
    }
    await _clearSession();
  }

  Future<void> _persistSession(AuthSession session) async {
    await _storage.write(
      key: StorageKeys.accessToken,
      value: session.accessToken,
    );
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: session.refreshToken,
    );
    await _storage.write(key: StorageKeys.userId, value: '${session.user.id}');
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);
  }

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }

  bool _isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  final FlutterSecureStorage storage = ref.watch(secureStorageProvider);
  return DioAuthRepository(dio: dio, storage: storage);
}
