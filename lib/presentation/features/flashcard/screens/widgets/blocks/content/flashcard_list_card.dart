import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

abstract final class FlashcardListCardConst {
  FlashcardListCardConst._();

  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(
    24,
    16,
    16,
    16,
  );
  static const double textGap =
      8;
  static const double iconSpacing =
      8;
  static const double actionIconSize =
      24 -
      8;
  static const VisualDensity actionVisualDensity = VisualDensity.compact;
  static const int backTextMaxLines = 4;
  static const int noteMaxLines = 3;
  static const String actionEdit = 'action-edit';
  static const String actionDelete = 'action-delete';
}

class FlashcardListCard extends StatelessWidget {
  const FlashcardListCard({
    required this.item,
    required this.isStarred,
    required this.isAudioPlaying,
    required this.onAudioPressed,
    required this.onStarPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final FlashcardNode item;
  final bool isStarred;
  final bool isAudioPlaying;
  final VoidCallback onAudioPressed;
  final VoidCallback onStarPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = context.theme;
    final TextStyle frontTextStyle =
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontWeight: FontWeight.w600);
    final String normalizedNote = StringUtils.normalizeText(item.note);
    final EdgeInsets cardPadding = context.compactInsets(
      baseInsets: FlashcardListCardConst.cardPadding,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double textGap = context.compactValue(
      baseValue: FlashcardListCardConst.textGap,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconSpacing = context.compactValue(
      baseValue: FlashcardListCardConst.iconSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionIconSize = context.compactValue(
      baseValue: FlashcardListCardConst.actionIconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: context.shapes.hero,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: LumosInlineText(item.frontText, style: frontTextStyle),
                ),
                SizedBox(width: iconSpacing),
                Theme(
                  data: theme.copyWith(
                    visualDensity: FlashcardListCardConst.actionVisualDensity,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LumosIconButton(
                        onPressed: onAudioPressed,
                        tooltip: l10n.flashcardPlayAudioTooltip,
                        icon: Icons.volume_up_outlined,
                        size: actionIconSize,
                        isSelected: isAudioPlaying,
                        selectedIcon: Icons.graphic_eq_rounded,
                      ),
                      LumosIconButton(
                        onPressed: onStarPressed,
                        tooltip: l10n.flashcardBookmarkTooltip,
                        icon: Icons.star_border,
                        size: actionIconSize,
                        isSelected: isStarred,
                        selectedIcon: Icons.star,
                      ),
                      LumosPopupMenuButton<String>(
                        tooltip: l10n.flashcardMoreButtonTooltip,
                        onSelected: (String value) {
                          if (value == FlashcardListCardConst.actionEdit) {
                            onEditPressed();
                            return;
                          }
                          onDeletePressed();
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: FlashcardListCardConst.actionEdit,
                              child: LumosInlineText(l10n.flashcardEditTooltip),
                            ),
                            PopupMenuItem<String>(
                              value: FlashcardListCardConst.actionDelete,
                              child: LumosInlineText(
                                l10n.flashcardDeleteTooltip,
                              ),
                            ),
                          ];
                        },
                        icon: LumosIcon(
                          Icons.more_vert_rounded,
                          size: actionIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: textGap),
            LumosInlineText(
              item.backText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: FlashcardListCardConst.backTextMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (normalizedNote.isNotEmpty) ...<Widget>[
              SizedBox(height: textGap),
              LumosInlineText(
                normalizedNote,
                style: theme.textTheme.bodySmall,
                maxLines: FlashcardListCardConst.noteMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
