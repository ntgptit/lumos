import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'flashcard_learn_option_card.dart';

enum FlashcardLearnOptionsSheetAction { firstLearning, review, resetProgress }

abstract final class FlashcardLearnOptionsSheetConst {
  FlashcardLearnOptionsSheetConst._();

  static const double sectionSpacing =
      24;
  static const double optionSpacing =
      16;
  static const double iconContainerSize =
      48;
  static const double iconSize =
      18;
}

class _LearnOptionItem {
  const _LearnOptionItem({
    required this.action,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final FlashcardLearnOptionsSheetAction action;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}

Future<FlashcardLearnOptionsSheetAction?> showFlashcardLearnOptionsSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<FlashcardLearnOptionsSheetAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.theme.colorScheme.surface.withValues(alpha: AppOpacity.transparent),
    builder: (BuildContext sheetContext) {
      final double sectionSpacing = sheetContext.compactValue(
        baseValue: FlashcardLearnOptionsSheetConst.sectionSpacing,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double optionSpacing = sheetContext.compactValue(
        baseValue: FlashcardLearnOptionsSheetConst.optionSpacing,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double iconContainerSize = sheetContext.compactValue(
        baseValue: FlashcardLearnOptionsSheetConst.iconContainerSize,
        minScale: ResponsiveDimensions.compactLargeInsetScale,
      );
      final double iconSize = sheetContext.compactValue(
        baseValue: FlashcardLearnOptionsSheetConst.iconSize,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double rowGap = sheetContext.compactValue(
        baseValue:
            context.spacing.md,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double cardPadding = sheetContext.compactValue(
        baseValue:
            context.spacing.md,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final double subtitleGap = sheetContext.compactValue(
        baseValue:
            context.spacing.xs,
        minScale: ResponsiveDimensions.compactInsetScale,
      );
      final AppLocalizations l10n = AppLocalizations.of(sheetContext)!;
      final ColorScheme colorScheme = sheetContext.colorScheme;
      final List<_LearnOptionItem> options = <_LearnOptionItem>[
        _LearnOptionItem(
          action: FlashcardLearnOptionsSheetAction.firstLearning,
          title: l10n.flashcardLearnContinueOptionTitle,
          subtitle: l10n.flashcardLearnContinueOptionSubtitle,
          icon: Icons.school_rounded,
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
        ),
        _LearnOptionItem(
          action: FlashcardLearnOptionsSheetAction.review,
          title: l10n.flashcardLearnReviewOptionTitle,
          subtitle: l10n.flashcardLearnReviewOptionSubtitle,
          icon: Icons.schedule_rounded,
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
        ),
        _LearnOptionItem(
          action: FlashcardLearnOptionsSheetAction.resetProgress,
          title: l10n.flashcardLearnResetOptionTitle,
          subtitle: l10n.flashcardLearnResetOptionSubtitle,
          icon: Icons.restart_alt_rounded,
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
        ),
      ];
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
              LumosText(
                l10n.flashcardLearnSheetSubtitle,
                style: LumosTextStyle.bodySmall,
              ),
              SizedBox(height: sectionSpacing),
              for (final _LearnOptionItem option in options) ...<Widget>[
                FlashcardLearnOptionCard(
                  title: option.title,
                  subtitle: option.subtitle,
                  icon: option.icon,
                  iconContainerSize: iconContainerSize,
                  iconSize: iconSize,
                  rowGap: rowGap,
                  cardPadding: cardPadding,
                  subtitleGap: subtitleGap,
                  backgroundColor: option.backgroundColor,
                  foregroundColor: option.foregroundColor,
                  onTap: () => sheetContext.pop(option.action),
                ),
                if (option != options.last) SizedBox(height: optionSpacing),
              ],
            ],
          ),
        ),
      );
    },
  );
}
