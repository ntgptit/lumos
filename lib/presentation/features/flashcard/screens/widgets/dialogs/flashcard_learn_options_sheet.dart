import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

enum FlashcardLearnOptionsSheetAction { firstLearning, review, resetProgress }

abstract final class FlashcardLearnOptionsSheetConst {
  FlashcardLearnOptionsSheetConst._();

  static const double sectionSpacing = AppSpacing.lg;
  static const double optionSpacing = AppSpacing.md;
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
              const SizedBox(
                height: FlashcardLearnOptionsSheetConst.optionSpacing,
              ),
              LumosInlineText(
                l10n.flashcardLearnSheetSubtitle,
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: FlashcardLearnOptionsSheetConst.sectionSpacing,
              ),
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
                      width: FlashcardLearnOptionsSheetConst.iconContainerSize,
                      height: FlashcardLearnOptionsSheetConst.iconContainerSize,
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
                          size: FlashcardLearnOptionsSheetConst.iconSize,
                        ),
                        child: const LumosIcon(Icons.school_rounded),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosInlineText(
                            l10n.flashcardLearnContinueOptionTitle,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
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
              const SizedBox(
                height: FlashcardLearnOptionsSheetConst.optionSpacing,
              ),
              LumosCard(
                variant: LumosCardVariant.elevated,
                onTap: () {
                  sheetContext.pop(FlashcardLearnOptionsSheetAction.review);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: FlashcardLearnOptionsSheetConst.iconContainerSize,
                      height: FlashcardLearnOptionsSheetConst.iconContainerSize,
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
                          size: FlashcardLearnOptionsSheetConst.iconSize,
                        ),
                        child: const LumosIcon(Icons.schedule_rounded),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosInlineText(
                            l10n.flashcardLearnReviewOptionTitle,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
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
              const SizedBox(
                height: FlashcardLearnOptionsSheetConst.optionSpacing,
              ),
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
                      width: FlashcardLearnOptionsSheetConst.iconContainerSize,
                      height: FlashcardLearnOptionsSheetConst.iconContainerSize,
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
                          size: FlashcardLearnOptionsSheetConst.iconSize,
                        ),
                        child: const LumosIcon(Icons.restart_alt_rounded),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosInlineText(
                            l10n.flashcardLearnResetOptionTitle,
                            style: Theme.of(sheetContext).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
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
