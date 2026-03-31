import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/core/errors/failures.dart';
import 'package:lumos/core/utils/string_utils.dart';
import 'package:lumos/data/repositories/folder_repository_impl.dart';
import 'package:lumos/domain/entities/folder_models.dart';
import 'package:lumos/domain/repositories/folder_repository.dart';

import 'states/library_state.dart';

part 'library_provider.g.dart';

abstract final class LibraryProviderConst {
  LibraryProviderConst._();

  static const Duration searchDebounceDuration = Duration(milliseconds: 250);
}

@Riverpod(keepAlive: true)
class LibraryAsyncController extends _$LibraryAsyncController {
  Timer? _searchDebounceTimer;

  @override
  Future<LibraryState> build() async {
    ref.onDispose(() {
      final Timer? activeTimer = _searchDebounceTimer;
      if (activeTimer == null) {
        return;
      }
      activeTimer.cancel();
      _searchDebounceTimer = null;
    });
    return _loadState(
      searchQuery: LibraryStateConst.emptySearchQuery,
      sortBy: LibrarySortBy.name,
      sortDirection: SortDirection.asc,
      page: LibraryStateConst.firstPage,
      existingFolders: const <FolderNode>[],
    );
  }

  void updateSearchQuery(String rawQuery) {
    final String normalizedQuery = StringUtils.normalizeSearchQuery(rawQuery);
    final Timer? activeTimer = _searchDebounceTimer;
    if (activeTimer != null) {
      activeTimer.cancel();
    }
    _searchDebounceTimer = Timer(
      LibraryProviderConst.searchDebounceDuration,
      () {
        unawaited(_applySearchQuery(normalizedQuery));
      },
    );
  }

  void updateSort({
    required LibrarySortBy sortBy,
    required SortDirection sortDirection,
  }) {
    final LibraryState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (currentState.sortBy == sortBy &&
        currentState.sortDirection == sortDirection) {
      return;
    }
    unawaited(
      _replaceState(
        searchQuery: currentState.searchQuery,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
  }

  Future<void> refresh() async {
    final LibraryState currentState =
        state.asData?.value ?? LibraryState.initial();
    await _replaceState(
      searchQuery: currentState.searchQuery,
      sortBy: currentState.sortBy,
      sortDirection: currentState.sortDirection,
    );
  }

  Future<void> loadMore() async {
    final LibraryState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (!currentState.hasNextPage) {
      return;
    }
    if (currentState.isLoadingMore) {
      return;
    }
    state = AsyncData<LibraryState>(
      currentState.copyWith(isLoadingMore: true, inlineErrorMessage: null),
    );
    try {
      final LibraryState nextState = await _loadState(
        searchQuery: currentState.searchQuery,
        sortBy: currentState.sortBy,
        sortDirection: currentState.sortDirection,
        page: currentState.page + 1,
        existingFolders: currentState.folders,
      );
      state = AsyncData<LibraryState>(nextState);
    } on Failure catch (failure) {
      state = AsyncData<LibraryState>(
        currentState.copyWith(
          isLoadingMore: false,
          inlineErrorMessage: failure.message,
        ),
      );
    } on Object {
      state = AsyncData<LibraryState>(
        currentState.copyWith(isLoadingMore: false),
      );
    }
  }

  Future<void> _applySearchQuery(String searchQuery) async {
    final LibraryState? currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    if (currentState.searchQuery == searchQuery) {
      return;
    }
    await _replaceState(
      searchQuery: searchQuery,
      sortBy: currentState.sortBy,
      sortDirection: currentState.sortDirection,
    );
  }

  Future<void> _replaceState({
    required String searchQuery,
    required LibrarySortBy sortBy,
    required SortDirection sortDirection,
  }) async {
    final LibraryState nextState = await _loadState(
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortDirection: sortDirection,
      page: LibraryStateConst.firstPage,
      existingFolders: const <FolderNode>[],
    );
    state = AsyncData<LibraryState>(nextState);
  }

  Future<LibraryState> _loadState({
    required String searchQuery,
    required LibrarySortBy sortBy,
    required SortDirection sortDirection,
    required int page,
    required List<FolderNode> existingFolders,
  }) async {
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    final Either<Failure, List<FolderNode>> result = await repository
        .getFolders(
          parentId: null,
          searchQuery: searchQuery,
          sortBy: sortBy.apiValue,
          sortType: sortDirection.apiValue,
          page: page,
          size: LibraryStateConst.pageSize,
        );
    return result.fold((Failure failure) => throw failure, (
      List<FolderNode> folders,
    ) {
      return LibraryState(
        folders: <FolderNode>[...existingFolders, ...folders],
        searchQuery: searchQuery,
        sortBy: sortBy,
        sortDirection: sortDirection,
        page: page,
        hasNextPage: folders.length >= LibraryStateConst.pageSize,
        isLoadingMore: false,
        inlineErrorMessage: null,
      );
    });
  }
}
