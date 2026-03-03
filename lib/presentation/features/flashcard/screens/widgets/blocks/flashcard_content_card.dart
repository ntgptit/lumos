import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardContentCardConst {
  FlashcardContentCardConst._();

  static const double cardPadding = Insets.spacing16;
  static const double textGap = Insets.spacing8;
  static const double iconSpacing = Insets.spacing4;
  static const double actionIconSize = Insets.spacing20;
  static const int backTextMaxLines = 6;
  static const int noteMaxLines = 4;
  static const double cardRadius = Insets.spacing16;
  static const String actionEdit = 'action-edit';
  static const String actionDelete = 'action-delete';
}

class FlashcardContentCard extends StatelessWidget {
  const FlashcardContentCard({
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
    return LumosCard(
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadius.circular(FlashcardContentCardConst.cardRadius),
      child: Padding(
        padding: const EdgeInsets.all(FlashcardContentCardConst.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: LumosInlineText(
                    item.frontText,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: FlashcardContentCardConst.iconSpacing),
                LumosIconButton(
                  onPressed: onAudioPressed,
                  tooltip: l10n.flashcardPlayAudioTooltip,
                  icon: Icons.volume_up_outlined,
                  size: FlashcardContentCardConst.actionIconSize,
                  selected: isAudioPlaying,
                  selectedIcon: Icons.graphic_eq_rounded,
                ),
                LumosIconButton(
                  onPressed: onStarPressed,
                  tooltip: l10n.flashcardBookmarkTooltip,
                  icon: Icons.star_border,
                  size: FlashcardContentCardConst.actionIconSize,
                  selected: isStarred,
                  selectedIcon: Icons.star,
                ),
                PopupMenuButton<String>(
                  tooltip: l10n.flashcardMoreButtonTooltip,
                  onSelected: (String value) {
                    if (value == FlashcardContentCardConst.actionEdit) {
                      onEditPressed();
                      return;
                    }
                    onDeletePressed();
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: FlashcardContentCardConst.actionEdit,
                        child: LumosInlineText(l10n.flashcardEditTooltip),
                      ),
                      PopupMenuItem<String>(
                        value: FlashcardContentCardConst.actionDelete,
                        child: LumosInlineText(l10n.flashcardDeleteTooltip),
                      ),
                    ];
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(Insets.spacing8),
                    child: LumosIcon(
                      Icons.more_vert_rounded,
                      size: FlashcardContentCardConst.actionIconSize,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: FlashcardContentCardConst.textGap),
            LumosInlineText(
              item.backText,
              style: theme.textTheme.bodyMedium,
              maxLines: FlashcardContentCardConst.backTextMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            ..._buildNote(context: context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNote({required BuildContext context}) {
    final String normalizedNote = StringUtils.normalizeName(item.note);
    if (normalizedNote.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: FlashcardContentCardConst.textGap),
      LumosInlineText(
        normalizedNote,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: FlashcardContentCardConst.noteMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }
}
