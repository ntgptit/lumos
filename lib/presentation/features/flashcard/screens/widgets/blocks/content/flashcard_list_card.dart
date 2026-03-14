import 'package:flutter/material.dart';

import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardListCardConst {
  FlashcardListCardConst._();

  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(
    AppSpacing.lg,
    AppSpacing.md,
    AppSpacing.md,
    AppSpacing.md,
  );
  static const double textGap = AppSpacing.xs;
  static const double iconSpacing = AppSpacing.xs;
  static const double actionIconSize = IconSizes.iconMedium - AppSpacing.xs;
  static const VisualDensity actionVisualDensity = VisualDensity.compact;
  static const double frontTextFontSize =
      AppTypographyConst.titleMediumFontSize + AppSpacing.xxs;
  static const double frontTextHeight =
      AppTypographyConst.titleMediumLineHeight / frontTextFontSize;
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
    final ThemeData theme = Theme.of(context);
    final String normalizedNote = StringUtils.normalizeName(item.note);
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: FlashcardListCardConst.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: LumosInlineText(
                    item.frontText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: FlashcardListCardConst.frontTextFontSize,
                      height: FlashcardListCardConst.frontTextHeight,
                      letterSpacing:
                          AppTypographyConst.titleMediumLetterSpacing,
                      fontWeight: AppTypographyConst.kFontWeightSemiBold,
                    ),
                  ),
                ),
                const SizedBox(width: FlashcardListCardConst.iconSpacing),
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
                        size: FlashcardListCardConst.actionIconSize,
                        selected: isAudioPlaying,
                        selectedIcon: Icons.graphic_eq_rounded,
                      ),
                      LumosIconButton(
                        onPressed: onStarPressed,
                        tooltip: l10n.flashcardBookmarkTooltip,
                        icon: Icons.star_border,
                        size: FlashcardListCardConst.actionIconSize,
                        selected: isStarred,
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
                        icon: const LumosIcon(
                          Icons.more_vert_rounded,
                          size: FlashcardListCardConst.actionIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: FlashcardListCardConst.textGap),
            LumosInlineText(
              item.backText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: FlashcardListCardConst.backTextMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (normalizedNote.isNotEmpty) ...<Widget>[
              const SizedBox(height: FlashcardListCardConst.textGap),
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
