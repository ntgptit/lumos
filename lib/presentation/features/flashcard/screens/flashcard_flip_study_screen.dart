import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entities/flashcard_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/flashcard_provider.dart';
import '../providers/states/flashcard_state.dart';

abstract final class FlashcardFlipStudyConst {
  FlashcardFlipStudyConst._();

  static const double screenHorizontalPadding = AppSpacing.lg;
  static const double screenVerticalPadding = AppSpacing.md;
  static const double progressTopGap = AppSpacing.sm;
  static const double progressBottomGap = AppSpacing.lg;
  static const double cardVerticalInset = AppSpacing.sm;
  static const double cardContentHorizontalPadding = AppSpacing.lg;
  static const double cardContentVerticalPadding = AppSpacing.lg;
  static const double cardActionGap = AppSpacing.sm;
  static const double cardTitleGap = AppSpacing.sm;
  static const double cardBottomGap = AppSpacing.sm;
  static const double bottomBarTopGap = AppSpacing.sm;
  static const double bottomBarBottomGap = AppSpacing.lg;
  static const double actionIconSize = AppSpacing.xl;
  static const double hintIconSize = AppSpacing.xl;
  static const int backTextMaxLines = 8;
  static const int noteMaxLines = 4;
  static const double cardBorderRadius = AppSpacing.lg;
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
          appBar: LumosAppBar(title: title),
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
          leading: LumosIconButton(
            onPressed: () => context.pop(),
            tooltip: l10n.flashcardCloseTooltip,
            icon: Icons.arrow_back_rounded,
          ),
          actions: <Widget>[
            LumosIconButton(
              onPressed: _onSharePressed,
              tooltip: l10n.flashcardShareButtonTooltip,
              icon: Icons.ios_share_rounded,
            ),
            LumosIconButton(
              onPressed: _onMorePressed,
              tooltip: l10n.flashcardMoreButtonTooltip,
              icon: Icons.more_vert_rounded,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            FlashcardFlipStudyConst.screenHorizontalPadding,
            FlashcardFlipStudyConst.screenVerticalPadding,
            FlashcardFlipStudyConst.screenHorizontalPadding,
            AppSpacing.none,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: FlashcardFlipStudyConst.progressTopGap),
              ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (BuildContext context, int value, Widget? child) {
                  final double progress = (value + 1) / widget.items.length;
                  return LumosProgressBar(value: progress);
                },
              ),
              const SizedBox(height: FlashcardFlipStudyConst.progressBottomGap),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (BuildContext context, int index) {
                    final FlashcardNode item = widget.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: FlashcardFlipStudyConst.cardVerticalInset,
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
                          return _FlashcardStudyCard(
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
              const SizedBox(height: FlashcardFlipStudyConst.bottomBarTopGap),
              ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (BuildContext context, int value, Widget? child) {
                  final bool canGoPrevious =
                      value > FlashcardStateConst.firstPage;
                  final bool isAtLastCard = value >= widget.items.length - 1;
                  return _FlashcardStudyBottomBar(
                    onPreviousPressed: canGoPrevious ? _goPrevious : null,
                    onNextPressed: () => _goNext(isAtLastCard: isAtLastCard),
                  );
                },
              ),
              const SizedBox(
                height: FlashcardFlipStudyConst.bottomBarBottomGap,
              ),
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
      LumosSnackbar(
        context: context,
        message: message,
        type: LumosSnackbarType.info,
      ),
    );
  }
}

class _FlashcardStudyCard extends StatelessWidget {
  const _FlashcardStudyCard({
    required this.item,
    required this.isFlipped,
    required this.isStarred,
    required this.isAudioPlaying,
    required this.onFlipPressed,
    required this.onAudioPressed,
    required this.onStarPressed,
  });

  final FlashcardNode item;
  final bool isFlipped;
  final bool isStarred;
  final bool isAudioPlaying;
  final VoidCallback onFlipPressed;
  final VoidCallback onAudioPressed;
  final VoidCallback onStarPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String normalizedNote = StringUtils.normalizeName(item.note);
    final bool hasNote = normalizedNote.isNotEmpty;
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadius.circular(
        FlashcardFlipStudyConst.cardBorderRadius,
      ),
      onTap: onFlipPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FlashcardFlipStudyConst.cardContentHorizontalPadding,
          vertical: FlashcardFlipStudyConst.cardContentVerticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                LumosIconButton(
                  onPressed: onAudioPressed,
                  tooltip: l10n.flashcardPlayAudioTooltip,
                  icon: Icons.volume_up_outlined,
                  size: FlashcardFlipStudyConst.actionIconSize,
                  selected: isAudioPlaying,
                  selectedIcon: Icons.graphic_eq_rounded,
                ),
                const Spacer(),
                LumosIconButton(
                  onPressed: onStarPressed,
                  tooltip: l10n.flashcardBookmarkTooltip,
                  icon: Icons.star_border,
                  size: FlashcardFlipStudyConst.actionIconSize,
                  selected: isStarred,
                  selectedIcon: Icons.star,
                ),
              ],
            ),
            const SizedBox(height: FlashcardFlipStudyConst.cardTitleGap),
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppDurations.medium,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  child: isFlipped
                      ? Column(
                          key: const ValueKey<String>('flashcard-back'),
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LumosInlineText(
                              item.backText,
                              align: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                              maxLines:
                                  FlashcardFlipStudyConst.backTextMaxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasNote)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: FlashcardFlipStudyConst.cardTitleGap,
                                ),
                                child: LumosInlineText(
                                  normalizedNote,
                                  align: TextAlign.center,
                                  style: theme.textTheme.bodyMedium,
                                  maxLines:
                                      FlashcardFlipStudyConst.noteMaxLines,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        )
                      : LumosInlineText(
                          item.frontText,
                          key: const ValueKey<String>('flashcard-front'),
                          align: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                          maxLines: FlashcardFlipStudyConst.backTextMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ),
            const SizedBox(height: FlashcardFlipStudyConst.cardBottomGap),
            Center(
              child: const LumosIcon(
                Icons.flip_to_back_rounded,
                size: FlashcardFlipStudyConst.hintIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashcardStudyBottomBar extends StatelessWidget {
  const _FlashcardStudyBottomBar({
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  final VoidCallback? onPreviousPressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosButton(
            onPressed: onPreviousPressed,
            icon: Icons.navigate_before_rounded,
            label: l10n.flashcardPreviousButton,
            type: LumosButtonType.outline,
          ),
        ),
        const SizedBox(width: FlashcardFlipStudyConst.cardActionGap),
        Expanded(
          child: LumosButton(
            onPressed: onNextPressed,
            icon: Icons.navigate_next_rounded,
            label: l10n.flashcardNextButton,
          ),
        ),
      ],
    );
  }
}
