import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/folder_models.dart';

part 'folder_state.freezed.dart';

enum FolderMutationType {
  none,
  creating,
  renaming,
  deleting,
}

@freezed
abstract class FolderState with _$FolderState {
  const FolderState._();

  const factory FolderState({
    required FolderTreeState tree,
    required FolderMutationType mutationType,
    required String? inlineErrorMessage,
  }) = _FolderState;

  factory FolderState.initial() {
    return const FolderState(
      tree: FolderTreeState(
        folders: <FolderNode>[],
        breadcrumbItems: <BreadcrumbNode>[],
        currentParentId: null,
      ),
      mutationType: FolderMutationType.none,
      inlineErrorMessage: null,
    );
  }

  List<FolderNode> get folders => tree.folders;
  List<BreadcrumbNode> get breadcrumbItems => tree.breadcrumbItems;
  int? get currentParentId => tree.currentParentId;
  List<FolderNode> get visibleFolders {
    final List<FolderNode> results = folders
        .where((FolderNode item) => item.parentId == currentParentId)
        .toList(growable: false);
    final List<FolderNode> sortedResults = List<FolderNode>.from(results);
    sortedResults.sort((FolderNode a, FolderNode b) => a.name.compareTo(b.name));
    return sortedResults;
  }

  bool get isMutating {
    return mutationType != FolderMutationType.none;
  }
}

@freezed
abstract class FolderTreeState with _$FolderTreeState {
  const factory FolderTreeState({
    required List<FolderNode> folders,
    required List<BreadcrumbNode> breadcrumbItems,
    required int? currentParentId,
  }) = _FolderTreeState;
}
