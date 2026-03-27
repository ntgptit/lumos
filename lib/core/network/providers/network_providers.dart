import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lumos/core/di/core_providers.dart' as core;

final dioClientProvider = Provider<Dio>((ref) {
  return ref.watch(core.apiClientProvider).dio;
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return ref.watch(core.secureStorageProvider).rawStorage;
});
