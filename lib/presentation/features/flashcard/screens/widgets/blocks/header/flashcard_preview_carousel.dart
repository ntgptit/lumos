import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

abstract final class FlashcardPreviewCarouselConst {
  FlashcardPreviewCarouselConst._();

  static const double carouselHeight =
      24 * 6;
  static const double pageSpacing =
      8;
  static const double dotSpacing =
      8;
  static const double activeDotScale = 1.7;
  static const double dotSize =
      12;
  static const double titleHorizontalPadding =
      32;
  static const double titleVerticalPadding =
      24;
  static const double expandButtonInset =
      12;
  static const double expandIconSize =
      32;
  static const double horizontalScrollActivationOffset =
      8;
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
    final double carouselHeight = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.carouselHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double titleHorizontalPadding = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.titleHorizontalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double titleVerticalPadding = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.titleVerticalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double expandButtonInset = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.expandButtonInset,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double expandIconSize = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.expandIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double indicatorGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dotSpacing = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.dotSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dotSize = context.compactValue(
      baseValue: FlashcardPreviewCarouselConst.dotSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final int dotCount = _dotCount();
    final int safePreviewIndex = _safePreviewIndex(dotCount: dotCount);
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: carouselHeight,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: FlashcardPreviewCarouselConst.pageSpacing,
                      ),
                      child: LumosCard(
                        variant: LumosCardVariant.filled,
                        borderRadius: context.shapes.hero,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: titleHorizontalPadding,
                                  vertical: titleVerticalPadding,
                                ),
                                child: LumosInlineText(
                                  title,
                                  align: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.theme
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Positioned(
                              right: expandButtonInset,
                              bottom: expandButtonInset,
                              child: LumosIconButton(
                                onPressed: () => onExpandPressed(index),
                                tooltip: l10n.flashcardExpandPreviewTooltip,
                                icon: Icons.fullscreen_rounded,
                                size: expandIconSize,
                                variant: AppIconButtonVariant.tonal,
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
          SizedBox(height: indicatorGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(dotCount, (int index) {
              final bool isActive = index == safePreviewIndex;
              final ColorScheme colorScheme = context.theme.colorScheme;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: dotSpacing),
                child: SizedBox(
                  width: dotSize * FlashcardPreviewCarouselConst.activeDotScale,
                  height:
                      dotSize * FlashcardPreviewCarouselConst.activeDotScale,
                  child: Center(
                    child: AnimatedScale(
                      duration: AppMotion.fast,
                      scale: isActive
                          ? FlashcardPreviewCarouselConst.activeDotScale
                          : WidgetRatios.full,
                      child: Container(
                        width: dotSize,
                        height: dotSize,
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
    if (horizontalDelta == 0) {
     
      return;
    }

    final int currentPage = pageController.page?.round() ?? previewIndex;
    if (horizontalDelta > 0) {
     
      final int nextPage = (currentPage + 1).clamp(0, dotCount - 1);
      if (nextPage == currentPage) {
        return;
      }
      pageController.animateToPage(
        nextPage,
        duration: AppMotion.fast,
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
      duration: AppMotion.fast,
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
