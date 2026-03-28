import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardPreviewCarouselConst {
  FlashcardPreviewCarouselConst._();

  static const double carouselHeight = LumosSpacing.section * 6;
  static const double pageSpacing = LumosSpacing.xs;
  static const double dotSpacing = LumosSpacing.xs;
  static const double activeDotScale = 1.7;
  static const double dotSize = LumosSpacing.sm;
  static const double titleHorizontalPadding = LumosSpacing.xl;
  static const double titleVerticalPadding = LumosSpacing.lg;
  static const double expandButtonInset = LumosSpacing.sm;
  static const double expandIconSize = LumosSpacing.xl;
  static const double frontTextFontSize = AppTypographyConst.titleLargeFontSize;
  static const double frontTextHeight =
      AppTypographyConst.titleLargeLineHeight / frontTextFontSize;
  static const double horizontalScrollActivationOffset = LumosSpacing.xs;
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
    final double carouselHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.carouselHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double titleHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.titleHorizontalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double titleVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.titleVerticalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double expandButtonInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.expandButtonInset,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double expandIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.expandIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double frontTextFontSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.frontTextFontSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double indicatorGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dotSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardPreviewCarouselConst.dotSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dotSize = ResponsiveDimensions.compactValue(
      context: context,
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: titleHorizontalPadding,
                                  vertical: titleVerticalPadding,
                                ),
                                child: LumosInlineText(
                                  title,
                                  align: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontSize: frontTextFontSize,
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
                              right: expandButtonInset,
                              bottom: expandButtonInset,
                              child: LumosIconButton(
                                onPressed: () => onExpandPressed(index),
                                tooltip: l10n.flashcardExpandPreviewTooltip,
                                icon: Icons.fullscreen_rounded,
                                size: expandIconSize,
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
          SizedBox(height: indicatorGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(dotCount, (int index) {
              final bool isActive = index == safePreviewIndex;
              final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
    if (horizontalDelta == LumosSpacing.none) {
      return;
    }

    final int currentPage = pageController.page?.round() ?? previewIndex;
    if (horizontalDelta > LumosSpacing.none) {
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
