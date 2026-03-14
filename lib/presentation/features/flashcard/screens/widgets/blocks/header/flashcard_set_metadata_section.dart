import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardSetMetadataSectionConst {
  FlashcardSetMetadataSectionConst._();

  static const double titleBottomSpacing = AppSpacing.md;
  static const double rowSpacing = AppSpacing.md;
  static const double ownerAvatarRadius = AppSpacing.lg;
  static const double ownerNameRightSpacing = AppSpacing.sm;
  static const double chipHorizontalPadding = AppSpacing.md;
  static const double chipVerticalPadding = AppSpacing.xs;
  static const double dividerHorizontalMargin = AppSpacing.md;
  static const double dividerHeight = AppSpacing.xxl;
}

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
    final String ownerName = l10n.flashcardOwnerFallback;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(title, style: LumosTextStyle.titleMedium),
        const SizedBox(
          height: FlashcardSetMetadataSectionConst.titleBottomSpacing,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: FlashcardSetMetadataSectionConst.ownerAvatarRadius,
              backgroundColor: colorScheme.secondaryContainer,
              child: IconTheme(
                data: IconThemeData(color: colorScheme.onSecondaryContainer),
                child: const LumosIcon(Icons.person_rounded),
              ),
            ),
            const SizedBox(width: FlashcardSetMetadataSectionConst.rowSpacing),
            LumosInlineText(
              ownerName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              width: FlashcardSetMetadataSectionConst.ownerNameRightSpacing,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadii.large,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal:
                      FlashcardSetMetadataSectionConst.chipHorizontalPadding,
                  vertical:
                      FlashcardSetMetadataSectionConst.chipVerticalPadding,
                ),
                child: LumosInlineText(
                  l10n.flashcardPlusBadge,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal:
                    FlashcardSetMetadataSectionConst.dividerHorizontalMargin,
              ),
              width: WidgetSizes.borderWidthRegular,
              height: FlashcardSetMetadataSectionConst.dividerHeight,
              color: colorScheme.outlineVariant,
            ),
            Expanded(
              child: LumosInlineText(
                l10n.flashcardTotalLabel(totalFlashcards),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
