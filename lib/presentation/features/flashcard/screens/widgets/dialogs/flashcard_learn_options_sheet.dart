import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

enum FlashcardLearnSheetAction { firstLearning, review, resetProgress }

abstract final class FlashcardLearnOptionsSheetConst {
  FlashcardLearnOptionsSheetConst._();

  static const double sectionSpacing = AppSpacing.lg;
  static const double optionSpacing = AppSpacing.md;
  static const double iconContainerSize = WidgetSizes.avatarMedium;
  static const double iconSize = IconSizes.iconSmall;
}

Future<FlashcardLearnSheetAction?> showFlashcardLearnOptionsSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<FlashcardLearnSheetAction>(
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
              _FlashcardLearnOptionTile(
                icon: Icons.school_rounded,
                title: l10n.flashcardLearnContinueOptionTitle,
                subtitle: l10n.flashcardLearnContinueOptionSubtitle,
                onTap: () {
                  sheetContext.pop(FlashcardLearnSheetAction.firstLearning);
                },
              ),
              const SizedBox(
                height: FlashcardLearnOptionsSheetConst.optionSpacing,
              ),
              _FlashcardLearnOptionTile(
                icon: Icons.schedule_rounded,
                title: l10n.flashcardLearnReviewOptionTitle,
                subtitle: l10n.flashcardLearnReviewOptionSubtitle,
                onTap: () {
                  sheetContext.pop(FlashcardLearnSheetAction.review);
                },
              ),
              const SizedBox(
                height: FlashcardLearnOptionsSheetConst.optionSpacing,
              ),
              _FlashcardLearnOptionTile(
                icon: Icons.restart_alt_rounded,
                title: l10n.flashcardLearnResetOptionTitle,
                subtitle: l10n.flashcardLearnResetOptionSubtitle,
                isDestructive: true,
                onTap: () {
                  sheetContext.pop(FlashcardLearnSheetAction.resetProgress);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _FlashcardLearnOptionTile extends StatelessWidget {
  const _FlashcardLearnOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color containerColor = isDestructive
        ? colorScheme.errorContainer
        : colorScheme.secondaryContainer;
    final Color iconColor = isDestructive
        ? colorScheme.onErrorContainer
        : colorScheme.onSecondaryContainer;
    return LumosCard(
      variant: LumosCardVariant.elevated,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: FlashcardLearnOptionsSheetConst.iconContainerSize,
            height: FlashcardLearnOptionsSheetConst.iconContainerSize,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadii.medium,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: iconColor,
                size: FlashcardLearnOptionsSheetConst.iconSize,
              ),
              child: LumosIcon(icon),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosInlineText(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                LumosInlineText(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
