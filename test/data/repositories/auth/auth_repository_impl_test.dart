import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/constants/storage_keys.dart';
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

    test('bootstrapSession refreshes when me returns 401', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.accessToken: 'expired-token',
        StorageKeys.refreshToken: 'refresh-token',
      });
      final Dio dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
            if (options.path == AuthRepositoryImplConst.mePath) {
              handler.reject(
                DioException.badResponse(
                  statusCode: 401,
                  requestOptions: options,
                  response: Response<dynamic>(
                    requestOptions: options,
                    statusCode: 401,
                  ),
                ),
              );
              return;
            }
            if (options.path == AuthRepositoryImplConst.refreshPath) {
              handler.resolve(
                Response<dynamic>(
                  requestOptions: options,
                  data: <String, dynamic>{
                    'user': <String, dynamic>{
                      'id': 7,
                      'username': 'tester',
                      'email': 'tester@mail.com',
                      'accountStatus': 'ACTIVE',
                    },
                    'accessToken': 'new-access-token',
                    'refreshToken': 'new-refresh-token',
                    'expiresIn': 900,
                    'authenticated': true,
                  },
                ),
              );
              return;
            }
            handler.next(options);
          },
        ),
      );
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      final DioAuthRepository repository = DioAuthRepository(
        dio: dio,
        storage: storage,
      );

      final session = await repository.bootstrapSession();

      expect(session, isNotNull);
      expect(session!.accessToken, 'new-access-token');
      expect(await storage.read(key: StorageKeys.accessToken), 'new-access-token');
    });

    test('login register and logout persist session lifecycle', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        StorageKeys.refreshToken: 'refresh-token',
      });
      final Dio dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
            final Map<String, dynamic> data = <String, dynamic>{
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
              handler.resolve(
                Response<dynamic>(requestOptions: options, data: data),
              );
              return;
            }
            if (options.path == AuthRepositoryImplConst.logoutPath) {
              handler.resolve(
                Response<dynamic>(requestOptions: options, statusCode: 204),
              );
              return;
            }
            handler.next(options);
          },
        ),
      );
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
