import 'package:lumos/core/enums/sort_direction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/entities/folder_models.dart';

part 'folder_state.freezed.dart';

abstract final class FolderStateConst {
  FolderStateConst._();

  static const String emptySearchQuery = '';
  static const String sortByName = 'NAME';
  static const String sortByCreatedAt = 'CREATED_AT';
  static const int rootDepth = 0;
  static const int firstPage = 0;
  static const int pageSize = 20;
  static const int folderNameMinLength = FolderDomainConst.nameMinLength;
  static const int folderNameMaxLength = FolderDomainConst.nameMaxLength;
  static const int folderDescriptionMaxLength =
      FolderDomainConst.descriptionMaxLength;
  static const String folderDefaultColorHex = FolderDomainConst.defaultColorHex;
  static const Duration searchDebounceDuration = Duration(milliseconds: 250);
}

enum FolderMutationType { none, creating, renaming, deleting }

enum FolderNavigationType { none, toParent, toRoot }

enum FolderSortBy { name, createdAt }

enum FolderSortType { asc, desc }

extension FolderSortByApiExtension on FolderSortBy {
  String get apiValue {
    if (this == FolderSortBy.createdAt) {
      return FolderStateConst.sortByCreatedAt;
    }
    return FolderStateConst.sortByName;
  }
}

extension FolderSortTypeApiExtension on FolderSortType {
  SortDirection get direction {
    if (this == FolderSortType.desc) {
      return SortDirection.desc;
    }
    return SortDirection.asc;
  }

  String get apiValue {
    return direction.apiValue;
  }
}

extension FolderSortByPresentationExtension on FolderSortBy {
  int directionIndex({required FolderSortType sortType}) {
    if (this == FolderSortBy.name) {
      if (sortType == FolderSortType.asc) {
        return 0;
      }
      return 1;
    }
    if (sortType == FolderSortType.desc) {
      return 0;
    }
    return 1;
  }

  FolderSortType sortTypeForDirectionIndex(int directionIndex) {
    if (this == FolderSortBy.name) {
      if (directionIndex == 0) {
        return FolderSortType.asc;
      }
      return FolderSortType.desc;
    }
    if (directionIndex == 0) {
      return FolderSortType.desc;
    }
    return FolderSortType.asc;
  }
}

@freezed
abstract class FolderState with _$FolderState {
  const FolderState._();

  const factory FolderState({
    required FolderTreeState tree,
    required FolderMutationType mutationType,
    required FolderNavigationType navigationType,
    required String? inlineErrorMessage,
    required FolderViewState view,
  }) = _FolderState;

  factory FolderState.initial() {
    return const FolderState(
      tree: FolderTreeState(
        folders: <FolderNode>[],
        navigation: FolderNavigationState(
          currentParentId: null,
          currentDepth: FolderStateConst.rootDepth,
          openedFolderPath: <int>[],
        ),
        pagination: FolderPaginationState(
          currentPage: FolderStateConst.firstPage,
          hasNextPage: true,
          isLoadingMore: false,
        ),
      ),
      mutationType: FolderMutationType.none,
      navigationType: FolderNavigationType.none,
      inlineErrorMessage: null,
      view: FolderViewState(
        searchQuery: FolderStateConst.emptySearchQuery,
        deckSearchQuery: FolderStateConst.emptySearchQuery,
        sortBy: FolderSortBy.name,
        sortType: FolderSortType.asc,
      ),
    );
  }

  List<FolderNode> get folders => tree.folders;
  int? get currentParentId => tree.navigation.currentParentId;
  int get currentDepth => tree.navigation.currentDepth;
  List<int> get openedFolderPath => tree.navigation.openedFolderPath;
  int get currentPage => tree.pagination.currentPage;
  bool get hasNextPage => tree.pagination.hasNextPage;
  bool get isLoadingMore => tree.pagination.isLoadingMore;
  String get searchQuery => view.searchQuery;
  String get deckSearchQuery => view.deckSearchQuery;
  FolderSortBy get sortBy => view.sortBy;
  FolderSortType get sortType => view.sortType;

  List<FolderNode> get visibleFolders {
    return folders;
  }

  bool get isMutating {
    return mutationType != FolderMutationType.none;
  }

  bool get isNavigating {
    return navigationType != FolderNavigationType.none;
  }

  bool get isNavigatingParent {
    return navigationType == FolderNavigationType.toParent;
  }

  bool get isNavigatingRoot {
    return navigationType == FolderNavigationType.toRoot;
  }
}

@freezed
abstract class FolderTreeState with _$FolderTreeState {
  const factory FolderTreeState({
    required List<FolderNode> folders,
    required FolderNavigationState navigation,
    required FolderPaginationState pagination,
  }) = _FolderTreeState;
}

@freezed
abstract class FolderNavigationState with _$FolderNavigationState {
  const factory FolderNavigationState({
    required int? currentParentId,
    required int currentDepth,
    required List<int> openedFolderPath,
  }) = _FolderNavigationState;
}

@freezed
abstract class FolderPaginationState with _$FolderPaginationState {
  const factory FolderPaginationState({
    required int currentPage,
    required bool hasNextPage,
    required bool isLoadingMore,
  }) = _FolderPaginationState;
}

@freezed
abstract class FolderViewState with _$FolderViewState {
  const factory FolderViewState({
    required String searchQuery,
    required String deckSearchQuery,
    required FolderSortBy sortBy,
    required FolderSortType sortType,
  }) = _FolderViewState;

  factory FolderViewState.initial() {
    return const FolderViewState(
      searchQuery: FolderStateConst.emptySearchQuery,
      deckSearchQuery: FolderStateConst.emptySearchQuery,
      sortBy: FolderSortBy.name,
      sortType: FolderSortType.asc,
    );
  }
}
