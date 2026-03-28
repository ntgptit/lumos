import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';

abstract final class FlashcardStudyCardConst {
  FlashcardStudyCardConst._();

  static const double contentHorizontalPadding = LumosSpacing.lg;
  static const double contentVerticalPadding = LumosSpacing.lg;
  static const double actionIconSize = LumosSpacing.xl;
  static const double hintIconSize = LumosSpacing.xl;
  static const double titleGap = LumosSpacing.sm;
  static const double bottomGap = LumosSpacing.sm;
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
    final String normalizedNote = StringUtils.normalizeText(item.note);
    final bool hasNote = normalizedNote.isNotEmpty;
    final double contentHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.contentHorizontalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double contentVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.contentVerticalPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double actionIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.actionIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.titleGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double bottomGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.bottomGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double hintIconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyCardConst.hintIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      onTap: onFlipPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: contentHorizontalPadding,
          vertical: contentVerticalPadding,
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
                  size: actionIconSize,
                  selected: isAudioPlaying,
                  selectedIcon: Icons.graphic_eq_rounded,
                ),
                const Spacer(),
                LumosIconButton(
                  onPressed: onStarPressed,
                  tooltip: l10n.flashcardBookmarkTooltip,
                  icon: Icons.star_border,
                  size: actionIconSize,
                  selected: isStarred,
                  selectedIcon: Icons.star,
                ),
              ],
            ),
            SizedBox(height: titleGap),
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
                                padding: EdgeInsets.only(top: titleGap),
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
            SizedBox(height: bottomGap),
            Center(
              child: LumosIcon(Icons.flip_to_back_rounded, size: hintIconSize),
            ),
          ],
        ),
      ),
    );
  }
}

