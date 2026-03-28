import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';

enum FlashcardLearnOptionsSheetAction { firstLearning, review, resetProgress }

abstract final class FlashcardLearnOptionsSheetConst {
  FlashcardLearnOptionsSheetConst._();

  static const double sectionSpacing = LumosSpacing.lg;
  static const double optionSpacing = LumosSpacing.md;
  static const double iconContainerSize = WidgetSizes.avatarMedium;
  static const double iconSize = IconSizes.iconSmall;
}

Future<FlashcardLearnOptionsSheetAction?> showFlashcardLearnOptionsSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<FlashcardLearnOptionsSheetAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(
      context,
    ).colorScheme.surface.withValues(alpha: AppOpacity.transparent),
    builder: (BuildContext sheetContext) {
      final double sectionSpacing = ResponsiveDimensions.compactValue(
        context: sheetContext,
        baseValue: FlashcardLearnOptionsSheetConst.sectionSpacing,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double optionSpacing = ResponsiveDimensions.compactValue(
        context: sheetContext,
        baseValue: FlashcardLearnOptionsSheetConst.optionSpacing,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double iconContainerSize = ResponsiveDimensions.compactValue(
        context: sheetContext,
        baseValue: FlashcardLearnOptionsSheetConst.iconContainerSize,
        minScale: ResponsiveDimensions.compactLargeInsetScale,
      );
      final double iconSize = ResponsiveDimensions.compactValue(
        context: sheetContext,
        baseValue: FlashcardLearnOptionsSheetConst.iconSize,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double rowGap = ResponsiveDimensions.compactValue(
        context: sheetContext,
        baseValue: LumosSpacing.md,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double subtitleGap = ResponsiveDimensions.compactValue(
        context: sheetContext,
        baseValue: LumosSpacing.xs,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final AppLocalizations l10n = AppLocalizations.of(sheetContext)!;
      return LumosBottomSheet(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosText(
                l10n.flashcardLearnSheetTitle,
                style: LumosTextStyle.titleLarge,
              ),
              SizedBox(height: optionSpacing),
              LumosInlineText(
                l10n.flashcardLearnSheetSubtitle,
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              SizedBox(height: sectionSpacing),
              LumosCard(
                variant: LumosCardVariant.elevated,
                onTap: () {
                  sheetContext.pop(
                    FlashcardLearnOptionsSheetAction.firstLearning,
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          sheetContext,
                        ).colorScheme.secondaryContainer,
                        borderRadius: BorderRadii.medium,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: Theme.of(
                            sheetContext,
                          ).colorScheme.onSecondaryContainer,
                          size: iconSize,
                        ),
                        child: const LumosIcon(Icons.school_rounded),
                      ),
                    ),
                    SizedBox(width: rowGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosInlineText(
                            l10n.flashcardLearnContinueOptionTitle,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                          SizedBox(height: subtitleGap),
                          LumosInlineText(
                            l10n.flashcardLearnContinueOptionSubtitle,
                            style: Theme.of(sheetContext).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: optionSpacing),
              LumosCard(
                variant: LumosCardVariant.elevated,
                onTap: () {
                  sheetContext.pop(FlashcardLearnOptionsSheetAction.review);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          sheetContext,
                        ).colorScheme.secondaryContainer,
                        borderRadius: BorderRadii.medium,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: Theme.of(
                            sheetContext,
                          ).colorScheme.onSecondaryContainer,
                          size: iconSize,
                        ),
                        child: const LumosIcon(Icons.schedule_rounded),
                      ),
                    ),
                    SizedBox(width: rowGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosInlineText(
                            l10n.flashcardLearnReviewOptionTitle,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                          SizedBox(height: subtitleGap),
                          LumosInlineText(
                            l10n.flashcardLearnReviewOptionSubtitle,
                            style: Theme.of(sheetContext).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: optionSpacing),
              LumosCard(
                variant: LumosCardVariant.elevated,
                onTap: () {
                  sheetContext.pop(
                    FlashcardLearnOptionsSheetAction.resetProgress,
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          sheetContext,
                        ).colorScheme.errorContainer,
                        borderRadius: BorderRadii.medium,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: Theme.of(
                            sheetContext,
                          ).colorScheme.onErrorContainer,
                          size: iconSize,
                        ),
                        child: const LumosIcon(Icons.restart_alt_rounded),
                      ),
                    ),
                    SizedBox(width: rowGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosInlineText(
                            l10n.flashcardLearnResetOptionTitle,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                          SizedBox(height: subtitleGap),
                          LumosInlineText(
                            l10n.flashcardLearnResetOptionSubtitle,
                            style: Theme.of(sheetContext).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

