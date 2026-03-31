import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/errors/failures.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/domain/entities/folder_models.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/deck/providers/library_provider.dart';
import 'package:lumos/presentation/features/deck/providers/states/library_state.dart';
import 'package:lumos/presentation/features/folder/providers/folder_provider.dart';

import 'widgets/blocks/content/library_data_view.dart';
import 'widgets/states/library_error_view.dart';
import 'widgets/states/library_loading_view.dart';

abstract final class DeckListScreenConst {
  DeckListScreenConst._();

  static const double listGap =
      12;
  static const double loadMoreThreshold = 240;
}

class DeckListScreen extends ConsumerStatefulWidget {
  const DeckListScreen({super.key});

  @override
  ConsumerState<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends ConsumerState<DeckListScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<LibraryState> libraryAsync = ref.watch(
      libraryAsyncControllerProvider,
    );
    return libraryAsync.when(
      loading: () {
        return LibraryLoadingView(searchController: _searchController);
      },
      error: (Object error, StackTrace stackTrace) {
        final String message = error is Failure
            ? error.message
            : error.toString();
        return LibraryErrorView(
          errorMessage: message,
          onRetry: () {
            unawaited(
              ref.read(libraryAsyncControllerProvider.notifier).refresh(),
            );
          },
        );
      },
      data: (LibraryState state) {
        _syncSearchController(searchQuery: state.searchQuery);
        return LibraryDataView(
          scrollController: _scrollController,
          searchController: _searchController,
          state: state,
          onRefresh: ref.read(libraryAsyncControllerProvider.notifier).refresh,
          onSearchChanged: ref
              .read(libraryAsyncControllerProvider.notifier)
              .updateSearchQuery,
          onSearchSubmitted: ref
              .read(libraryAsyncControllerProvider.notifier)
              .updateSearchQuery,
          onClearSearch: () {
            ref
                .read(libraryAsyncControllerProvider.notifier)
                .updateSearchQuery(LibraryStateConst.emptySearchQuery);
          },
          onOpenSort: () {
            unawaited(_openSortSheet(state));
          },
          onOpenFolder: _openFolder,
          onOpenFolders: () {
            const FoldersRouteData().go(context);
          },
        );
      },
    );
  }

  Future<void> _openSortSheet(LibraryState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return showLumosSortBottomSheet<LibrarySortBy>(
      context: context,
      title: l10n.folderSortTitle,
      subtitle: null,
      optionSectionTitle: l10n.commonSortBy,
      options: <({LibrarySortBy value, String label, IconData? icon})>[
        (
          value: LibrarySortBy.name,
          label: l10n.folderSortByName,
          icon: Icons.sort_by_alpha_rounded,
        ),
        (
          value: LibrarySortBy.createdAt,
          label: l10n.folderSortByCreatedAt,
          icon: Icons.schedule_rounded,
        ),
      ],
      initialValue: state.sortBy,
      directionSectionTitle: l10n.commonDirection,
      initialDirectionIndex: state.sortBy.directionIndexFor(
        state.sortDirection,
      ),
      directionLabelBuilder: (LibrarySortBy sortBy, int directionIndex) {
        return _directionLabel(
          l10n: l10n,
          sortBy: sortBy,
          directionIndex: directionIndex,
        );
      },
      applyLabel: l10n.commonSave,
      onApply: (LibrarySortBy selectedSortBy, int directionIndex) {
        ref
            .read(libraryAsyncControllerProvider.notifier)
            .updateSort(
              sortBy: selectedSortBy,
              sortDirection: selectedSortBy.resolveDirection(directionIndex),
            );
      },
    );
  }

  String _directionLabel({
    required AppLocalizations l10n,
    required LibrarySortBy sortBy,
    required int directionIndex,
  }) {
    if (sortBy == LibrarySortBy.name) {
      if (directionIndex == 0) {
        return l10n.folderSortNameAscending;
      }
      return l10n.folderSortNameDescending;
    }
    if (directionIndex == 0) {
      return l10n.folderSortCreatedNewest;
    }
    return l10n.folderSortCreatedOldest;
  }

  Future<void> _openFolder(FolderNode folder) async {
    await ref
        .read(folderAsyncControllerProvider.notifier)
        .openFolderFromLibrary(folder: folder);
    if (!mounted) {
      return;
    }
    const FoldersRouteData().go(context);
  }

  void _syncSearchController({required String searchQuery}) {
    if (_searchController.text == searchQuery) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: searchQuery,
      selection: TextSelection.collapsed(offset: searchQuery.length),
    );
  }

  void _onScroll() {
    final LibraryState? state = ref
        .read(libraryAsyncControllerProvider)
        .asData
        ?.value;
    if (state == null) {
      return;
    }
    if (!state.hasNextPage) {
      return;
    }
    if (state.isLoadingMore) {
      return;
    }
    if (!_scrollController.hasClients) {
      return;
    }
    final ScrollPosition position = _scrollController.position;
    final double remainingScroll = position.maxScrollExtent - position.pixels;
    if (remainingScroll > DeckListScreenConst.loadMoreThreshold) {
      return;
    }
    unawaited(ref.read(libraryAsyncControllerProvider.notifier).loadMore());
  }
}
