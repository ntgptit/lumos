part of 'folder_provider.dart';

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
        () => const Failure.unknown(
          message: FolderProviderConst.unknownErrorMessage,
        ),
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
