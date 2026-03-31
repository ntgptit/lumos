import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'flashcard_learn_option_card.dart';

enum FlashcardLearnOptionsSheetAction { firstLearning, review, resetProgress }

abstract final class FlashcardLearnOptionsSheetConst {
  FlashcardLearnOptionsSheetConst._();

  static const double sectionSpacing = LumosSpacing.lg;
  static const double optionSpacing = LumosSpacing.md;
  static const double iconContainerSize = WidgetSizes.avatarMedium;
  static const double iconSize = IconSizes.iconSmall;
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
      final double cardPadding = ResponsiveDimensions.compactValue(
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
