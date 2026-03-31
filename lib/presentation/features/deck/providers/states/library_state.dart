import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/domain/entities/folder_models.dart';

abstract final class LibraryStateConst {
  LibraryStateConst._();

  static const String emptySearchQuery = '';
  static const String sortByName = 'NAME';
  static const String sortByCreatedAt = 'CREATED_AT';
  static const int firstPage = 0;
  static const int pageSize = 20;
}

enum LibrarySortBy { name, createdAt }

extension LibrarySortByApiExtension on LibrarySortBy {
  String get apiValue {
    if (this == LibrarySortBy.createdAt) {
      return LibraryStateConst.sortByCreatedAt;
    }
    return LibraryStateConst.sortByName;
  }

  int directionIndexFor(SortDirection sortDirection) {
    if (this == LibrarySortBy.name) {
      if (sortDirection == SortDirection.asc) {
        return 0;
      }
      return 1;
    }
    if (sortDirection == SortDirection.desc) {
      return 0;
    }
    return 1;
  }

  SortDirection resolveDirection(int directionIndex) {
    if (this == LibrarySortBy.name) {
      if (directionIndex == 0) {
        return SortDirection.asc;
      }
      return SortDirection.desc;
    }
    if (directionIndex == 0) {
      return SortDirection.desc;
    }
    return SortDirection.asc;
  }
}

class LibraryState {
  const LibraryState({
    required this.folders,
    required this.searchQuery,
    required this.sortBy,
    required this.sortDirection,
    required this.page,
    required this.hasNextPage,
    required this.isLoadingMore,
    required this.inlineErrorMessage,
  });

  factory LibraryState.initial() {
    return const LibraryState(
      folders: <FolderNode>[],
      searchQuery: LibraryStateConst.emptySearchQuery,
      sortBy: LibrarySortBy.name,
      sortDirection: SortDirection.asc,
      page: LibraryStateConst.firstPage,
      hasNextPage: true,
      isLoadingMore: false,
      inlineErrorMessage: null,
    );
  }

  final List<FolderNode> folders;
  final String searchQuery;
  final LibrarySortBy sortBy;
  final SortDirection sortDirection;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? inlineErrorMessage;

  LibraryState copyWith({
    List<FolderNode>? folders,
    String? searchQuery,
    LibrarySortBy? sortBy,
    SortDirection? sortDirection,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? inlineErrorMessage,
  }) {
    return LibraryState(
      folders: folders ?? this.folders,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      inlineErrorMessage: inlineErrorMessage,
    );
  }
}
