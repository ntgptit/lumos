import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FlashcardSetMetadataSection extends StatelessWidget {
  const FlashcardSetMetadataSection({
    required this.title,
    required this.totalFlashcards,
    super.key,
  });

  final String title;
  final int totalFlashcards;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String metadataLine = [
      l10n.flashcardOwnerFallback,
      l10n.flashcardTotalLabel(totalFlashcards),
      l10n.flashcardUpdatedRecentlyLabel,
    ].join(' • ');
    return LumosCard(
      variant: LumosCardVariant.filled,
      child: Row(
        children: <Widget>[
          Container(
            width: WidgetSizes.avatarLarge,
            height: WidgetSizes.avatarLarge,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadii.large,
            ),
            child: const Center(child: LumosIcon(Icons.style_outlined)),
          ),
          const SizedBox(width: Insets.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(title, style: LumosTextStyle.titleMedium),
                const SizedBox(height: Insets.spacing4),
                LumosText(metadataLine, style: LumosTextStyle.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
