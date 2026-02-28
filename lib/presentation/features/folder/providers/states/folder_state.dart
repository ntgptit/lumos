import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/folder_models.dart';

part 'folder_state.freezed.dart';

enum FolderMutationType { none, creating, renaming, deleting }

enum FolderSortType { nameAscending, nameDescending }

abstract final class FolderStateConst {
  FolderStateConst._();

  static const String emptySearchQuery = '';
  static const int rootDepth = 0;
}

@freezed
abstract class FolderState with _$FolderState {
  const FolderState._();

  const factory FolderState({
    required FolderTreeState tree,
    required FolderMutationType mutationType,
    required String? inlineErrorMessage,
    required FolderViewState view,
  }) = _FolderState;

  factory FolderState.initial() {
    return const FolderState(
      tree: FolderTreeState(
        folders: <FolderNode>[],
        currentParentId: null,
        currentDepth: FolderStateConst.rootDepth,
        openedFolderPath: <int>[],
      ),
      mutationType: FolderMutationType.none,
      inlineErrorMessage: null,
      view: FolderViewState(
        searchQuery: FolderStateConst.emptySearchQuery,
        sortType: FolderSortType.nameAscending,
      ),
    );
  }

  List<FolderNode> get folders => tree.folders;
  int? get currentParentId => tree.currentParentId;
  int get currentDepth => tree.currentDepth;
  List<int> get openedFolderPath => tree.openedFolderPath;
  String get searchQuery => view.searchQuery;
  FolderSortType get sortType => view.sortType;

  List<FolderNode> get visibleFolders {
    return folders;
  }

  bool get isMutating {
    return mutationType != FolderMutationType.none;
  }
}

@freezed
abstract class FolderTreeState with _$FolderTreeState {
  const factory FolderTreeState({
    required List<FolderNode> folders,
    required int? currentParentId,
    required int currentDepth,
    required List<int> openedFolderPath,
  }) = _FolderTreeState;
}

@freezed
abstract class FolderViewState with _$FolderViewState {
  const factory FolderViewState({
    required String searchQuery,
    required FolderSortType sortType,
  }) = _FolderViewState;

  factory FolderViewState.initial() {
    return const FolderViewState(
      searchQuery: FolderStateConst.emptySearchQuery,
      sortType: FolderSortType.nameAscending,
    );
  }
}
