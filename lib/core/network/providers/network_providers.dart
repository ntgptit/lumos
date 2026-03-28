import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lumos/core/di/core_providers.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  return ref.watch(core.apiClientProvider).dio;
}

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return ref.watch(core.secureStorageProvider).rawStorage;
}
