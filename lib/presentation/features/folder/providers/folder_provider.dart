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
        view: nextView,
      ),
    );
  }

  void updateSortType(FolderSortType sortType) {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (sortType == currentState.sortType) {
      return;
    }
    final FolderViewState nextView = currentState.view.copyWith(
      sortType: sortType,
    );
    unawaited(
      _replaceState(
        parentId: currentState.currentParentId,
        currentDepth: currentState.currentDepth,
        openedFolderPath: currentState.openedFolderPath,
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
      view: currentState.view,
    );
  }

  Future<void> openRoot() async {
    final FolderViewState currentView =
        state.asData?.value.view ?? FolderViewState.initial();
    await _replaceState(
      parentId: null,
      currentDepth: FolderStateConst.rootDepth,
      openedFolderPath: const <int>[],
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
      await openRoot();
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
      view: currentState.view,
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
    required FolderViewState view,
  }) async {
    try {
      final FolderState nextState = await _loadState(
        parentId: parentId,
        currentDepth: currentDepth,
        openedFolderPath: openedFolderPath,
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
    required FolderViewState view,
  }) async {
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    final Either<Failure, List<FolderNode>> foldersResult = await repository
        .getFolders(
          parentId: parentId,
          searchQuery: view.searchQuery,
          sortType: view.sortType.name,
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
        currentParentId: parentId,
        currentDepth: currentDepth,
        openedFolderPath: openedFolderPath,
      ),
      mutationType: FolderMutationType.none,
      inlineErrorMessage: null,
      view: view,
    );
  }
}
