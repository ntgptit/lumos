import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardCardSectionHeaderConst {
  FlashcardCardSectionHeaderConst._();

  static const double titleBottomSpacing = Insets.spacing4;
  static const double sortGap = Insets.spacing8;
}

class FlashcardCardSectionHeader extends StatelessWidget {
  const FlashcardCardSectionHeader({
    required this.title,
    required this.subtitle,
    required this.sortLabel,
    required this.onSortPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String sortLabel;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosInlineText(title, style: theme.textTheme.titleMedium),
              const SizedBox(
                height: FlashcardCardSectionHeaderConst.titleBottomSpacing,
              ),
              LumosInlineText(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onSortPressed,
          borderRadius: BorderRadii.large,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.spacing8,
              vertical: Insets.spacing4,
            ),
            child: Row(
              children: <Widget>[
                LumosInlineText(sortLabel, style: theme.textTheme.titleMedium),
                const SizedBox(width: FlashcardCardSectionHeaderConst.sortGap),
                const LumosIcon(Icons.tune_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
