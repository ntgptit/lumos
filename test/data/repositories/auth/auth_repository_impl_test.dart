import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/storage/storage_keys.dart';
import 'package:lumos/data/repositories/auth/auth_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DioAuthRepository', () {
    test('bootstrapSession returns null when no tokens exist', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      final DioAuthRepository repository = DioAuthRepository(
        dio: Dio(),
        storage: const FlutterSecureStorage(),
      );

      final session = await repository.bootstrapSession();

      expect(session, isNull);
    });

    test('bootstrapSession returns stored tokens when profile lookup succeeds', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.accessToken: 'access-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) async {
        expect(options.path, AuthRepositoryImplConst.mePath);
        return _jsonResponseBody(
          statusCode: 200,
          payload: <String, dynamic>{
            'id': 7,
            'username': 'tester',
            'email': 'tester@mail.com',
            'accountStatus': 'ACTIVE',
          },
        );
      });
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final DioAuthRepository repository = DioAuthRepository(
        dio: dio,
        storage: storage,
      );

      final session = await repository.bootstrapSession();

      expect(session, isNotNull);
      expect(session!.accessToken, 'access-token');
      expect(session.refreshToken, 'refresh-token');
      expect(session.user.username, 'tester');
      expect(session.authenticated, isTrue);
    });

    test('bootstrapSession clears persisted session when me returns 401', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.accessToken: 'expired-token',
        StorageKeys.refreshToken: 'refresh-token',
        StorageKeys.userId: '7',
      });
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) async {
        return _jsonResponseBody(
          statusCode: 401,
          payload: const <String, dynamic>{},
        );
      });
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final DioAuthRepository repository = DioAuthRepository(
        dio: dio,
        storage: storage,
      );

      final session = await repository.bootstrapSession();

      expect(session, isNull);
      expect(await storage.read(key: StorageKeys.accessToken), isNull);
      expect(await storage.read(key: StorageKeys.refreshToken), isNull);
      expect(await storage.read(key: StorageKeys.userId), isNull);
    });

    test('bootstrapSession rethrows non-401 errors and keeps tokens intact', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.accessToken: 'access-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'Network unavailable.',
        );
      });
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final DioAuthRepository repository = DioAuthRepository(
        dio: dio,
        storage: storage,
      );

      await expectLater(
        repository.bootstrapSession(),
        throwsA(isA<DioException>()),
      );
      expect(await storage.read(key: StorageKeys.accessToken), 'access-token');
      expect(await storage.read(key: StorageKeys.refreshToken), 'refresh-token');
    });

    test('login register and logout persist session lifecycle', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.refreshToken: 'refresh-token',
      });
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _CallbackHttpClientAdapter((RequestOptions options) async {
        final payload = <String, dynamic>{
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
        };

        if (options.path == AuthRepositoryImplConst.loginPath ||
            options.path == AuthRepositoryImplConst.registerPath) {
          return _jsonResponseBody(statusCode: 200, payload: payload);
        }

        if (options.path == AuthRepositoryImplConst.logoutPath) {
          return _jsonResponseBody(statusCode: 204, payload: const <String, dynamic>{});
        }

        throw StateError('Unexpected path: ${options.path}');
      });
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final DioAuthRepository repository = DioAuthRepository(
        dio: dio,
        storage: storage,
      );

      final loginSession = await repository.login(
        identifier: 'tester',
        password: 'password123',
      );
      final registerSession = await repository.register(
        username: 'tester',
        email: 'tester@mail.com',
        password: 'password123',
      );

      expect(loginSession.user.username, 'tester');
      expect(registerSession.refreshToken, 'refresh-token');
      expect(await storage.read(key: StorageKeys.userId), '7');

      await repository.logout();

      expect(await storage.read(key: StorageKeys.accessToken), isNull);
      expect(await storage.read(key: StorageKeys.refreshToken), isNull);
    });
  });
}

ResponseBody _jsonResponseBody({
  required int statusCode,
  required Map<String, dynamic> payload,
}) {
  return ResponseBody.fromString(
    jsonEncode(payload),
    statusCode,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

class _CallbackHttpClientAdapter implements HttpClientAdapter {
  _CallbackHttpClientAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
