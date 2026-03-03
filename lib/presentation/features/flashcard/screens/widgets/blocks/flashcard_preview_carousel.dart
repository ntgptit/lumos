import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardPreviewCarouselConst {
  FlashcardPreviewCarouselConst._();

  static const double carouselHeight = 200;
  static const double pageSpacing = Insets.spacing8;
  static const double dotSpacing = Insets.spacing4;
  static const double activeDotScale = 1.6;
  static const double dotSize = Insets.spacing8;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: FlashcardPreviewCarouselConst.carouselHeight,
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
                child: GestureDetector(
                  onTap: () => onExpandPressed(index),
                  child: LumosCard(
                    variant: LumosCardVariant.elevated,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(Insets.spacing16),
                            child: LumosInlineText(
                              title,
                              align: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        Positioned(
                          right: Insets.spacing8,
                          bottom: Insets.spacing8,
                          child: LumosIconButton(
                            onPressed: () => onExpandPressed(index),
                            tooltip: l10n.flashcardExpandPreviewTooltip,
                            icon: Icons.fullscreen_rounded,
                            variant: LumosIconButtonVariant.tonal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: Insets.spacing8),
        _buildIndicator(
          context: context,
          dotCount: dotCount,
          safePreviewIndex: safePreviewIndex,
        ),
      ],
    );
  }

  Widget _buildIndicator({
    required BuildContext context,
    required int dotCount,
    required int safePreviewIndex,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(dotCount, (int index) {
        final bool isActive = index == safePreviewIndex;
        final double size = isActive
            ? FlashcardPreviewCarouselConst.dotSize *
                  FlashcardPreviewCarouselConst.activeDotScale
            : FlashcardPreviewCarouselConst.dotSize;
        return AnimatedContainer(
          duration: MotionDurations.animationFast,
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(
            horizontal: FlashcardPreviewCarouselConst.dotSpacing,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        );
      }),
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
}
