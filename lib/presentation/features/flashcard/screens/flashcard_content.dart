import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entities/flashcard_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../../home/screens/widgets/blocks/home_bottom_nav.dart';
import '../providers/flashcard_provider.dart';
import '../providers/states/flashcard_state.dart';
import '../../study/screens/flashcard_flip_study_screen.dart';
import 'widgets/blocks/flashcard_card_section_header.dart';
import 'widgets/blocks/flashcard_preview_carousel.dart';
import 'widgets/blocks/flashcard_set_metadata_section.dart';
import 'widgets/blocks/flashcard_study_action_section.dart';
import 'widgets/blocks/flashcard_study_progress_section.dart';
import 'widgets/blocks/flashcard_tile.dart';
import 'widgets/dialogs/flashcard_dialogs.dart';
import 'widgets/states/flashcard_empty_view.dart';

abstract final class FlashcardContentConst {
  FlashcardContentConst._();

  static const Duration searchDebounceDuration = AppDurations.medium;
  static const double listBottomSpacing = AppSpacing.canvas;
  static const double loadMoreThreshold = AppSpacing.canvas;
  static const double listItemSpacing = AppSpacing.sm;
  static const double sectionSpacing = AppSpacing.lg;
  static const double progressMaskTopInset = AppSpacing.sm;
  static const double progressMaskHeight = WidgetSizes.progressTrackHeight;
  static const double previewViewportFraction = 0.96;
  static const double screenVerticalPadding = AppSpacing.lg;
  static const int defaultLearningProgressCount = 0;
}

class FlashcardContent extends ConsumerStatefulWidget {
  const FlashcardContent({required this.state, super.key});

  final FlashcardState state;

  @override
  ConsumerState<FlashcardContent> createState() => _FlashcardContentState();
}

class _FlashcardContentState extends ConsumerState<FlashcardContent> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final PageController _previewController;
  Timer? _searchDebounceTimer;
  bool _isDisposed = false;

  FlashcardAsyncController get _controller {
    final FlashcardState currentState = widget.state;
    return ref.read(
      flashcardAsyncControllerProvider(
        currentState.deckId,
        currentState.deckName,
      ).notifier,
    );
  }

  @override
  void initState() {
    super.initState();
    final FlashcardState initialState = widget.state;
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController(text: initialState.searchQuery);
    _previewController = PageController(
      initialPage: initialState.safePreviewIndex,
      viewportFraction: FlashcardContentConst.previewViewportFraction,
    );
  }

  @override
  void didUpdateWidget(covariant FlashcardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSearchController();
    _syncPreviewController();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchDebounceTimer?.cancel();
    _previewController.dispose();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _syncSearchController();
    final FlashcardState state = widget.state;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String title = _displayTitle(
      deckName: state.deckName,
      fallbackTitle: l10n.flashcardTitle,
    );
    final ThemeData screenTheme = _buildScreenTheme(context: context);
    return Theme(
      data: screenTheme,
      child: Scaffold(
        appBar: LumosAppBar(
          title: title,
          wrapActions: false,
          actions: <Widget>[
            LumosIconButton(
              onPressed: _toggleSearchVisibility,
              tooltip: l10n.flashcardToggleSearchTooltip,
              size: IconSizes.iconMedium,
              icon: state.isSearchVisible
                  ? Icons.search_off_rounded
                  : Icons.search_rounded,
            ),
            LumosIconButton(
              onPressed: () => _showSortSheet(context: context, l10n: l10n),
              tooltip: l10n.flashcardSortButtonTooltip,
              size: IconSizes.iconMedium,
              icon: Icons.tune_rounded,
            ),
            LumosIconButton(
              onPressed: () => _openCreateDialog(context: context, l10n: l10n),
              tooltip: l10n.flashcardCreateButton,
              size: IconSizes.iconMedium,
              icon: Icons.add_rounded,
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: _controller.refresh,
              child: LumosScreenFrame(
                verticalPadding: FlashcardContentConst.screenVerticalPadding,
                child: _buildPagedList(
                  context: context,
                  state: state,
                  l10n: l10n,
                ),
              ),
            ),
            _buildLoadingMask(isVisible: state.isRefreshing),
            _buildMutatingOverlay(isVisible: state.isMutating),
          ],
        ),
        bottomNavigationBar: context.deviceType == DeviceType.mobile
            ? const HomeBottomNav()
            : null,
      ),
    );
  }

  ThemeData _buildScreenTheme({required BuildContext context}) {
    final ThemeData baseTheme = Theme.of(context);
    final ColorScheme colorScheme = baseTheme.colorScheme;
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildPagedList({
    required BuildContext context,
    required FlashcardState state,
    required AppLocalizations l10n,
  }) {
    return LumosPagedSliverList(
      controller: _scrollController,
      leadingSlivers: _buildLeadingSlivers(
        context: context,
        state: state,
        l10n: l10n,
      ),
      trailingSlivers: _buildTrailingSlivers(state: state),
      itemCount: state.items.length,
      itemBuilder: (BuildContext context, int index) {
        final FlashcardNode item = state.items[index];
        return Padding(
          key: ValueKey<int>(item.id),
          padding: const EdgeInsets.only(
            bottom: FlashcardContentConst.listItemSpacing,
          ),
          child: _buildFlashcardTile(
            context: context,
            l10n: l10n,
            item: item,
            state: state,
          ),
        );
      },
      emptySliver: FlashcardEmptyView(
        isSearchResult: state.searchQuery.isNotEmpty,
        onCreatePressed: () => _openCreateDialog(context: context, l10n: l10n),
      ),
    );
  }

  List<Widget> _buildLeadingSlivers({
    required BuildContext context,
    required FlashcardState state,
    required AppLocalizations l10n,
  }) {
    final List<Widget> slivers = <Widget>[];
    if (state.inlineErrorMessage case final String message) {
      slivers.add(
        SliverToBoxAdapter(child: _FlashcardErrorBanner(message: message)),
      );
      slivers.add(
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
      );
    }
    if (state.hasItems) {
      slivers.add(
        SliverToBoxAdapter(
          child: FlashcardPreviewCarousel(
            items: state.items,
            pageController: _previewController,
            previewIndex: state.safePreviewIndex,
            onPageChanged: _controller.setPreviewIndex,
            onExpandPressed: _openStudyScreenFromPreview,
          ),
        ),
      );
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: FlashcardContentConst.sectionSpacing,
            ),
            child: FlashcardSetMetadataSection(
              title: _displayTitle(
                deckName: state.deckName,
                fallbackTitle: l10n.flashcardTitle,
              ),
              totalFlashcards: state.totalElements,
            ),
          ),
        ),
      );
    }
    if (state.isSearchVisible) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: FlashcardContentConst.sectionSpacing,
            ),
            child: LumosSearchBar(
              controller: _searchController,
              autoFocus: true,
              hint: l10n.flashcardSearchHint,
              clearTooltip: l10n.flashcardSearchClearTooltip,
              onSearch: _onSearchChanged,
              onClear: _onSearchCleared,
            ),
          ),
        ),
      );
    }
    if (state.hasItems) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: FlashcardContentConst.sectionSpacing,
            ),
            child: FlashcardStudyActionSection(
              actions: _buildStudyActions(l10n: l10n),
            ),
          ),
        ),
      );
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: FlashcardContentConst.sectionSpacing,
            ),
            child: FlashcardStudyProgressSection(
              title: l10n.flashcardProgressTitle,
              description: l10n.flashcardProgressDescription,
              notStartedLabel: l10n.flashcardProgressNotStartedLabel,
              learningLabel: l10n.flashcardProgressLearningLabel,
              masteredLabel: l10n.flashcardProgressMasteredLabel,
              notStartedCount: _notStartedCount(state: state),
              learningCount: FlashcardContentConst.defaultLearningProgressCount,
              masteredCount: _masteredCount(state: state),
              totalCount: state.totalElements,
              onNotStartedPressed: () {
                _openStudyScreen(initialIndex: widget.state.safePreviewIndex);
              },
              onLearningPressed: () {
                _openStudyScreen(initialIndex: widget.state.safePreviewIndex);
              },
              onMasteredPressed: () {
                _openStudyScreen(initialIndex: widget.state.safePreviewIndex);
              },
            ),
          ),
        ),
      );
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: FlashcardContentConst.sectionSpacing,
            ),
            child: FlashcardCardSectionHeader(
              title: l10n.flashcardCardSectionTitle,
              subtitle: l10n.flashcardTotalLabel(state.totalElements),
              sortLabel: _buildSortLabel(l10n: l10n, state: state),
              onSortPressed: () => _showSortSheet(context: context, l10n: l10n),
            ),
          ),
        ),
      );
      slivers.add(
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
      );
    }
    return slivers;
  }

  List<Widget> _buildTrailingSlivers({required FlashcardState state}) {
    final List<Widget> slivers = <Widget>[];
    if (state.isLoadingMore) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: Center(child: LumosLoadingIndicator()),
          ),
        ),
      );
    }
    slivers.add(
      const SliverToBoxAdapter(
        child: SizedBox(height: FlashcardContentConst.listBottomSpacing),
      ),
    );
    return slivers;
  }

  Widget _buildFlashcardTile({
    required BuildContext context,
    required AppLocalizations l10n,
    required FlashcardNode item,
    required FlashcardState state,
  }) {
    final bool isStarred = _starredStateForItem(item: item, state: state);
    final bool isAudioPlaying = state.playingFlashcardId == item.id;
    return FlashcardTile(
      item: item,
      isStarred: isStarred,
      isAudioPlaying: isAudioPlaying,
      onAudioPressed: () {
        _controller.startAudioPlayingIndicator(item.id);
        _showInfoSnackBar(
          context: context,
          message: l10n.flashcardAudioPlayToast(item.frontText),
        );
      },
      onStarPressed: () {
        _controller.toggleStar(item.id);
        final String message = isStarred
            ? l10n.flashcardUnbookmarkToast
            : l10n.flashcardBookmarkToast;
        _showInfoSnackBar(context: context, message: message);
      },
      onEditPressed: () =>
          _openEditDialog(context: context, l10n: l10n, item: item),
      onDeletePressed: () =>
          _openDeleteDialog(context: context, l10n: l10n, item: item),
    );
  }

  List<FlashcardStudyAction> _buildStudyActions({
    required AppLocalizations l10n,
  }) {
    return <FlashcardStudyAction>[
      FlashcardStudyAction(
        label: l10n.flashcardReviewActionLabel,
        icon: Icons.layers_rounded,
        onPressed: () =>
            _openStudyScreen(initialIndex: widget.state.safePreviewIndex),
        tone: FlashcardStudyActionTone.primary,
      ),
      FlashcardStudyAction(
        label: l10n.flashcardLearnActionLabel,
        icon: Icons.refresh_rounded,
        onPressed: () =>
            _openStudyScreen(initialIndex: widget.state.safePreviewIndex),
        tone: FlashcardStudyActionTone.info,
      ),
      FlashcardStudyAction(
        label: l10n.flashcardQuizActionLabel,
        icon: Icons.description_outlined,
        onPressed: () =>
            _openStudyScreen(initialIndex: widget.state.safePreviewIndex),
        tone: FlashcardStudyActionTone.warning,
      ),
      FlashcardStudyAction(
        label: l10n.flashcardMatchActionLabel,
        icon: Icons.compare_arrows_rounded,
        onPressed: () =>
            _openStudyScreen(initialIndex: widget.state.safePreviewIndex),
        tone: FlashcardStudyActionTone.success,
      ),
      FlashcardStudyAction(
        label: l10n.flashcardBlastActionLabel,
        icon: Icons.rocket_launch_rounded,
        onPressed: () =>
            _openStudyScreen(initialIndex: widget.state.safePreviewIndex),
        tone: FlashcardStudyActionTone.primary,
      ),
    ];
  }

  Widget _buildLoadingMask({required bool isVisible}) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: FlashcardContentConst.progressMaskTopInset,
          ),
          child: ClipRRect(
            borderRadius: BorderRadii.medium,
            child: const LumosLoadingIndicator(
              isLinear: true,
              size: FlashcardContentConst.progressMaskHeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMutatingOverlay({required bool isVisible}) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.scrim,
          child: const Center(child: LumosLoadingIndicator()),
        ),
      ),
    );
  }

  int _masteredCount({required FlashcardState state}) {
    final int totalCount = state.totalElements;
    final int starredCount = state.starredFlashcardIds.length;
    if (starredCount <= totalCount) {
      return starredCount;
    }
    return totalCount;
  }

  int _notStartedCount({required FlashcardState state}) {
    final int totalCount = state.totalElements;
    final int remainingCount = totalCount - _masteredCount(state: state);
    if (remainingCount < 0) {
      return 0;
    }
    return remainingCount;
  }

  Future<void> _openCreateDialog({
    required BuildContext context,
    required AppLocalizations l10n,
  }) {
    return showFlashcardEditorDialog(
      context: context,
      titleBuilder: (AppLocalizations l10n) => l10n.flashcardCreateTitle,
      actionLabelBuilder: (AppLocalizations l10n) => l10n.commonCreate,
      initialFlashcard: null,
      onSubmitted: _controller.createFlashcard,
    );
  }

  Future<void> _openEditDialog({
    required BuildContext context,
    required AppLocalizations l10n,
    required FlashcardNode item,
  }) {
    return showFlashcardEditorDialog(
      context: context,
      titleBuilder: (AppLocalizations l10n) => l10n.flashcardEditTitle,
      actionLabelBuilder: (AppLocalizations l10n) => l10n.commonSave,
      initialFlashcard: item,
      onSubmitted: (FlashcardUpsertInput input) {
        return _controller.updateFlashcard(flashcardId: item.id, input: input);
      },
    );
  }

  Future<void> _openDeleteDialog({
    required BuildContext context,
    required AppLocalizations l10n,
    required FlashcardNode item,
  }) {
    return showFlashcardConfirmDialog(
      context: context,
      titleBuilder: (AppLocalizations l10n) => l10n.flashcardDeleteTitle,
      messageBuilder: (AppLocalizations l10n) {
        return l10n.flashcardDeleteConfirm(item.frontText);
      },
      confirmLabelBuilder: (AppLocalizations l10n) => l10n.commonDelete,
      onConfirmed: () async {
        await _controller.deleteFlashcard(item.id);
      },
    );
  }

  void _toggleSearchVisibility() {
    final bool nextSearchVisible = !widget.state.isSearchVisible;
    _controller.toggleSearchVisibility();
    if (nextSearchVisible) {
      return;
    }
    _searchDebounceTimer?.cancel();
  }

  void _onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      FlashcardContentConst.searchDebounceDuration,
      () {
        _controller.updateSearchQuery(value);
      },
    );
  }

  void _onSearchCleared() {
    _searchDebounceTimer?.cancel();
    _searchController.clear();
    _controller.updateSearchQuery('');
  }

  void _onScroll() {
    final FlashcardState state = widget.state;
    if (!state.hasNext) {
      return;
    }
    if (state.isLoadingMore) {
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
    if (remainingScroll > FlashcardContentConst.loadMoreThreshold) {
      return;
    }
    unawaited(_controller.loadMore());
  }

  void _syncSearchController() {
    final String searchQuery = widget.state.searchQuery;
    if (_searchController.text == searchQuery) {
      return;
    }
    _searchController.value = TextEditingValue(
      text: searchQuery,
      selection: TextSelection.collapsed(offset: searchQuery.length),
    );
  }

  void _syncPreviewController() {
    if (_isDisposed) {
      return;
    }
    if (!_previewController.hasClients) {
      return;
    }
    final int targetIndex = widget.state.safePreviewIndex;
    final int currentIndex = _previewController.page?.round() ?? targetIndex;
    if (currentIndex == targetIndex) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed) {
        return;
      }
      if (!_previewController.hasClients) {
        return;
      }
      _previewController.jumpToPage(targetIndex);
    });
  }

  String _buildSortLabel({
    required AppLocalizations l10n,
    required FlashcardState state,
  }) {
    if (state.sortDirection == FlashcardSortDirection.desc) {
      return _descDirectionLabel(l10n: l10n, sortBy: state.sortBy);
    }
    return _ascDirectionLabel(l10n: l10n, sortBy: state.sortBy);
  }

  String _descDirectionLabel({
    required AppLocalizations l10n,
    required FlashcardSortBy sortBy,
  }) {
    if (sortBy == FlashcardSortBy.frontText) {
      return l10n.flashcardSortDirectionZa;
    }
    return l10n.flashcardSortDirectionDesc;
  }

  String _ascDirectionLabel({
    required AppLocalizations l10n,
    required FlashcardSortBy sortBy,
  }) {
    if (sortBy == FlashcardSortBy.frontText) {
      return l10n.flashcardSortDirectionAz;
    }
    return l10n.flashcardSortDirectionAsc;
  }

  Future<void> _showSortSheet({
    required BuildContext context,
    required AppLocalizations l10n,
  }) {
    final FlashcardState state = widget.state;
    FlashcardSortBy selectedSortBy = state.sortBy;
    FlashcardSortDirection selectedSortDirection = state.sortDirection;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder:
              (
                BuildContext context,
                void Function(void Function()) setSheetState,
              ) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LumosText(
                          l10n.flashcardSortSheetTitle,
                          style: LumosTextStyle.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildSortOptionTile(
                          context: context,
                          label: l10n.flashcardSortByCreatedAt,
                          isSelected:
                              selectedSortBy == FlashcardSortBy.createdAt,
                          onTap: () {
                            setSheetState(() {
                              selectedSortDirection =
                                  _nextDirectionForSortSelection(
                                    currentSortBy: selectedSortBy,
                                    currentSortDirection: selectedSortDirection,
                                    nextSortBy: FlashcardSortBy.createdAt,
                                  );
                              selectedSortBy = FlashcardSortBy.createdAt;
                            });
                          },
                        ),
                        _buildSortOptionTile(
                          context: context,
                          label: l10n.flashcardSortByUpdatedAt,
                          isSelected:
                              selectedSortBy == FlashcardSortBy.updatedAt,
                          onTap: () {
                            setSheetState(() {
                              selectedSortDirection =
                                  _nextDirectionForSortSelection(
                                    currentSortBy: selectedSortBy,
                                    currentSortDirection: selectedSortDirection,
                                    nextSortBy: FlashcardSortBy.updatedAt,
                                  );
                              selectedSortBy = FlashcardSortBy.updatedAt;
                            });
                          },
                        ),
                        _buildSortOptionTile(
                          context: context,
                          label: l10n.flashcardSortByFrontText,
                          isSelected:
                              selectedSortBy == FlashcardSortBy.frontText,
                          onTap: () {
                            setSheetState(() {
                              selectedSortDirection =
                                  _nextDirectionForSortSelection(
                                    currentSortBy: selectedSortBy,
                                    currentSortDirection: selectedSortDirection,
                                    nextSortBy: FlashcardSortBy.frontText,
                                  );
                              selectedSortBy = FlashcardSortBy.frontText;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildSortOptionTile(
                          context: context,
                          label: _descDirectionLabel(
                            l10n: l10n,
                            sortBy: selectedSortBy,
                          ),
                          isSelected:
                              selectedSortDirection ==
                              FlashcardSortDirection.desc,
                          onTap: () {
                            setSheetState(() {
                              selectedSortDirection =
                                  FlashcardSortDirection.desc;
                            });
                          },
                        ),
                        _buildSortOptionTile(
                          context: context,
                          label: _ascDirectionLabel(
                            l10n: l10n,
                            sortBy: selectedSortBy,
                          ),
                          isSelected:
                              selectedSortDirection ==
                              FlashcardSortDirection.asc,
                          onTap: () {
                            setSheetState(() {
                              selectedSortDirection =
                                  FlashcardSortDirection.asc;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LumosPrimaryButton(
                          onPressed: () {
                            sheetContext.pop();
                            _applySort(
                              selectedSortBy: selectedSortBy,
                              selectedSortDirection: selectedSortDirection,
                            );
                          },
                          label: l10n.flashcardSortSaveButton,
                        ),
                      ],
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  Widget _buildSortOptionTile({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color tileBackground = isSelected
        ? colorScheme.secondaryContainer
        : colorScheme.surfaceContainerLow;
    final Color tileForeground = isSelected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurface;
    return Container(
      decoration: BoxDecoration(
        color: tileBackground,
        borderRadius: BorderRadii.medium,
      ),
      child: LumosListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        title: LumosInlineText(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: tileForeground),
        ),
        trailing: isSelected ? const LumosIcon(Icons.check_rounded) : null,
        onTap: onTap,
      ),
    );
  }

  void _applySort({
    required FlashcardSortBy selectedSortBy,
    required FlashcardSortDirection selectedSortDirection,
  }) {
    final FlashcardState state = widget.state;
    final bool isSortByChanged = selectedSortBy != state.sortBy;
    final bool isSortDirectionChanged =
        selectedSortDirection != state.sortDirection;
    if (!isSortByChanged && !isSortDirectionChanged) {
      return;
    }
    _controller.applySort(
      sortBy: selectedSortBy,
      direction: selectedSortDirection,
    );
  }

  FlashcardSortDirection _nextDirectionForSortSelection({
    required FlashcardSortBy currentSortBy,
    required FlashcardSortDirection currentSortDirection,
    required FlashcardSortBy nextSortBy,
  }) {
    if (nextSortBy == FlashcardSortBy.frontText) {
      if (currentSortBy != FlashcardSortBy.frontText) {
        return FlashcardSortDirection.asc;
      }
      return _toggleSortDirection(currentSortDirection);
    }
    if (nextSortBy == currentSortBy) {
      return currentSortDirection;
    }
    return FlashcardSortDirection.desc;
  }

  FlashcardSortDirection _toggleSortDirection(FlashcardSortDirection value) {
    if (value == FlashcardSortDirection.asc) {
      return FlashcardSortDirection.desc;
    }
    return FlashcardSortDirection.asc;
  }

  void _openStudyScreenFromPreview(int previewIndex) {
    _openStudyScreen(initialIndex: previewIndex);
  }

  void _openStudyScreen({required int initialIndex}) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final FlashcardState state = widget.state;
    if (state.items.isEmpty) {
      _showInfoSnackBar(
        context: context,
        message: l10n.flashcardStudyUnavailableToast,
      );
      return;
    }
    final int safeIndex = _safeStudyIndex(
      initialIndex: initialIndex,
      itemCount: state.items.length,
    );
    final FlashcardFlipStudyRouteExtra extra = FlashcardFlipStudyRouteExtra(
      items: state.items,
      initialIndex: safeIndex,
      starredFlashcardIds: state.starredFlashcardIds.toSet(),
    );
    context.pushNamed(
      AppRouteName.flashcardStudy,
      pathParameters: <String, String>{
        AppRouteParam.deckId: state.deckId.toString(),
      },
      queryParameters: <String, String>{AppRouteQuery.deckName: state.deckName},
      extra: extra,
    );
  }

  int _safeStudyIndex({required int initialIndex, required int itemCount}) {
    if (itemCount == 0) {
      return FlashcardStateConst.firstPage;
    }
    final int maxIndex = itemCount - 1;
    if (initialIndex < FlashcardStateConst.firstPage) {
      return FlashcardStateConst.firstPage;
    }
    if (initialIndex > maxIndex) {
      return maxIndex;
    }
    return initialIndex;
  }

  bool _starredStateForItem({
    required FlashcardNode item,
    required FlashcardState state,
  }) {
    final bool isToggled = state.isStarred(item.id);
    if (item.isBookmarked) {
      return !isToggled;
    }
    return isToggled;
  }

  String _displayTitle({
    required String deckName,
    required String fallbackTitle,
  }) {
    final String normalizedDeckName = StringUtils.normalizeName(deckName);
    if (normalizedDeckName.isEmpty) {
      return fallbackTitle;
    }
    return normalizedDeckName;
  }

  void _showInfoSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      LumosSnackbar(
        context: context,
        message: message,
        type: LumosSnackbarType.info,
      ),
    );
  }
}

class _FlashcardErrorBanner extends StatelessWidget {
  const _FlashcardErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadii.medium,
      ),
      child: LumosText(
        message,
        style: LumosTextStyle.bodySmall,
        containerRole: LumosTextContainerRole.errorContainer,
      ),
    );
  }
}
