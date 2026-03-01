import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../data/repositories/folder_repository_impl.dart';
import '../../../../domain/entities/folder_models.dart';
import '../../../../domain/repositories/folder_repository.dart';
import 'states/folder_state.dart';

part 'folder_provider.g.dart';
part 'folder_provider_helpers.dart';
part 'folder_provider_navigation.dart';
part 'folder_provider_pagination.dart';

abstract final class FolderProviderConst {
  FolderProviderConst._();

  static const String unknownErrorMessage = 'Unknown error';
}

class FolderSubmitResult {
  const FolderSubmitResult._({required this.isSuccess, this.nameErrorMessage});

  const FolderSubmitResult.success() : this._(isSuccess: true);

  const FolderSubmitResult.failure({String? nameErrorMessage})
    : this._(isSuccess: false, nameErrorMessage: nameErrorMessage);

  final bool isSuccess;
  final String? nameErrorMessage;
}

enum FolderNavigationIntent { root, parent }

@Riverpod(keepAlive: true)
class FolderAsyncController extends _$FolderAsyncController {
  Timer? _searchDebounceTimer;
  int _replaceRequestVersion = FolderStateConst.firstPage;

  @override
  Future<FolderState> build() async {
    ref.onDispose(() {
      final Timer? activeTimer = _searchDebounceTimer;
      if (activeTimer == null) {
        return;
      }
      activeTimer.cancel();
      _searchDebounceTimer = null;
    });
    return _loadState(
      parentId: null,
      currentDepth: FolderStateConst.rootDepth,
      openedFolderPath: const <int>[],
      page: FolderStateConst.firstPage,
      view: FolderViewState.initial(),
    );
  }

  void updateSearchQuery(String rawQuery) {
    final String normalizedQuery = StringUtils.normalizeName(rawQuery);
    final Timer? activeTimer = _searchDebounceTimer;
    if (activeTimer != null) {
      activeTimer.cancel();
    }
    _searchDebounceTimer = Timer(FolderStateConst.searchDebounceDuration, () {
      unawaited(_applySearchQuery(normalizedQuery));
    });
  }

  void updateSort({
    required FolderSortBy sortBy,
    required FolderSortType sortType,
  }) {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (sortBy == currentState.sortBy && sortType == currentState.sortType) {
      return;
    }
    final FolderViewState nextView = currentState.view.copyWith(
      sortBy: sortBy,
      sortType: sortType,
    );
    unawaited(
      _replaceState(
        parentId: currentState.currentParentId,
        currentDepth: currentState.currentDepth,
        openedFolderPath: currentState.openedFolderPath,
        page: FolderStateConst.firstPage,
        view: nextView,
      ),
    );
  }

  Future<void> _applySearchQuery(String normalizedQuery) async {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (normalizedQuery == currentState.searchQuery) {
      return;
    }
    final FolderViewState nextView = currentState.view.copyWith(
      searchQuery: normalizedQuery,
    );
    await _replaceState(
      parentId: currentState.currentParentId,
      currentDepth: currentState.currentDepth,
      openedFolderPath: currentState.openedFolderPath,
      page: FolderStateConst.firstPage,
      view: nextView,
    );
  }

  Future<void> refresh() async {
    final FolderState currentState =
        state.asData?.value ?? FolderState.initial();
    await _replaceState(
      parentId: currentState.currentParentId,
      currentDepth: currentState.currentDepth,
      openedFolderPath: currentState.openedFolderPath,
      page: FolderStateConst.firstPage,
      view: currentState.view,
    );
  }

  Future<void> loadMore() async {
    await _loadMore(
      readCurrentState: () => state.asData?.value,
      writeState: (FolderState nextState) {
        state = AsyncData<FolderState>(nextState);
      },
      readRepository: () => ref.read(folderRepositoryProvider),
    );
  }

  Future<FolderSubmitResult> createFolder(String name) async {
    return _runMutation(
      mutationType: FolderMutationType.creating,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.createFolder(name: name, parentId: currentParentId);
      },
    );
  }

  Future<FolderSubmitResult> renameFolder({
    required int folderId,
    required String name,
  }) async {
    return _runMutation(
      mutationType: FolderMutationType.renaming,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.renameFolder(folderId: folderId, name: name);
      },
    );
  }

  Future<bool> deleteFolder(int folderId) async {
    final FolderSubmitResult result = await _runMutation(
      mutationType: FolderMutationType.deleting,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.deleteFolder(folderId: folderId);
      },
    );
    return result.isSuccess;
  }

  Future<FolderSubmitResult> _runMutation({
    required FolderMutationType mutationType,
    required Future<Either<Failure, Unit>> Function(
      FolderRepository repository,
      int? currentParentId,
    )
    mutation,
  }) async {
    final FolderState current = state.asData?.value ?? FolderState.initial();
    state = AsyncData<FolderState>(
      current.copyWith(mutationType: mutationType, inlineErrorMessage: null),
    );
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    final Either<Failure, Unit> result = await mutation(
      repository,
      current.currentParentId,
    );
    return _handleFolderMutationResult(
      mutationType: mutationType,
      currentState: current,
      result: result,
      loadState: () {
        return _loadState(
          parentId: current.currentParentId,
          currentDepth: current.currentDepth,
          openedFolderPath: current.openedFolderPath,
          page: FolderStateConst.firstPage,
          view: current.view,
        );
      },
      writeData: (FolderState nextState) {
        state = AsyncData<FolderState>(nextState);
      },
      writeError: (Object error, StackTrace stackTrace) {
        state = AsyncError<FolderState>(error, stackTrace);
      },
    );
  }

  Future<void> _replaceState({
    required int? parentId,
    required int currentDepth,
    required List<int> openedFolderPath,
    required int page,
    required FolderViewState view,
  }) async {
    final int requestVersion = _nextReplaceRequestVersion();
    await _replaceFolderState(
      loadState: () {
        return _loadState(
          parentId: parentId,
          currentDepth: currentDepth,
          openedFolderPath: openedFolderPath,
          page: page,
          view: view,
        );
      },
      shouldSkipCommit: () {
        return _shouldSkipReplaceCommit(requestVersion: requestVersion);
      },
      writeData: (FolderState nextState) {
        state = AsyncData<FolderState>(nextState);
      },
      writeError: (Object error, StackTrace stackTrace) {
        state = AsyncError<FolderState>(error, stackTrace);
      },
    );
  }

  Future<FolderState> _loadState({
    required int? parentId,
    required int currentDepth,
    required List<int> openedFolderPath,
    required int page,
    required FolderViewState view,
  }) async {
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    return _loadFolderState(
      repository: repository,
      parentId: parentId,
      currentDepth: currentDepth,
      openedFolderPath: openedFolderPath,
      page: page,
      view: view,
    );
  }

  int _nextReplaceRequestVersion() {
    _replaceRequestVersion++;
    return _replaceRequestVersion;
  }

  bool _shouldSkipReplaceCommit({required int requestVersion}) {
    return requestVersion != _replaceRequestVersion;
  }
}
