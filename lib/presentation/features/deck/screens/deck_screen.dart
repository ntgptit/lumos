import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/enums/sort_direction.dart';
import 'package:lumos/core/errors/failures.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/utils/string_utils.dart';
import 'package:lumos/l10n/app_localizations.dart';
import '../providers/deck_provider.dart';
import '../providers/states/deck_state.dart';
import 'deck_content.dart';
import 'widgets/blocks/header/deck_header_section.dart';
import 'widgets/states/deck_loading_view.dart';

abstract final class DeckScreenConst {
  DeckScreenConst._();

  static const Duration searchDebounce = AppDurations.medium;
  static const double sectionSpacing = LumosSpacing.lg;
}

class DeckScreen extends ConsumerStatefulWidget {
  const DeckScreen({
    required this.folderId,
    this.searchQuery = '',
    this.sortDirection = DeckStateConst.defaultSortDirection,
    super.key,
  });

  final int folderId;
  final String searchQuery;
  final SortDirection sortDirection;

  @override
  ConsumerState<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends ConsumerState<DeckScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final ValueNotifier<String> _searchQueryNotifier;
  late final ValueNotifier<SortDirection> _sortDirectionNotifier;
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    final String normalizedSearchQuery = StringUtils.normalizeSearchQuery(
      widget.searchQuery,
    );
    _scrollController = ScrollController();
    _searchController = TextEditingController(text: normalizedSearchQuery);
    _searchQueryNotifier = ValueNotifier<String>(normalizedSearchQuery);
    _sortDirectionNotifier = ValueNotifier<SortDirection>(widget.sortDirection);
  }

  @override
  void didUpdateWidget(covariant DeckScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      final String normalizedSearchQuery = StringUtils.normalizeSearchQuery(
        widget.searchQuery,
      );
      _replaceSearchText(normalizedSearchQuery);
      _searchQueryNotifier.value = normalizedSearchQuery;
    }
    if (widget.sortDirection == oldWidget.sortDirection) {
      return;
    }
    _sortDirectionNotifier.value = widget.sortDirection;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _sortDirectionNotifier.dispose();
    _searchQueryNotifier.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        _searchQueryNotifier,
        _sortDirectionNotifier,
      ]),
      builder: (BuildContext context, Widget? child) {
        final String searchQuery = _searchQueryNotifier.value;
        final SortDirection sortDirection = _sortDirectionNotifier.value;
        final String sortType = sortDirection.apiValue;
        final double sectionSpacing = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: DeckScreenConst.sectionSpacing,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        final AsyncValue<DeckState> deckAsync = ref.watch(
          deckAsyncControllerProvider(widget.folderId, searchQuery, sortType),
        );
        final List<Widget> leadingSlivers = <Widget>[
          SliverToBoxAdapter(
            child: DeckHeaderSection(
              searchController: _searchController,
              searchQuery: searchQuery,
              sortDirection: sortDirection,
              deckCount: deckAsync.asData?.value.decks.length,
              onSearchChanged: _handleSearchChanged,
              onSearchSubmitted: _applySearchQuery,
              onClearSearch: _clearSearch,
              onToggleSort: _toggleSort,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: sectionSpacing)),
        ];
        return deckAsync.when(
          loading: () {
            return RefreshIndicator(
              onRefresh: _refreshDecks,
              child: LumosScreenFrame(
                child: LumosPagedSliverList(
                  controller: _scrollController,
                  leadingSlivers: leadingSlivers,
                  trailingSlivers: const <Widget>[],
                  itemCount: 0,
                  itemBuilder: (BuildContext context, int index) {
                    return const SizedBox.shrink();
                  },
                  emptySliver: const DeckLoadingView(),
                ),
              ),
            );
          },
          error: (Object error, StackTrace stackTrace) {
            final String errorMessage = error is Failure
                ? error.message
                : error.toString();
            final AppLocalizations l10n = AppLocalizations.of(context)!;
            return RefreshIndicator(
              onRefresh: _refreshDecks,
              child: LumosScreenFrame(
                child: LumosPagedSliverList(
                  controller: _scrollController,
                  leadingSlivers: leadingSlivers,
                  trailingSlivers: const <Widget>[],
                  itemCount: 0,
                  itemBuilder: (BuildContext context, int index) {
                    return const SizedBox.shrink();
                  },
                  emptySliver: LumosErrorState(
                    errorMessage: errorMessage,
                    retryLabel: l10n.commonRetry,
                    onRetry: _refreshDecks,
                  ),
                ),
              ),
            );
          },
          data: (DeckState state) {
            return DeckContent(
              scrollController: _scrollController,
              leadingSlivers: leadingSlivers,
              state: state,
              providerArgs: (
                folderId: widget.folderId,
                searchQuery: searchQuery,
                sortType: sortType,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _refreshDecks() {
    return ref
        .read(
          deckAsyncControllerProvider(
            widget.folderId,
            _searchQueryNotifier.value,
            _sortDirectionNotifier.value.apiValue,
          ).notifier,
        )
        .refresh();
  }

  void _handleSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      DeckScreenConst.searchDebounce,
      () => _applySearchQuery(value),
    );
  }

  void _applySearchQuery(String value) {
    _searchDebounceTimer?.cancel();
    final String normalizedQuery = StringUtils.normalizeSearchQuery(value);
    if (_searchQueryNotifier.value == normalizedQuery) {
      return;
    }
    _searchQueryNotifier.value = normalizedQuery;
  }

  void _clearSearch() {
    _searchDebounceTimer?.cancel();
    _replaceSearchText(StringUtils.empty);
    _searchQueryNotifier.value = StringUtils.empty;
  }

  void _toggleSort() {
    _sortDirectionNotifier.value = _sortDirectionNotifier.value.toggled;
  }

  void _replaceSearchText(String value) {
    _searchController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
