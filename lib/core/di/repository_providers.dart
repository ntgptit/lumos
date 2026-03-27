import 'package:lumos/core/di/core_providers.dart';
import 'package:lumos/data/repositories/auth/auth_repository_impl.dart';
import 'package:lumos/data/repositories/deck_repository_impl.dart';
import 'package:lumos/data/repositories/flashcard_repository_impl.dart';
import 'package:lumos/data/repositories/folder_repository_impl.dart';
import 'package:lumos/domain/repositories/auth/auth_repository.dart';
import 'package:lumos/domain/repositories/deck_repository.dart';
import 'package:lumos/domain/repositories/flashcard_repository.dart';
import 'package:lumos/domain/repositories/folder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return DioAuthRepository(dio: apiClient.dio, storage: secureStorage.rawStorage);
}

@Riverpod(keepAlive: true)
FolderRepository folderRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DioFolderRepository(dio: apiClient.dio);
}

@Riverpod(keepAlive: true)
DeckRepository deckRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DioDeckRepository(dio: apiClient.dio);
}

@Riverpod(keepAlive: true)
FlashcardRepository flashcardRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DioFlashcardRepository(dio: apiClient.dio);
}
