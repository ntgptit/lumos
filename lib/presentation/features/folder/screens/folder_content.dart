import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../domain/entities/folder_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../../deck/providers/deck_provider.dart';
import '../../deck/providers/states/deck_state.dart';
import '../../deck/screens/widgets/blocks/deck_tile.dart';
import '../../deck/screens/widgets/dialogs/deck_dialogs.dart';
import '../../deck/screens/widgets/states/deck_empty_view.dart';
import '../providers/folder_provider.dart';
import '../providers/folder_ui_signal_provider.dart';
import '../providers/states/folder_state.dart';
import 'widgets/blocks/folder_tile.dart';
import 'widgets/blocks/header/folder_header.dart';
import 'widgets/dialogs/folder_dialogs.dart';
import 'widgets/states/folder_empty_view.dart';
import 'widgets/states/folder_error_banner.dart';
import 'widgets/states/folder_mutating_overlay.dart';

abstract final class FolderContentConst {
  FolderContentConst._();

  static const double listBottomSpacing = Insets.spacing64;
  static const double loadMoreThreshold = Insets.spacing64;
  static const double scrollTopOffset = Insets.spacing0;
  static const double scrollTopTriggerOffset = Insets.spacing8;
  static const Duration scrollTopDuration = AppDurations.fast;
  static const double loadMoreTopSpacing = Insets.spacing12;
  static const double loadMoreBottomSpacing = Insets.spacing8;
  static const double createActionSheetHorizontalPadding = Insets.spacing16;
  static const double createActionSheetVerticalPadding = Insets.spacing12;
  static const double createActionSheetBottomPadding = Insets.spacing16;
}

class FolderContent extends ConsumerStatefulWidget {
  const FolderContent({required this.state, super.key});

  final FolderState state;

  @override
  ConsumerState<FolderContent> createState() => _FolderContentState();
}

class _FolderContentState extends ConsumerState<FolderContent> {
  late final ScrollController _scrollController;
  late final ProviderSubscription<int> _scrollToTopSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _scrollToTopSubscription = ref.listenManual<int>(
      folderUiSignalControllerProvider,
      (int? previous, int next) {
        _handleScrollToTopSignal(previous: previous, next: next);
      },
    );
  }

  @override
  void dispose() {
    _scrollToTopSubscription.close();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double horizontalInset = LumosScreenFrame.resolveHorizontalInset(
      context,
    );
    final FolderAsyncController folderController = ref.read(
      folderAsyncControllerProvider.notifier,
    );
    final List<FolderNode> visibleFolders = widget.state.visibleFolders;
    final int? currentFolderId = widget.state.currentParentId;
    final bool canManageDecks = _canManageDecks(
      currentFolderId: currentFolderId,
      visibleFolders: visibleFolders,
    );
    final bool isDeckSearchMode = canManageDecks;
    final String activeSearchQuery = _buildActiveSearchQuery(
      isDeckSearchMode: isDeckSearchMode,
    );
    final ValueChanged<String> onSearchChanged = _buildSearchChangedHandler(
      controller: folderController,
      isDeckSearchMode: isDeckSearchMode,
    );
    final AsyncValue<DeckState>? deckViewAsync = _watchDeckAsync(
      currentFolderId: currentFolderId,
      searchQuery: activeSearchQuery,
    );
    final AsyncValue<DeckState>? deckRuleAsync = _watchDeckAsync(
      currentFolderId: currentFolderId,
      searchQuery: FolderStateConst.emptySearchQuery,
    );
    final DeckState? deckViewState = deckViewAsync?.asData?.value;
    final DeckState? deckRuleState = deckRuleAsync?.asData?.value;
    final bool hasDecks = _hasDecks(deckRuleState);
    final int deckCount = _deckCount(deckRuleState);
    final bool isDeckLoading = _isDeckLoading(deckRuleAsync);
    final bool isMutating =
        widget.state.isMutating || (deckViewState?.isMutating ?? false);
    final bool canCreateFolder = _canCreateFolder(
      currentFolderId: currentFolderId,
      canManageDecks: canManageDecks,
      hasDecks: hasDecks,
      isDeckLoading: isDeckLoading,
    );
    final bool canCreateDeck = _canCreateDeck(
      currentFolderId: currentFolderId,
      canManageDecks: canManageDecks,
      isDeckLoading: isDeckLoading,
    );

    return Stack(
      children: <Widget>[
        AbsorbPointer(
          absorbing: isMutating,
          child: _buildRefreshableList(
            context: context,
            ref: ref,
            folderController: folderController,
            visibleFolders: visibleFolders,
            currentFolderId: currentFolderId,
            canManageDecks: canManageDecks,
            deckAsync: deckViewAsync,
            hasDecks: hasDecks,
            deckCount: deckCount,
            searchQuery: activeSearchQuery,
            onSearchChanged: onSearchChanged,
          ),
        ),
        _buildCreateButton(
          context: context,
          ref: ref,
          l10n: l10n,
          horizontalInset: horizontalInset,
          currentFolderId: currentFolderId,
          canCreateFolder: canCreateFolder,
          canCreateDeck: canCreateDeck,
          isMutating: isMutating,
          deckSearchQuery: activeSearchQuery,
        ),
        _buildMutatingOverlay(context: context, isMutating: isMutating),
      ],
    );
  }

  Widget _buildRefreshableList({
    required BuildContext context,
    required WidgetRef ref,
    required FolderAsyncController folderController,
    required List<FolderNode> visibleFolders,
    required int? currentFolderId,
    required bool canManageDecks,
    required AsyncValue<DeckState>? deckAsync,
    required bool hasDecks,
    required int deckCount,
    required String searchQuery,
    required ValueChanged<String> onSearchChanged,
  }) {
    return RefreshIndicator(
      onRefresh: () {
        return _onRefresh(
          folderController: folderController,
          currentFolderId: currentFolderId,
          deckSearchQuery: searchQuery,
        );
      },
      child: LumosScreenFrame(
        child: _buildPagedListBody(
          context: context,
          ref: ref,
          folderController: folderController,
          visibleFolders: visibleFolders,
          currentFolderId: currentFolderId,
          canManageDecks: canManageDecks,
          deckAsync: deckAsync,
          hasDecks: hasDecks,
          deckCount: deckCount,
          searchQuery: searchQuery,
          onSearchChanged: onSearchChanged,
        ),
      ),
    );
  }

  Widget _buildPagedListBody({
    required BuildContext context,
    required WidgetRef ref,
    required FolderAsyncController folderController,
    required List<FolderNode> visibleFolders,
    required int? currentFolderId,
    required bool canManageDecks,
    required AsyncValue<DeckState>? deckAsync,
    required bool hasDecks,
    required int deckCount,
    required String searchQuery,
    required ValueChanged<String> onSearchChanged,
  }) {
    final List<Widget> leadingSlivers = _buildLeadingSlivers(
      controller: folderController,
      hasDecks: hasDecks,
      deckCount: deckCount,
      searchQuery: searchQuery,
      onSearchChanged: onSearchChanged,
    );
    if (canManageDecks) {
      return _buildDeckPagedSliverList(
        context: context,
        ref: ref,
        currentFolderId: currentFolderId,
        deckAsync: deckAsync,
        deckSearchQuery: searchQuery,
        searchQuery: searchQuery,
        leadingSlivers: leadingSlivers,
      );
    }
    return _buildFolderPagedSliverList(
      context: context,
      ref: ref,
      visibleFolders: visibleFolders,
      searchQuery: searchQuery,
      leadingSlivers: leadingSlivers,
    );
  }

  List<Widget> _buildLeadingSlivers({
    required FolderAsyncController controller,
    required bool hasDecks,
    required int deckCount,
    required String searchQuery,
    required ValueChanged<String> onSearchChanged,
  }) {
    final List<Widget> slivers = <Widget>[
      SliverToBoxAdapter(
        child: _buildFolderHeader(
          controller: controller,
          isDeckManager: hasDecks,
          deckCount: deckCount,
          searchQuery: searchQuery,
          onSearchChanged: onSearchChanged,
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: Insets.spacing16)),
    ];
    if (widget.state.inlineErrorMessage case final String message) {
      slivers.add(
        SliverToBoxAdapter(child: FolderErrorBanner(message: message)),
      );
      slivers.add(
        const SliverToBoxAdapter(child: SizedBox(height: Insets.spacing12)),
      );
    }
    return slivers;
  }

  List<Widget> _buildTrailingSlivers({required bool showLoadMore}) {
    final List<Widget> slivers = <Widget>[];
    if (showLoadMore) {
      slivers.add(SliverToBoxAdapter(child: _buildLoadMoreIndicator()));
    }
    slivers.add(
      const SliverToBoxAdapter(
        child: SizedBox(height: FolderContentConst.listBottomSpacing),
      ),
    );
    return slivers;
  }

  Widget _buildFolderPagedSliverList({
    required BuildContext context,
    required WidgetRef ref,
    required List<FolderNode> visibleFolders,
    required String searchQuery,
    required List<Widget> leadingSlivers,
  }) {
    return LumosPagedSliverList(
      controller: _scrollController,
      leadingSlivers: leadingSlivers,
      trailingSlivers: _buildTrailingSlivers(
        showLoadMore: widget.state.isLoadingMore,
      ),
      itemCount: visibleFolders.length,
      itemBuilder: (BuildContext context, int index) {
        final FolderNode item = visibleFolders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: Insets.spacing8),
          child: _buildFolderTile(context: context, ref: ref, item: item),
        );
      },
      emptySliver: FolderEmptyView(isSearchResult: searchQuery.isNotEmpty),
    );
  }

  Widget _buildDeckPagedSliverList({
    required BuildContext context,
    required WidgetRef ref,
    required int? currentFolderId,
    required AsyncValue<DeckState>? deckAsync,
    required String deckSearchQuery,
    required String searchQuery,
    required List<Widget> leadingSlivers,
  }) {
    final List<Widget> trailingSlivers = _buildTrailingSlivers(
      showLoadMore: false,
    );
    if (currentFolderId == null) {
      return LumosPagedSliverList(
        controller: _scrollController,
        leadingSlivers: leadingSlivers,
        trailingSlivers: trailingSlivers,
        itemCount: 0,
        itemBuilder: _buildUnusedItem,
      );
    }
    if (deckAsync == null) {
      return LumosPagedSliverList(
        controller: _scrollController,
        leadingSlivers: leadingSlivers,
        trailingSlivers: trailingSlivers,
        itemCount: 0,
        itemBuilder: _buildUnusedItem,
      );
    }
    if (deckAsync is AsyncLoading<DeckState>) {
      return LumosPagedSliverList(
        controller: _scrollController,
        leadingSlivers: leadingSlivers,
        trailingSlivers: trailingSlivers,
        itemCount: 0,
        itemBuilder: _buildUnusedItem,
        emptySliver: _buildDeckLoading(),
      );
    }
    if (deckAsync is AsyncError<DeckState>) {
      return LumosPagedSliverList(
        controller: _scrollController,
        leadingSlivers: leadingSlivers,
        trailingSlivers: trailingSlivers,
        itemCount: 0,
        itemBuilder: _buildUnusedItem,
        emptySliver: FolderErrorBanner(
          message: _deckErrorMessage(deckAsync.error),
        ),
      );
    }
    final DeckState deckState = deckAsync.asData!.value;
    final List<Widget> deckLeadingSlivers = <Widget>[...leadingSlivers];
    if (deckState.inlineErrorMessage case final String message) {
      deckLeadingSlivers.add(
        SliverToBoxAdapter(child: FolderErrorBanner(message: message)),
      );
      deckLeadingSlivers.add(
        const SliverToBoxAdapter(child: SizedBox(height: Insets.spacing12)),
      );
    }
    return LumosPagedSliverList(
      controller: _scrollController,
      leadingSlivers: deckLeadingSlivers,
      trailingSlivers: trailingSlivers,
      itemCount: deckState.decks.length,
      itemBuilder: (BuildContext context, int index) {
        final DeckNode item = deckState.decks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: Insets.spacing8),
          child: _buildDeckTile(
            context: context,
            ref: ref,
            folderId: currentFolderId,
            searchQuery: deckSearchQuery,
            item: item,
          ),
        );
      },
      emptySliver: DeckEmptyView(isSearchResult: searchQuery.isNotEmpty),
    );
  }

  static Widget _buildUnusedItem(BuildContext context, int index) {
    return const SizedBox.shrink();
  }

  Widget _buildFolderHeader({
    required FolderAsyncController controller,
    required bool isDeckManager,
    required int deckCount,
    required String searchQuery,
    required ValueChanged<String> onSearchChanged,
  }) {
    return FolderHeader(
      currentDepth: widget.state.currentDepth,
      isDeckManager: isDeckManager,
      deckCount: deckCount,
      isNavigatingParent: widget.state.isNavigatingParent,
      isNavigatingRoot: widget.state.isNavigatingRoot,
      searchQuery: searchQuery,
      onSearchChanged: onSearchChanged,
      sortBy: widget.state.sortBy,
      sortType: widget.state.sortType,
      onSortChanged: (FolderSortBy sortBy, FolderSortType sortType) {
        controller.updateSort(sortBy: sortBy, sortType: sortType);
      },
      onOpenParentFolder: () {
        return controller.navigate(intent: FolderNavigationIntent.parent);
      },
      onOpenRootFolder: () {
        return controller.navigate(intent: FolderNavigationIntent.root);
      },
    );
  }

  Widget _buildDeckLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.spacing16),
      child: Center(child: LumosLoadingIndicator()),
    );
  }

  Widget _buildFolderTile({
    required BuildContext context,
    required WidgetRef ref,
    required FolderNode item,
  }) {
    return FolderTile(
      item: item,
      onOpen: () {
        unawaited(
          ref
              .read(folderAsyncControllerProvider.notifier)
              .openFolder(folder: item),
        );
      },
      onRename: () => showFolderEditorDialog(
        context: context,
        titleBuilder: (AppLocalizations l10n) => l10n.folderRenameTitle,
        actionLabelBuilder: (AppLocalizations l10n) => l10n.commonSave,
        initialFolder: item,
        onSubmitted: (FolderUpsertInput input) {
          return ref
              .read(folderAsyncControllerProvider.notifier)
              .updateFolder(folderId: item.id, input: input);
        },
      ),
      onDelete: () => showFolderConfirmDialog(
        context: context,
        titleBuilder: (AppLocalizations l10n) => l10n.folderDeleteTitle,
        messageBuilder: (AppLocalizations l10n) {
          return l10n.folderDeleteConfirm(item.name);
        },
        confirmLabelBuilder: (AppLocalizations l10n) => l10n.commonDelete,
        onConfirmed: () async {
          await ref
              .read(folderAsyncControllerProvider.notifier)
              .deleteFolder(item.id);
        },
      ),
    );
  }

  Widget _buildDeckTile({
    required BuildContext context,
    required WidgetRef ref,
    required int folderId,
    required String searchQuery,
    required DeckNode item,
  }) {
    return DeckTile(
      item: item,
      onOpen: () {
        context.pushNamed(
          AppRouteName.flashcard,
          pathParameters: <String, String>{
            AppRouteParam.deckId: item.id.toString(),
          },
          queryParameters: <String, String>{AppRouteQuery.deckName: item.name},
        );
      },
      onRename: () => showDeckEditorDialog(
        context: context,
        titleBuilder: (AppLocalizations l10n) => l10n.deckRenameTitle,
        actionLabelBuilder: (AppLocalizations l10n) => l10n.commonSave,
        initialDeck: item,
        onSubmitted: (DeckUpsertInput input) {
          return ref
              .read(deckAsyncControllerProvider(folderId, searchQuery).notifier)
              .updateDeck(deckId: item.id, input: input);
        },
      ),
      onDelete: () => showDeckConfirmDialog(
        context: context,
        titleBuilder: (AppLocalizations l10n) => l10n.deckDeleteTitle,
        messageBuilder: (AppLocalizations l10n) {
          return l10n.deckDeleteConfirm(item.name);
        },
        confirmLabelBuilder: (AppLocalizations l10n) => l10n.commonDelete,
        onConfirmed: () async {
          await ref
              .read(deckAsyncControllerProvider(folderId, searchQuery).notifier)
              .deleteDeck(item.id);
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.only(
        top: FolderContentConst.loadMoreTopSpacing,
        bottom: FolderContentConst.loadMoreBottomSpacing,
      ),
      child: Center(child: LumosLoadingIndicator()),
    );
  }

  Widget _buildCreateButton({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations l10n,
    required double horizontalInset,
    required int? currentFolderId,
    required bool canCreateFolder,
    required bool canCreateDeck,
    required bool isMutating,
    required String deckSearchQuery,
  }) {
    if (isMutating) {
      return const SizedBox.shrink();
    }
    final List<_FolderCreateFabAction> actions = _buildCreateActions(
      context: context,
      ref: ref,
      currentFolderId: currentFolderId,
      canCreateFolder: canCreateFolder,
      canCreateDeck: canCreateDeck,
      deckSearchQuery: deckSearchQuery,
    );
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    final bool isSingleAction = actions.length == 1;
    final _FolderCreateFabAction singleAction = actions.first;
    return Positioned(
      right: horizontalInset,
      bottom: Insets.gapBetweenSections,
      child: LumosFloatingActionButton(
        onPressed: () {
          if (isSingleAction) {
            singleAction.onPressed();
            return;
          }
          _openCreateActionSheet(
            context: context,
            l10n: l10n,
            actions: actions,
          );
        },
        icon: isSingleAction
            ? singleAction.icon
            : Icons.add_circle_outline_rounded,
        label: isSingleAction ? singleAction.label : l10n.commonCreate,
      ),
    );
  }

  List<_FolderCreateFabAction> _buildCreateActions({
    required BuildContext context,
    required WidgetRef ref,
    required int? currentFolderId,
    required bool canCreateFolder,
    required bool canCreateDeck,
    required String deckSearchQuery,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<_FolderCreateFabAction> actions = <_FolderCreateFabAction>[];
    if (canCreateFolder) {
      actions.add(
        _FolderCreateFabAction(
          icon: Icons.create_new_folder_outlined,
          label: l10n.folderNewFolder,
          onPressed: () {
            showFolderEditorDialog(
              context: context,
              titleBuilder: (AppLocalizations l10n) => l10n.folderCreateTitle,
              actionLabelBuilder: (AppLocalizations l10n) => l10n.commonCreate,
              initialFolder: null,
              onSubmitted: (FolderUpsertInput input) {
                return ref
                    .read(folderAsyncControllerProvider.notifier)
                    .createFolder(input);
              },
            );
          },
        ),
      );
    }
    if (canCreateDeck && currentFolderId != null) {
      actions.add(
        _FolderCreateFabAction(
          icon: Icons.style_outlined,
          label: l10n.deckNewDeck,
          onPressed: () {
            showDeckEditorDialog(
              context: context,
              titleBuilder: (AppLocalizations l10n) => l10n.deckCreateTitle,
              actionLabelBuilder: (AppLocalizations l10n) => l10n.commonCreate,
              initialDeck: null,
              onSubmitted: (DeckUpsertInput input) {
                return ref
                    .read(
                      deckAsyncControllerProvider(
                        currentFolderId,
                        deckSearchQuery,
                      ).notifier,
                    )
                    .createDeck(input);
              },
            );
          },
        ),
      );
    }
    return actions;
  }

  void _openCreateActionSheet({
    required BuildContext context,
    required AppLocalizations l10n,
    required List<_FolderCreateFabAction> actions,
  }) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext bottomSheetContext) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                FolderContentConst.createActionSheetHorizontalPadding,
                FolderContentConst.createActionSheetVerticalPadding,
                FolderContentConst.createActionSheetHorizontalPadding,
                FolderContentConst.createActionSheetBottomPadding,
              ),
              child: LumosActionSheet(
                actions: actions
                    .map(
                      (_FolderCreateFabAction action) => LumosActionItem(
                        label: action.label,
                        icon: action.icon,
                        onPressed: () {
                          bottomSheetContext.pop();
                          action.onPressed();
                        },
                      ),
                    )
                    .toList(growable: false),
                cancelText: l10n.commonCancel,
                onCancel: () => bottomSheetContext.pop(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMutatingOverlay({
    required BuildContext context,
    required bool isMutating,
  }) {
    if (!isMutating) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.scrim,
          child: const FolderMutatingOverlay(),
        ),
      ),
    );
  }

  AsyncValue<DeckState>? _watchDeckAsync({
    required int? currentFolderId,
    required String searchQuery,
  }) {
    if (currentFolderId == null) {
      return null;
    }
    return ref.watch(deckAsyncControllerProvider(currentFolderId, searchQuery));
  }

  bool _canManageDecks({
    required int? currentFolderId,
    required List<FolderNode> visibleFolders,
  }) {
    if (currentFolderId == null) {
      return false;
    }
    if (visibleFolders.isNotEmpty) {
      return false;
    }
    return true;
  }

  bool _hasDecks(DeckState? deckState) {
    if (deckState == null) {
      return false;
    }
    return deckState.decks.isNotEmpty;
  }

  int _deckCount(DeckState? deckState) {
    if (deckState == null) {
      return 0;
    }
    return deckState.decks.length;
  }

  bool _isDeckLoading(AsyncValue<DeckState>? deckAsync) {
    if (deckAsync == null) {
      return false;
    }
    return deckAsync is AsyncLoading<DeckState>;
  }

  bool _canCreateFolder({
    required int? currentFolderId,
    required bool canManageDecks,
    required bool hasDecks,
    required bool isDeckLoading,
  }) {
    if (currentFolderId == null) {
      return true;
    }
    if (!canManageDecks) {
      return true;
    }
    if (isDeckLoading) {
      return false;
    }
    if (hasDecks) {
      return false;
    }
    return true;
  }

  bool _canCreateDeck({
    required int? currentFolderId,
    required bool canManageDecks,
    required bool isDeckLoading,
  }) {
    if (currentFolderId == null) {
      return false;
    }
    if (!canManageDecks) {
      return false;
    }
    if (isDeckLoading) {
      return false;
    }
    return true;
  }

  String _deckErrorMessage(Object error) {
    if (error is Failure) {
      return error.message;
    }
    return error.toString();
  }

  String _buildActiveSearchQuery({required bool isDeckSearchMode}) {
    if (isDeckSearchMode) {
      return widget.state.deckSearchQuery;
    }
    return widget.state.searchQuery;
  }

  ValueChanged<String> _buildSearchChangedHandler({
    required FolderAsyncController controller,
    required bool isDeckSearchMode,
  }) {
    if (isDeckSearchMode) {
      return controller.updateDeckSearchQuery;
    }
    return controller.updateSearchQuery;
  }

  Future<void> _onRefresh({
    required FolderAsyncController folderController,
    required int? currentFolderId,
    required String deckSearchQuery,
  }) async {
    await folderController.refresh();
    if (currentFolderId == null) {
      return;
    }
    await ref
        .read(
          deckAsyncControllerProvider(
            currentFolderId,
            deckSearchQuery,
          ).notifier,
        )
        .refresh();
    if (deckSearchQuery == FolderStateConst.emptySearchQuery) {
      return;
    }
    await ref
        .read(
          deckAsyncControllerProvider(
            currentFolderId,
            FolderStateConst.emptySearchQuery,
          ).notifier,
        )
        .refresh();
  }

  void _onScroll() {
    _requestLoadMoreIfNeeded();
  }

  void _requestLoadMoreIfNeeded() {
    if (_isDeckContext()) {
      return;
    }
    if (!widget.state.hasNextPage) {
      return;
    }
    if (widget.state.isLoadingMore) {
      return;
    }
    if (!_scrollController.hasClients) {
      return;
    }
    final ScrollPosition position = _scrollController.position;
    if (!position.isScrollingNotifier.value) {
      return;
    }
    final double remainingScroll = position.maxScrollExtent - position.pixels;
    if (remainingScroll > FolderContentConst.loadMoreThreshold) {
      return;
    }
    final FolderAsyncController controller = ref.read(
      folderAsyncControllerProvider.notifier,
    );
    unawaited(controller.loadMore());
  }

  void _handleScrollToTopSignal({required int? previous, required int next}) {
    if (previous == null) {
      return;
    }
    if (previous == next) {
      return;
    }
    unawaited(_scrollToTop());
  }

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) {
      return;
    }
    final double currentOffset = _scrollController.offset;
    if (currentOffset <= FolderContentConst.scrollTopTriggerOffset) {
      return;
    }
    await _scrollController.animateTo(
      FolderContentConst.scrollTopOffset,
      duration: FolderContentConst.scrollTopDuration,
      curve: Curves.easeOutCubic,
    );
  }

  bool _isDeckContext() {
    if (widget.state.currentParentId == null) {
      return false;
    }
    if (widget.state.visibleFolders.isNotEmpty) {
      return false;
    }
    return true;
  }
}

class _FolderCreateFabAction {
  const _FolderCreateFabAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}
