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

@Riverpod(keepAlive: true)
class FolderAsyncController extends _$FolderAsyncController {
  @override
  Future<FolderState> build() async {
    return _loadState(
      parentId: null,
      currentDepth: FolderStateConst.rootDepth,
      openedFolderPath: const <int>[],
      page: FolderStateConst.firstPage,
      view: FolderViewState.initial(),
    );
  }

  void updateSearchQuery(String rawQuery) {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    final String normalizedQuery = StringUtils.normalizeName(rawQuery);
    if (normalizedQuery == currentState.searchQuery) {
      return;
    }
    final FolderViewState nextView = currentState.view.copyWith(
      searchQuery: normalizedQuery,
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

  Future<void> _openRoot() async {
    final FolderViewState currentView =
        state.asData?.value.view ?? FolderViewState.initial();
    await _replaceState(
      parentId: null,
      currentDepth: FolderStateConst.rootDepth,
      openedFolderPath: const <int>[],
      page: FolderStateConst.firstPage,
      view: currentView,
    );
  }

  Future<void> openFolder({required int folderId, required int depth}) async {
    final FolderState currentState =
        state.asData?.value ?? FolderState.initial();
    final FolderViewState currentView = currentState.view;
    final List<int> nextOpenedFolderPath = <int>[
      ...currentState.openedFolderPath,
      folderId,
    ];
    await _replaceState(
      parentId: folderId,
      currentDepth: depth,
      openedFolderPath: nextOpenedFolderPath,
      page: FolderStateConst.firstPage,
      view: currentView,
    );
  }

  Future<void> openParentFolder() async {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (currentState.currentDepth == FolderStateConst.rootDepth) {
      return;
    }
    if (currentState.openedFolderPath.isEmpty) {
      await _openRoot();
      return;
    }
    final List<int> nextOpenedFolderPath = List<int>.from(
      currentState.openedFolderPath,
    )..removeLast();
    final int nextDepth = nextOpenedFolderPath.length;
    final int? nextParentId = nextOpenedFolderPath.isEmpty
        ? null
        : nextOpenedFolderPath.last;
    await _replaceState(
      parentId: nextParentId,
      currentDepth: nextDepth,
      openedFolderPath: nextOpenedFolderPath,
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

  Future<void> createFolder(String name) async {
    await _runMutation(
      mutationType: FolderMutationType.creating,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.createFolder(name: name, parentId: currentParentId);
      },
    );
  }

  Future<void> renameFolder({
    required int folderId,
    required String name,
  }) async {
    await _runMutation(
      mutationType: FolderMutationType.renaming,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.renameFolder(folderId: folderId, name: name);
      },
    );
  }

  Future<void> deleteFolder(int folderId) async {
    await _runMutation(
      mutationType: FolderMutationType.deleting,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.deleteFolder(folderId: folderId);
      },
    );
  }

  Future<void> _runMutation({
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

    if (result.isLeft()) {
      final Failure failure = result.swap().getOrElse(
        () => const Failure.unknown(message: 'Unknown error'),
      );
      state = AsyncData<FolderState>(
        current.copyWith(
          mutationType: FolderMutationType.none,
          inlineErrorMessage: failure.message,
        ),
      );
      return;
    }
    try {
      final FolderState nextState = await _loadState(
        parentId: current.currentParentId,
        currentDepth: current.currentDepth,
        openedFolderPath: current.openedFolderPath,
        page: FolderStateConst.firstPage,
        view: current.view,
      );
      state = AsyncData<FolderState>(nextState);
    } catch (error, stackTrace) {
      state = AsyncError<FolderState>(error, stackTrace);
    }
  }

  Future<void> _replaceState({
    required int? parentId,
    required int currentDepth,
    required List<int> openedFolderPath,
    required int page,
    required FolderViewState view,
  }) async {
    try {
      final FolderState nextState = await _loadState(
        parentId: parentId,
        currentDepth: currentDepth,
        openedFolderPath: openedFolderPath,
        page: page,
        view: view,
      );
      state = AsyncData<FolderState>(nextState);
    } catch (error, stackTrace) {
      state = AsyncError<FolderState>(error, stackTrace);
    }
  }

  Future<FolderState> _loadState({
    required int? parentId,
    required int currentDepth,
    required List<int> openedFolderPath,
    required int page,
    required FolderViewState view,
  }) async {
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    final Either<Failure, List<FolderNode>> foldersResult = await repository
        .getFolders(
          parentId: parentId,
          searchQuery: view.searchQuery,
          sortBy: view.sortBy.apiValue,
          sortType: view.sortType.apiValue,
          page: page,
          size: FolderStateConst.pageSize,
        );

    if (foldersResult.isLeft()) {
      final Failure failure = foldersResult.swap().getOrElse(
        () => const Failure.unknown(message: 'Unknown error'),
      );
      throw failure;
    }

    final List<FolderNode> folders = foldersResult.getOrElse(
      () => <FolderNode>[],
    );
    return FolderState(
      tree: FolderTreeState(
        folders: folders,
        navigation: FolderNavigationState(
          currentParentId: parentId,
          currentDepth: currentDepth,
          openedFolderPath: openedFolderPath,
        ),
        pagination: FolderPaginationState(
          currentPage: page,
          hasNextPage: folders.length == FolderStateConst.pageSize,
          isLoadingMore: false,
        ),
      ),
      mutationType: FolderMutationType.none,
      inlineErrorMessage: null,
      view: view,
    );
  }
}

Future<void> _loadMore({
  required FolderState? Function() readCurrentState,
  required void Function(FolderState nextState) writeState,
  required FolderRepository Function() readRepository,
}) async {
  final FolderState? currentState = _resolveLoadMoreState(readCurrentState());
  if (currentState == null) {
    return;
  }
  _setLoadingMoreState(writeState: writeState, currentState: currentState);

  final int nextPage = currentState.currentPage + 1;
  final Either<Failure, List<FolderNode>> foldersResult =
      await _fetchFoldersPage(
        repository: readRepository(),
        currentState: currentState,
        page: nextPage,
      );

  if (foldersResult.isLeft()) {
    _applyLoadMoreFailure(
      writeState: writeState,
      currentState: currentState,
      failure: foldersResult.swap().getOrElse(
        () => const Failure.unknown(message: 'Unknown error'),
      ),
    );
    return;
  }

  _applyLoadMoreSuccess(
    writeState: writeState,
    currentState: currentState,
    nextPage: nextPage,
    nextFolders: foldersResult.getOrElse(() => <FolderNode>[]),
  );
}

FolderState? _resolveLoadMoreState(FolderState? currentState) {
  if (currentState == null) {
    return null;
  }
  if (currentState.isLoadingMore) {
    return null;
  }
  if (!currentState.hasNextPage) {
    return null;
  }
  return currentState;
}

void _setLoadingMoreState({
  required void Function(FolderState nextState) writeState,
  required FolderState currentState,
}) {
  final FolderPaginationState loadingPagination = currentState.tree.pagination
      .copyWith(isLoadingMore: true);
  final FolderTreeState loadingTree = currentState.tree.copyWith(
    pagination: loadingPagination,
  );
  writeState(
    currentState.copyWith(tree: loadingTree, inlineErrorMessage: null),
  );
}

Future<Either<Failure, List<FolderNode>>> _fetchFoldersPage({
  required FolderRepository repository,
  required FolderState currentState,
  required int page,
}) {
  return repository.getFolders(
    parentId: currentState.currentParentId,
    searchQuery: currentState.searchQuery,
    sortBy: currentState.sortBy.apiValue,
    sortType: currentState.sortType.apiValue,
    page: page,
    size: FolderStateConst.pageSize,
  );
}

void _applyLoadMoreFailure({
  required void Function(FolderState nextState) writeState,
  required FolderState currentState,
  required Failure failure,
}) {
  final FolderPaginationState failedPagination = currentState.tree.pagination
      .copyWith(isLoadingMore: false);
  final FolderTreeState failedTree = currentState.tree.copyWith(
    pagination: failedPagination,
  );
  writeState(
    currentState.copyWith(
      tree: failedTree,
      inlineErrorMessage: failure.message,
    ),
  );
}

void _applyLoadMoreSuccess({
  required void Function(FolderState nextState) writeState,
  required FolderState currentState,
  required int nextPage,
  required List<FolderNode> nextFolders,
}) {
  final List<FolderNode> mergedFolders = _mergePagedFolders(
    currentFolders: currentState.folders,
    nextFolders: nextFolders,
  );
  final bool hasNextPage = nextFolders.length == FolderStateConst.pageSize;
  final FolderPaginationState nextPagination = currentState.tree.pagination
      .copyWith(
        currentPage: nextPage,
        hasNextPage: hasNextPage,
        isLoadingMore: false,
      );
  final FolderTreeState nextTree = currentState.tree.copyWith(
    folders: mergedFolders,
    pagination: nextPagination,
  );
  writeState(currentState.copyWith(tree: nextTree, inlineErrorMessage: null));
}

List<FolderNode> _mergePagedFolders({
  required List<FolderNode> currentFolders,
  required List<FolderNode> nextFolders,
}) {
  final Map<int, FolderNode> folderById = <int, FolderNode>{};
  for (final FolderNode folder in currentFolders) {
    folderById[folder.id] = folder;
  }
  for (final FolderNode folder in nextFolders) {
    folderById[folder.id] = folder;
  }
  return folderById.values.toList(growable: false);
}
