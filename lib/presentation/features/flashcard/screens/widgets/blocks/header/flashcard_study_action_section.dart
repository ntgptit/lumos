import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

abstract final class FlashcardStudyActionSectionConst {
  FlashcardStudyActionSectionConst._();

  static const double gridSpacing = LumosSpacing.sm;
  static const double cardMinHeight = 72;
  static const double iconContainerSize = LumosSpacing.xl;
  static const double iconSize = IconSizes.iconSmall;
  static const double labelLeftSpacing = LumosSpacing.xs;
  static const double cardVerticalPadding = LumosSpacing.sm;
  static const double cardHorizontalPadding = LumosSpacing.md;
  static const int gridCrossAxisCount = 2;
}

enum FlashcardStudyActionSectionTone {
  primary,
  info,
  warning,
  success,
  neutral,
}

class FlashcardStudyActionSectionItem {
  const FlashcardStudyActionSectionItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tone = FlashcardStudyActionSectionTone.neutral,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final FlashcardStudyActionSectionTone tone;
}

class FlashcardStudyActionSection extends StatelessWidget {
  const FlashcardStudyActionSection({required this.actions, super.key});

  final List<FlashcardStudyActionSectionItem> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    final double gridSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.gridSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardMinHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.cardMinHeight,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconContainerSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.iconContainerSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double iconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.iconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double labelLeftSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.labelLeftSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.cardVerticalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.cardHorizontalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactWidth = constraints.maxWidth < 380;
        final double availableWidth = constraints.maxWidth;
        final int crossAxisCount =
            FlashcardStudyActionSectionConst.gridCrossAxisCount;
        final bool hasTrailingOddAction = actions.length.isOdd;
        final double halfWidth =
            (availableWidth - (gridSpacing * (crossAxisCount - 1))) /
            crossAxisCount;
        return Wrap(
          spacing: gridSpacing,
          runSpacing: gridSpacing,
          children: List<Widget>.generate(actions.length, (int index) {
            final FlashcardStudyActionSectionItem action = actions[index];
            final Color containerColor = _resolveFlashcardActionContainerColor(
              context: context,
              tone: action.tone,
            );
            final Color iconColor = _resolveFlashcardActionIconColor(
              context: context,
              tone: action.tone,
            );
            final bool spansFullWidth =
                hasTrailingOddAction && index == actions.length - 1;
            return SizedBox(
              width: spansFullWidth ? availableWidth : halfWidth,
              child: LumosCard(
                minHeight: cardMinHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: cardHorizontalPadding,
                  vertical: cardVerticalPadding,
                ),
                variant: LumosCardVariant.outlined,
                borderRadius: BorderRadii.medium,
                onTap: action.onPressed,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadii.medium,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: iconColor,
                          size: iconSize,
                        ),
                        child: LumosIcon(action.icon),
                      ),
                    ),
                    SizedBox(width: labelLeftSpacing),
                    Expanded(
                      child: LumosInlineText(
                        action.label,
                        maxLines: compactWidth ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: compactWidth
                            ? Theme.of(context).textTheme.titleSmall
                            : Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

Color _resolveFlashcardActionContainerColor({
  required BuildContext context,
  required FlashcardStudyActionSectionTone tone,
}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  if (tone == FlashcardStudyActionSectionTone.primary) {
    return colorScheme.primaryContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.info) {
    return context.appColors.infoContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.warning) {
    return context.appColors.warningContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.success) {
    return context.appColors.successContainer;
  }
  return colorScheme.secondaryContainer;
}

Color _resolveFlashcardActionIconColor({
  required BuildContext context,
  required FlashcardStudyActionSectionTone tone,
}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  if (tone == FlashcardStudyActionSectionTone.primary) {
    return colorScheme.onPrimaryContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.info) {
    return context.appColors.onInfoContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.warning) {
    return context.appColors.onWarningContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.success) {
    return context.appColors.onSuccessContainer;
  }
  return colorScheme.onSecondaryContainer;
}

