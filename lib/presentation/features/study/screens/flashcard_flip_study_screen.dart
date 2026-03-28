import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entities/flashcard_models.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
import '../../flashcard/providers/flashcard_provider.dart';
import '../../flashcard/providers/states/flashcard_state.dart';
import 'widgets/blocks/flashcard_study_bottom_bar.dart';
import 'widgets/blocks/flashcard_study_card.dart';

abstract final class FlashcardFlipStudyConst {
  FlashcardFlipStudyConst._();

  static const double screenHorizontalPadding = LumosSpacing.lg;
  static const double screenVerticalPadding = LumosSpacing.md;
  static const double progressTopGap = LumosSpacing.sm;
  static const double progressBottomGap = LumosSpacing.lg;
  static const double cardVerticalInset = LumosSpacing.sm;
  static const double cardContentHorizontalPadding = LumosSpacing.lg;
  static const double cardContentVerticalPadding = LumosSpacing.lg;
  static const double cardActionGap = LumosSpacing.sm;
  static const double cardTitleGap = LumosSpacing.sm;
  static const double cardBottomGap = LumosSpacing.sm;
  static const double bottomBarTopGap = LumosSpacing.sm;
  static const double bottomBarBottomGap = LumosSpacing.lg;
  static const double actionIconSize = LumosSpacing.xl;
  static const double hintIconSize = LumosSpacing.xl;
  static const int backTextMaxLines = 8;
  static const int noteMaxLines = 4;
}

class FlashcardFlipStudyRouteExtra {
  const FlashcardFlipStudyRouteExtra({
    required this.items,
    required this.initialIndex,
    required this.starredFlashcardIds,
  });

  const FlashcardFlipStudyRouteExtra.fallback()
    : items = const <FlashcardNode>[],
      initialIndex = FlashcardStateConst.firstPage,
      starredFlashcardIds = const <int>{};

  final List<FlashcardNode> items;
  final int initialIndex;
  final Set<int> starredFlashcardIds;
}

class FlashcardFlipStudyScreen extends ConsumerStatefulWidget {
  const FlashcardFlipStudyScreen({
    required this.deckId,
    required this.deckName,
    required this.items,
    required this.initialIndex,
    required this.initialStarredFlashcardIds,
    super.key,
  });

  final int deckId;
  final String deckName;
  final List<FlashcardNode> items;
  final int initialIndex;
  final Set<int> initialStarredFlashcardIds;

  @override
  ConsumerState<FlashcardFlipStudyScreen> createState() {
    return _FlashcardFlipStudyScreenState();
  }
}

class _FlashcardFlipStudyScreenState
    extends ConsumerState<FlashcardFlipStudyScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentIndexNotifier;
  late final ValueNotifier<bool> _isFlippedNotifier;
  late final ValueNotifier<Set<int>> _starredFlashcardIdsNotifier;
  late final ValueNotifier<int?> _playingFlashcardIdNotifier;
  Timer? _audioPlayingTimer;

  @override
  void initState() {
    super.initState();
    final int safeInitialIndex = _safeIndex(
      value: widget.initialIndex,
      itemCount: widget.items.length,
    );
    _pageController = PageController(initialPage: safeInitialIndex);
    _currentIndexNotifier = ValueNotifier<int>(safeInitialIndex);
    _isFlippedNotifier = ValueNotifier<bool>(false);
    _starredFlashcardIdsNotifier = ValueNotifier<Set<int>>(
      Set<int>.from(widget.initialStarredFlashcardIds),
    );
    _playingFlashcardIdNotifier = ValueNotifier<int?>(null);
  }

  @override
  void dispose() {
    _audioPlayingTimer?.cancel();
    _playingFlashcardIdNotifier.dispose();
    _starredFlashcardIdsNotifier.dispose();
    _isFlippedNotifier.dispose();
    _currentIndexNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.screenHorizontalPadding,
      minScale: ResponsiveDimensions.compactOuterInsetScale,
    );
    final double screenVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.screenVerticalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double progressTopGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.progressTopGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double progressBottomGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.progressBottomGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardVerticalInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.cardVerticalInset,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double bottomBarTopGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.bottomBarTopGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double bottomBarBottomGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardFlipStudyConst.bottomBarBottomGap,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String title = _displayTitle(
      deckName: widget.deckName,
      fallbackTitle: l10n.flashcardTitle,
    );
    final ThemeData screenTheme = _buildScreenTheme(context: context);
    if (widget.items.isEmpty) {
      return Theme(
        data: screenTheme,
        child: Scaffold(
          appBar: LumosAppBar(
            title: title,
            leading: LumosIconButton(
              onPressed: () => context.pop(),
              tooltip: l10n.flashcardCloseTooltip,
              icon: Icons.arrow_back_rounded,
            ),
          ),
          body: Center(
            child: LumosEmptyState(
              title: l10n.flashcardEmptyTitle,
              message: l10n.flashcardEmptySubtitle,
              icon: Icons.style_outlined,
            ),
          ),
        ),
      );
    }
    return Theme(
      data: screenTheme,
      child: Scaffold(
        appBar: LumosAppBar(
          title: title,
          wrapActions: false,
          leading: LumosIconButton(
            onPressed: () => context.pop(),
            tooltip: l10n.flashcardCloseTooltip,
            icon: Icons.arrow_back_rounded,
          ),
          actions: <Widget>[
            LumosIconButton(
              onPressed: _onSharePressed,
              tooltip: l10n.flashcardShareButtonTooltip,
              size: IconSizes.iconMedium,
              icon: Icons.ios_share_rounded,
            ),
            LumosIconButton(
              onPressed: _onMorePressed,
              tooltip: l10n.flashcardMoreButtonTooltip,
              size: IconSizes.iconMedium,
              icon: Icons.more_vert_rounded,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            screenHorizontalPadding,
            screenVerticalPadding,
            screenHorizontalPadding,
            LumosSpacing.none,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: progressTopGap),
              ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (BuildContext context, int value, Widget? child) {
                  final double progress = (value + 1) / widget.items.length;
                  return LumosProgressBar(value: progress);
                },
              ),
              SizedBox(height: progressBottomGap),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (BuildContext context, int index) {
                    final FlashcardNode item = widget.items[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: cardVerticalInset,
                      ),
                      child: AnimatedBuilder(
                        animation: Listenable.merge(<Listenable>[
                          _currentIndexNotifier,
                          _isFlippedNotifier,
                          _starredFlashcardIdsNotifier,
                          _playingFlashcardIdNotifier,
                        ]),
                        builder: (BuildContext context, Widget? child) {
                          final bool isCurrent =
                              _currentIndexNotifier.value == index;
                          final bool isFlipped =
                              isCurrent && _isFlippedNotifier.value;
                          return FlashcardStudyCard(
                            item: item,
                            isFlipped: isFlipped,
                            isStarred: _starredState(item),
                            isAudioPlaying:
                                _playingFlashcardIdNotifier.value == item.id,
                            onFlipPressed: _toggleFlipped,
                            onAudioPressed: () => _onAudioPressed(item),
                            onStarPressed: () => _onStarPressed(item),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: bottomBarTopGap),
              ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (BuildContext context, int value, Widget? child) {
                  final bool canGoPrevious =
                      value > FlashcardStateConst.firstPage;
                  final bool isAtLastCard = value >= widget.items.length - 1;
                  return FlashcardStudyBottomBar(
                    onPreviousPressed: canGoPrevious ? _goPrevious : null,
                    onNextPressed: () => _goNext(isAtLastCard: isAtLastCard),
                  );
                },
              ),
              SizedBox(height: bottomBarBottomGap),
            ],
          ),
        ),
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

  void _onSharePressed() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    _showInfoSnackBar(message: l10n.flashcardShareComingSoonToast);
  }

  void _onMorePressed() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    _showInfoSnackBar(message: l10n.flashcardMoreOptionsComingSoonToast);
  }

  void _onPageChanged(int index) {
    if (_currentIndexNotifier.value == index) {
      return;
    }
    _currentIndexNotifier.value = index;
    _isFlippedNotifier.value = false;
    _clearAudioPlayingIndicator();
  }

  void _toggleFlipped() {
    _isFlippedNotifier.value = !_isFlippedNotifier.value;
  }

  void _onAudioPressed(FlashcardNode item) {
    _startAudioPlayingIndicator(item.id);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    _showInfoSnackBar(message: l10n.flashcardAudioPlayToast(item.frontText));
  }

  void _onStarPressed(FlashcardNode item) {
    final bool wasStarred = _starredState(item);
    _toggleStar(item.id);
    ref
        .read(
          flashcardAsyncControllerProvider(
            widget.deckId,
            widget.deckName,
          ).notifier,
        )
        .toggleStar(item.id);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String message = wasStarred
        ? l10n.flashcardUnbookmarkToast
        : l10n.flashcardBookmarkToast;
    _showInfoSnackBar(message: message);
  }

  void _toggleStar(int flashcardId) {
    final Set<int> nextIds = Set<int>.from(_starredFlashcardIdsNotifier.value);
    if (nextIds.contains(flashcardId)) {
      nextIds.remove(flashcardId);
      _starredFlashcardIdsNotifier.value = nextIds;
      return;
    }
    nextIds.add(flashcardId);
    _starredFlashcardIdsNotifier.value = nextIds;
  }

  void _goPrevious() {
    _pageController.previousPage(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
    );
  }

  void _goNext({required bool isAtLastCard}) {
    if (isAtLastCard) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      _showInfoSnackBar(message: l10n.flashcardStudyCompletedToast);
      return;
    }
    _pageController.nextPage(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
    );
  }

  bool _starredState(FlashcardNode item) {
    final bool isToggled = _starredFlashcardIdsNotifier.value.contains(item.id);
    if (item.isBookmarked) {
      return !isToggled;
    }
    return isToggled;
  }

  void _startAudioPlayingIndicator(int flashcardId) {
    _audioPlayingTimer?.cancel();
    _playingFlashcardIdNotifier.value = flashcardId;
    _audioPlayingTimer = Timer(
      const Duration(
        milliseconds: FlashcardDomainConst.audioPlayingIndicatorDurationMs,
      ),
      _clearAudioPlayingIndicator,
    );
  }

  void _clearAudioPlayingIndicator() {
    if (_playingFlashcardIdNotifier.value == null) {
      return;
    }
    _playingFlashcardIdNotifier.value = null;
  }

  int _safeIndex({required int value, required int itemCount}) {
    if (itemCount <= 0) {
      return FlashcardStateConst.firstPage;
    }
    final int maxIndex = itemCount - 1;
    if (value < FlashcardStateConst.firstPage) {
      return FlashcardStateConst.firstPage;
    }
    if (value > maxIndex) {
      return maxIndex;
    }
    return value;
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

  void _showInfoSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: LumosSnackbar(
          message: message,
          type: LumosSnackbarType.info,
        ),
      ),
    );
  }
}

