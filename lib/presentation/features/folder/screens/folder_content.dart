import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/errors/failures.dart';
import '../../../../domain/entities/deck_models.dart';
import '../../../../domain/entities/folder_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../deck/providers/deck_provider.dart';
import '../../deck/providers/states/deck_state.dart';
import '../../deck/screens/widgets/dialogs/deck_dialogs.dart';
import '../providers/folder_provider.dart';
import '../providers/folder_ui_signal_provider.dart';
import '../providers/states/folder_state.dart';
import 'folder_content_support.dart';
import 'widgets/blocks/content/folder_browser_content.dart';
import 'widgets/blocks/footer/folder_create_button.dart';
import 'widgets/dialogs/folder_dialogs.dart';
import 'widgets/states/folder_content_mutating_overlay.dart';

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
    final List<FolderContentSupportCreateAction> createActions =
        _buildCreateActions(
          context: context,
          ref: ref,
          currentFolderId: currentFolderId,
          canCreateFolder: canCreateFolder,
          canCreateDeck: canCreateDeck,
          deckSearchQuery: activeSearchQuery,
        );

    return Stack(
      children: <Widget>[
        AbsorbPointer(
          absorbing: isMutating,
          child: RefreshIndicator(
            onRefresh: () {
              return _onRefresh(
                folderController: folderController,
                currentFolderId: currentFolderId,
                deckSearchQuery: activeSearchQuery,
              );
            },
            child: LumosScreenFrame(
              child: FolderBrowserContent(
                scrollController: _scrollController,
                state: widget.state,
                visibleFolders: visibleFolders,
                currentFolderId: currentFolderId,
                canManageDecks: canManageDecks,
                deckAsync: deckViewAsync,
                hasDecks: hasDecks,
                deckCount: deckCount,
                searchQuery: activeSearchQuery,
                onSearchChanged: onSearchChanged,
                onSortChanged: (FolderSortBy sortBy, FolderSortType sortType) {
                  folderController.updateSort(
                    sortBy: sortBy,
                    sortType: sortType,
                  );
                },
                onOpenParentFolder: () {
                  return folderController.navigate(
                    intent: FolderNavigationIntent.parent,
                  );
                },
                onOpenRootFolder: () {
                  return folderController.navigate(
                    intent: FolderNavigationIntent.root,
                  );
                },
                onOpenFolder: (FolderNode item) {
                  unawaited(
                    ref
                        .read(folderAsyncControllerProvider.notifier)
                        .openFolder(folder: item),
                  );
                },
                onRenameFolder: (BuildContext context, FolderNode item) {
                  unawaited(
                    showFolderEditorDialog(
                      context: context,
                      titleBuilder: (AppLocalizations l10n) =>
                          l10n.folderRenameTitle,
                      actionLabelBuilder: (AppLocalizations l10n) =>
                          l10n.commonSave,
                      initialFolder: item,
                      onSubmitted: (FolderUpsertInput input) {
                        return ref
                            .read(folderAsyncControllerProvider.notifier)
                            .updateFolder(folderId: item.id, input: input);
                      },
                    ),
                  );
                },
                onDeleteFolder: (BuildContext context, FolderNode item) {
                  unawaited(
                    showFolderConfirmDialog(
                      context: context,
                      titleBuilder: (AppLocalizations l10n) =>
                          l10n.folderDeleteTitle,
                      messageBuilder: (AppLocalizations l10n) {
                        return l10n.folderDeleteConfirm(item.name);
                      },
                      confirmLabelBuilder: (AppLocalizations l10n) =>
                          l10n.commonDelete,
                      onConfirmed: () async {
                        await ref
                            .read(folderAsyncControllerProvider.notifier)
                            .deleteFolder(item.id);
                      },
                    ),
                  );
                },
                onCreateFolder: () {
                  _showCreateFolderDialog(context);
                },
                onOpenDeck: (DeckNode item) {
                  if (currentFolderId == null) {
                    return;
                  }
                  DeckDetailRouteData(
                    folderId: currentFolderId,
                    deckId: item.id,
                    deckName: item.name,
                  ).push(context);
                },
                onRenameDeck: (BuildContext context, DeckNode item) {
                  if (currentFolderId == null) {
                    return;
                  }
                  unawaited(
                    showDeckEditorDialog(
                      context: context,
                      titleBuilder: (AppLocalizations l10n) =>
                          l10n.deckRenameTitle,
                      actionLabelBuilder: (AppLocalizations l10n) =>
                          l10n.commonSave,
                      initialDeck: item,
                      onSubmitted: (DeckUpsertInput input) {
                        return ref
                            .read(
                              deckAsyncControllerProvider(
                                currentFolderId,
                                activeSearchQuery,
                                widget.state.sortType.apiValue,
                              ).notifier,
                            )
                            .updateDeck(deckId: item.id, input: input);
                      },
                    ),
                  );
                },
                onDeleteDeck: (BuildContext context, DeckNode item) {
                  if (currentFolderId == null) {
                    return;
                  }
                  unawaited(
                    showDeckConfirmDialog(
                      context: context,
                      titleBuilder: (AppLocalizations l10n) =>
                          l10n.deckDeleteTitle,
                      messageBuilder: (AppLocalizations l10n) {
                        return l10n.deckDeleteConfirm(item.name);
                      },
                      confirmLabelBuilder: (AppLocalizations l10n) =>
                          l10n.commonDelete,
                      onConfirmed: () async {
                        await ref
                            .read(
                              deckAsyncControllerProvider(
                                currentFolderId,
                                activeSearchQuery,
                                widget.state.sortType.apiValue,
                              ).notifier,
                            )
                            .deleteDeck(item.id);
                      },
                    ),
                  );
                },
                deckErrorMessageBuilder: _deckErrorMessage,
              ),
            ),
          ),
        ),
        FolderCreateButton(
          l10n: l10n,
          horizontalInset: horizontalInset,
          actions: createActions,
          isMutating: isMutating,
          onOpenActionSheet: () {
            _openCreateActionSheet(
              context: context,
              l10n: l10n,
              actions: createActions,
            );
          },
        ),
        FolderContentMutatingOverlay(isMutating: isMutating),
      ],
    );
  }

  List<FolderContentSupportCreateAction> _buildCreateActions({
    required BuildContext context,
    required WidgetRef ref,
    required int? currentFolderId,
    required bool canCreateFolder,
    required bool canCreateDeck,
    required String deckSearchQuery,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<FolderContentSupportCreateAction> actions =
        <FolderContentSupportCreateAction>[];
    if (canCreateFolder) {
      actions.add(
        FolderContentSupportCreateAction(
          icon: Icons.create_new_folder_outlined,
          label: l10n.folderNewFolder,
          onPressed: () => _showCreateFolderDialog(context),
        ),
      );
    }
    if (canCreateDeck && currentFolderId != null) {
      actions.add(
        FolderContentSupportCreateAction(
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
                        widget.state.sortType.apiValue,
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

  void _showCreateFolderDialog(BuildContext context) {
    unawaited(
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
      ),
    );
  }

  void _openCreateActionSheet({
    required BuildContext context,
    required AppLocalizations l10n,
    required List<FolderContentSupportCreateAction> actions,
  }) {
    final EdgeInsets actionSheetPadding = context.compactInsets(
      baseInsets: const EdgeInsets.fromLTRB(
        FolderContentSupportConst.createActionSheetHorizontalPadding,
        FolderContentSupportConst.createActionSheetVerticalPadding,
        FolderContentSupportConst.createActionSheetHorizontalPadding,
        FolderContentSupportConst.createActionSheetBottomPadding,
      ),
      minScale: ResponsiveDimensions.compactOuterInsetScale,
    );
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext bottomSheetContext) {
          return SafeArea(
            child: Padding(
              padding: actionSheetPadding,
              child: LumosActionSheet(
                actions: actions
                    .map(
                      (FolderContentSupportCreateAction action) =>
                          LumosActionItem(
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

  AsyncValue<DeckState>? _watchDeckAsync({
    required int? currentFolderId,
    required String searchQuery,
  }) {
    if (currentFolderId == null) {
      return null;
    }
    return ref.watch(
      deckAsyncControllerProvider(
        currentFolderId,
        searchQuery,
        widget.state.sortType.apiValue,
      ),
    );
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
            widget.state.sortType.apiValue,
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
            widget.state.sortType.apiValue,
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
    if (remainingScroll > FolderContentSupportConst.loadMoreThreshold) {
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
    if (currentOffset <= FolderContentSupportConst.scrollTopTriggerOffset) {
      return;
    }
    await _scrollController.animateTo(
      FolderContentSupportConst.scrollTopOffset,
      duration: FolderContentSupportConst.scrollTopDuration,
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
