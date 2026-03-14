import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardStudyCardConst {
  FlashcardStudyCardConst._();

  static const double contentHorizontalPadding = AppSpacing.lg;
  static const double contentVerticalPadding = AppSpacing.lg;
  static const double actionIconSize = AppSpacing.xl;
  static const double hintIconSize = AppSpacing.xl;
  static const double titleGap = AppSpacing.sm;
  static const double bottomGap = AppSpacing.sm;
  static const int backTextMaxLines = 8;
  static const int noteMaxLines = 4;
}

class FlashcardStudyCard extends StatelessWidget {
  const FlashcardStudyCard({
    required this.item,
    required this.isFlipped,
    required this.isStarred,
    required this.isAudioPlaying,
    required this.onFlipPressed,
    required this.onAudioPressed,
    required this.onStarPressed,
    super.key,
  });

  final FlashcardNode item;
  final bool isFlipped;
  final bool isStarred;
  final bool isAudioPlaying;
  final VoidCallback onFlipPressed;
  final VoidCallback onAudioPressed;
  final VoidCallback onStarPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String normalizedNote = StringUtils.normalizeName(item.note);
    final bool hasNote = normalizedNote.isNotEmpty;
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      onTap: onFlipPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FlashcardStudyCardConst.contentHorizontalPadding,
          vertical: FlashcardStudyCardConst.contentVerticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                LumosIconButton(
                  onPressed: onAudioPressed,
                  tooltip: l10n.flashcardPlayAudioTooltip,
                  icon: Icons.volume_up_outlined,
                  size: FlashcardStudyCardConst.actionIconSize,
                  selected: isAudioPlaying,
                  selectedIcon: Icons.graphic_eq_rounded,
                ),
                const Spacer(),
                LumosIconButton(
                  onPressed: onStarPressed,
                  tooltip: l10n.flashcardBookmarkTooltip,
                  icon: Icons.star_border,
                  size: FlashcardStudyCardConst.actionIconSize,
                  selected: isStarred,
                  selectedIcon: Icons.star,
                ),
              ],
            ),
            const SizedBox(height: FlashcardStudyCardConst.titleGap),
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppDurations.medium,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  child: isFlipped
                      ? Column(
                          key: const ValueKey<String>('flashcard-back'),
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            LumosInlineText(
                              item.backText,
                              align: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                              maxLines:
                                  FlashcardStudyCardConst.backTextMaxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasNote)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: FlashcardStudyCardConst.titleGap,
                                ),
                                child: LumosInlineText(
                                  normalizedNote,
                                  align: TextAlign.center,
                                  style: theme.textTheme.bodyMedium,
                                  maxLines:
                                      FlashcardStudyCardConst.noteMaxLines,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        )
                      : LumosInlineText(
                          item.frontText,
                          key: const ValueKey<String>('flashcard-front'),
                          align: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                          maxLines: FlashcardStudyCardConst.backTextMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ),
            const SizedBox(height: FlashcardStudyCardConst.bottomGap),
            Center(
              child: const LumosIcon(
                Icons.flip_to_back_rounded,
                size: FlashcardStudyCardConst.hintIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
