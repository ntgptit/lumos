import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardPreviewCarouselConst {
  FlashcardPreviewCarouselConst._();

  static const double carouselHeight = AppSpacing.section * 6;
  static const double pageSpacing = AppSpacing.xs;
  static const double dotSpacing = AppSpacing.xs;
  static const double activeDotScale = 1.7;
  static const double dotSize = AppSpacing.sm;
  static const double titleHorizontalPadding = AppSpacing.xl;
  static const double titleVerticalPadding = AppSpacing.lg;
  static const double expandButtonInset = AppSpacing.sm;
  static const double expandIconSize = AppSpacing.xl;
  static const double frontTextFontSize = AppTypographyConst.titleLargeFontSize;
  static const double frontTextHeight =
      AppTypographyConst.titleLargeLineHeight / frontTextFontSize;
  static const double horizontalScrollActivationOffset = AppSpacing.xs;
}

class FlashcardPreviewCarousel extends StatelessWidget {
  const FlashcardPreviewCarousel({
    required this.items,
    required this.pageController,
    required this.previewIndex,
    required this.onPageChanged,
    required this.onExpandPressed,
    super.key,
  });

  final List<FlashcardNode> items;
  final PageController pageController;
  final int previewIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onExpandPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int dotCount = _dotCount();
    final int safePreviewIndex = _safePreviewIndex(dotCount: dotCount);
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: FlashcardPreviewCarouselConst.carouselHeight,
            child: Listener(
              onPointerSignal: (PointerSignalEvent event) {
                if (event is! PointerScrollEvent) {
                  return;
                }
                if (!_isHorizontalScroll(event)) {
                  return;
                }
                _handlePointerScroll(event: event, dotCount: dotCount);
              },
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: <PointerDeviceKind>{
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.invertedStylus,
                  },
                ),
                child: PageView.builder(
                  controller: pageController,
                  itemCount: dotCount,
                  onPageChanged: onPageChanged,
                  itemBuilder: (BuildContext context, int index) {
                    final FlashcardNode? item = _itemAt(index);
                    final String title =
                        item?.frontText ?? l10n.flashcardPreviewPlaceholder;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FlashcardPreviewCarouselConst.pageSpacing,
                      ),
                      child: LumosCard(
                        variant: LumosCardVariant.filled,
                        borderRadius: BorderRadii.xLarge,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: FlashcardPreviewCarouselConst
                                      .titleHorizontalPadding,
                                  vertical: FlashcardPreviewCarouselConst
                                      .titleVerticalPadding,
                                ),
                                child: LumosInlineText(
                                  title,
                                  align: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontSize: FlashcardPreviewCarouselConst
                                            .frontTextFontSize,
                                        height: FlashcardPreviewCarouselConst
                                            .frontTextHeight,
                                        letterSpacing: AppTypographyConst
                                            .titleMediumLetterSpacing,
                                        fontWeight: AppTypographyConst
                                            .kFontWeightSemiBold,
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: FlashcardPreviewCarouselConst
                                  .expandButtonInset,
                              bottom: FlashcardPreviewCarouselConst
                                  .expandButtonInset,
                              child: LumosIconButton(
                                onPressed: () => onExpandPressed(index),
                                tooltip: l10n.flashcardExpandPreviewTooltip,
                                icon: Icons.fullscreen_rounded,
                                size: FlashcardPreviewCarouselConst
                                    .expandIconSize,
                                variant: LumosIconButtonVariant.tonal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(dotCount, (int index) {
              final bool isActive = index == safePreviewIndex;
              final ColorScheme colorScheme = Theme.of(context).colorScheme;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FlashcardPreviewCarouselConst.dotSpacing,
                ),
                child: SizedBox(
                  width:
                      FlashcardPreviewCarouselConst.dotSize *
                      FlashcardPreviewCarouselConst.activeDotScale,
                  height:
                      FlashcardPreviewCarouselConst.dotSize *
                      FlashcardPreviewCarouselConst.activeDotScale,
                  child: Center(
                    child: AnimatedScale(
                      duration: MotionDurations.animationFast,
                      scale: isActive
                          ? FlashcardPreviewCarouselConst.activeDotScale
                          : WidgetRatios.full,
                      child: Container(
                        width: FlashcardPreviewCarouselConst.dotSize,
                        height: FlashcardPreviewCarouselConst.dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  FlashcardNode? _itemAt(int index) {
    if (items.isEmpty) {
      return null;
    }
    return items[index];
  }

  int _dotCount() {
    if (items.isEmpty) {
      return 1;
    }
    final int limit = FlashcardDomainConst.previewItemLimit;
    if (items.length <= limit) {
      return items.length;
    }
    return limit;
  }

  int _safePreviewIndex({required int dotCount}) {
    final int maxIndex = dotCount - 1;
    if (previewIndex > maxIndex) {
      return maxIndex;
    }
    if (previewIndex < 0) {
      return 0;
    }
    return previewIndex;
  }

  void _handlePointerScroll({
    required PointerScrollEvent event,
    required int dotCount,
  }) {
    if (!pageController.hasClients) {
      return;
    }
    final double horizontalDelta = event.scrollDelta.dx;
    if (horizontalDelta == AppSpacing.none) {
      return;
    }

    final int currentPage = pageController.page?.round() ?? previewIndex;
    if (horizontalDelta > AppSpacing.none) {
      final int nextPage = (currentPage + 1).clamp(0, dotCount - 1);
      if (nextPage == currentPage) {
        return;
      }
      pageController.animateToPage(
        nextPage,
        duration: MotionDurations.animationFast,
        curve: Curves.easeOutCubic,
      );
      return;
    }

    final int previousPage = (currentPage - 1).clamp(0, dotCount - 1);
    if (previousPage == currentPage) {
      return;
    }
    pageController.animateToPage(
      previousPage,
      duration: MotionDurations.animationFast,
      curve: Curves.easeOutCubic,
    );
  }

  bool _isHorizontalScroll(PointerScrollEvent event) {
    final double horizontalDelta = event.scrollDelta.dx.abs();
    final double verticalDelta = event.scrollDelta.dy.abs();
    if (horizontalDelta <
        FlashcardPreviewCarouselConst.horizontalScrollActivationOffset) {
      return false;
    }
    if (horizontalDelta <= verticalDelta) {
      return false;
    }
    return true;
  }
}
