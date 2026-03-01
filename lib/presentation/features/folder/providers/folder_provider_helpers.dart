part of 'folder_provider.dart';

Future<FolderSubmitResult> _handleFolderMutationResult({
  required FolderMutationType mutationType,
  required FolderState currentState,
  required Either<Failure, Unit> result,
  required Future<FolderState> Function() loadState,
  required void Function(FolderState state) writeData,
  required void Function(Object error, StackTrace stackTrace) writeError,
}) async {
  if (result.isLeft()) {
    final Failure failure = result.swap().getOrElse(
      () => const Failure.unknown(
        message: FolderProviderConst.unknownErrorMessage,
      ),
    );
    final String? nameErrorMessage = _resolveFolderNameErrorMessage(
      mutationType: mutationType,
      failure: failure,
    );
    String? inlineErrorMessage = failure.message;
    if (nameErrorMessage != null) {
      inlineErrorMessage = null;
    }
    if (mutationType == FolderMutationType.deleting) {
      inlineErrorMessage = failure.message;
    }
    writeData(
      currentState.copyWith(
        mutationType: FolderMutationType.none,
        inlineErrorMessage: inlineErrorMessage,
      ),
    );
    return FolderSubmitResult.failure(nameErrorMessage: nameErrorMessage);
  }
  try {
    final FolderState nextState = await loadState();
    writeData(nextState);
    return const FolderSubmitResult.success();
  } catch (error, stackTrace) {
    writeError(error, stackTrace);
    return const FolderSubmitResult.failure();
  }
}

Future<void> _replaceFolderState({
  required Future<FolderState> Function() loadState,
  required bool Function() shouldSkipCommit,
  required void Function(FolderState state) writeData,
  required void Function(Object error, StackTrace stackTrace) writeError,
}) async {
  try {
    final FolderState nextState = await loadState();
    if (shouldSkipCommit()) {
      return;
    }
    writeData(nextState);
  } catch (error, stackTrace) {
    if (shouldSkipCommit()) {
      return;
    }
    writeError(error, stackTrace);
  }
}

Future<FolderState> _loadFolderState({
  required FolderRepository repository,
  required int? parentId,
  required int currentDepth,
  required List<int> openedFolderPath,
  required int page,
  required FolderViewState view,
}) async {
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
      () => const Failure.unknown(
        message: FolderProviderConst.unknownErrorMessage,
      ),
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

String? _resolveFolderNameErrorMessage({
  required FolderMutationType mutationType,
  required Failure failure,
}) {
  if (mutationType == FolderMutationType.deleting) {
    return null;
  }
  if (failure is ValidationFailure) {
    return failure.message;
  }
  return null;
}
