import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardContentCardConst {
  FlashcardContentCardConst._();

  static const double cardPadding = Insets.spacing16;
  static const double textGap = Insets.spacing8;
  static const int backTextMaxLines = 3;
  static const int noteMaxLines = 2;
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
    return LumosCard(
      variant: LumosCardVariant.elevated,
      child: Padding(
        padding: const EdgeInsets.all(FlashcardContentCardConst.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosInlineText(
              item.frontText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: FlashcardContentCardConst.textGap),
            LumosInlineText(
              item.backText,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: FlashcardContentCardConst.backTextMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            ..._buildNote(context: context),
            const SizedBox(height: FlashcardContentCardConst.textGap),
            Wrap(
              spacing: Insets.spacing8,
              children: <Widget>[
                LumosIconButton(
                  onPressed: onAudioPressed,
                  tooltip: l10n.flashcardPlayAudioTooltip,
                  icon: Icons.volume_up_outlined,
                  selected: isAudioPlaying,
                  selectedIcon: Icons.graphic_eq_rounded,
                ),
                LumosIconButton(
                  onPressed: onEditPressed,
                  tooltip: l10n.flashcardEditTooltip,
                  icon: Icons.edit_outlined,
                ),
                LumosIconButton(
                  onPressed: onDeletePressed,
                  tooltip: l10n.flashcardDeleteTooltip,
                  icon: Icons.delete_outline_rounded,
                  variant: LumosIconButtonVariant.outlined,
                ),
                LumosIconButton(
                  onPressed: onStarPressed,
                  tooltip: l10n.flashcardBookmarkTooltip,
                  icon: Icons.star_border,
                  selected: isStarred,
                  selectedIcon: Icons.star,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNote({required BuildContext context}) {
    if (item.note.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: FlashcardContentCardConst.textGap),
      LumosInlineText(
        item.note,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: FlashcardContentCardConst.noteMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }
}
