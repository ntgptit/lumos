// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

part of 'folder_provider.dart';

extension FolderAsyncControllerNavigationX on FolderAsyncController {
  Future<void> navigate({required FolderNavigationIntent intent}) async {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (currentState.isNavigating) {
      return;
    }
    if (intent == FolderNavigationIntent.root) {
      await _openRootFolder();
      return;
    }
    await _openParentFolder();
  }

  Future<void> openFolder({required FolderNode folder}) async {
    final FolderState currentState =
        state.asData?.value ?? FolderState.initial();
    if (currentState.currentParentId == folder.id) {
      return;
    }
    final List<int> nextOpenedFolderPath = _resolveNextOpenedPath(
      currentPath: currentState.openedFolderPath,
      folderId: folder.id,
    );
    await _replaceState(
      parentId: folder.id,
      currentDepth: nextOpenedFolderPath.length,
      openedFolderPath: nextOpenedFolderPath,
      page: FolderStateConst.firstPage,
      view: currentState.view,
    );
  }

  Future<void> openFolderFromLibrary({required FolderNode folder}) async {
    final List<int> nextOpenedFolderPath = _resolveNextOpenedPath(
      currentPath: const <int>[],
      folderId: folder.id,
    );
    await _replaceState(
      parentId: folder.id,
      currentDepth: nextOpenedFolderPath.length,
      openedFolderPath: nextOpenedFolderPath,
      page: FolderStateConst.firstPage,
      view: FolderViewState.initial(),
    );
  }

  Future<void> _openRootFolder() async {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (currentState.isNavigating) {
      return;
    }
    if (currentState.currentDepth == FolderStateConst.rootDepth) {
      return;
    }
    state = AsyncData<FolderState>(
      currentState.copyWith(
        navigationType: FolderNavigationType.toRoot,
        inlineErrorMessage: null,
      ),
    );
    await _replaceState(
      parentId: null,
      currentDepth: FolderStateConst.rootDepth,
      openedFolderPath: const <int>[],
      page: FolderStateConst.firstPage,
      view: currentState.view,
    );
  }

  Future<void> _openParentFolder() async {
    final FolderState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (currentState.isNavigating) {
      return;
    }
    final _FolderNavigationSnapshot? snapshot = _resolveParentSnapshot(
      currentState: currentState,
    );
    if (snapshot == null) {
      return;
    }
    state = AsyncData<FolderState>(
      currentState.copyWith(
        navigationType: FolderNavigationType.toParent,
        inlineErrorMessage: null,
      ),
    );
    if (snapshot.openRoot) {
      await _replaceState(
        parentId: null,
        currentDepth: FolderStateConst.rootDepth,
        openedFolderPath: const <int>[],
        page: FolderStateConst.firstPage,
        view: currentState.view,
      );
      return;
    }
    await _replaceState(
      parentId: snapshot.parentId,
      currentDepth: snapshot.depth,
      openedFolderPath: snapshot.path,
      page: FolderStateConst.firstPage,
      view: currentState.view,
    );
  }
}

class _FolderNavigationSnapshot {
  const _FolderNavigationSnapshot({
    required this.path,
    required this.depth,
    required this.parentId,
    required this.openRoot,
  });

  final List<int> path;
  final int depth;
  final int? parentId;
  final bool openRoot;
}

List<int> _resolveNextOpenedPath({
  required List<int> currentPath,
  required int folderId,
}) {
  final int existingIndex = currentPath.indexOf(folderId);
  if (existingIndex >= FolderStateConst.firstPage) {
    return currentPath.sublist(FolderStateConst.firstPage, existingIndex + 1);
  }
  return <int>[...currentPath, folderId];
}

_FolderNavigationSnapshot? _resolveParentSnapshot({
  required FolderState currentState,
}) {
  if (currentState.currentDepth == FolderStateConst.rootDepth) {
    return null;
  }
  if (currentState.openedFolderPath.isEmpty) {
    return const _FolderNavigationSnapshot(
      path: <int>[],
      depth: FolderStateConst.rootDepth,
      parentId: null,
      openRoot: true,
    );
  }
  final List<int> nextPath = List<int>.from(currentState.openedFolderPath)
    ..removeLast();
  int? nextParentId;
  if (nextPath.isNotEmpty) {
    nextParentId = nextPath.last;
  }
  return _FolderNavigationSnapshot(
    path: nextPath,
    depth: nextPath.length,
    parentId: nextParentId,
    openRoot: false,
  );
}
