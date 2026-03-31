import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

abstract final class FlashcardStudyActionSectionConst {
  FlashcardStudyActionSectionConst._();

  static const double gridSpacing =
      12;
  static const double compactWidthBreakpoint = 380;
  static const double cardMinHeight = 72;
  static const double iconContainerSize =
      32;
  static const double iconSize =
      18;
  static const double labelLeftSpacing =
      8;
  static const double cardVerticalPadding =
      12;
  static const double cardHorizontalPadding =
      16;
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
      return SizedBox.shrink();
    }
    final double gridSpacing = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.gridSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardMinHeight = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.cardMinHeight,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconContainerSize = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.iconContainerSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double iconSize = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.iconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double labelLeftSpacing = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.labelLeftSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardVerticalPadding = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.cardVerticalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double cardHorizontalPadding = context.compactValue(
      baseValue: FlashcardStudyActionSectionConst.cardHorizontalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactWidth = constraints.maxWidth <
            FlashcardStudyActionSectionConst.compactWidthBreakpoint;
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
                borderRadius: context.shapes.card,
                onTap: action.onPressed,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: context.shapes.card,
                      ),
                      child: IconTheme(
                        data: IconThemeData(color: iconColor, size: iconSize),
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
                            ? context.theme
                                  .textTheme
                                  .titleSmall
                            : context.theme
                                  .textTheme
                                  .titleMedium,
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
  final ColorScheme colorScheme = context.theme.colorScheme;
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
  final ColorScheme colorScheme = context.theme.colorScheme;
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
