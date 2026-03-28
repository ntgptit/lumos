import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';

abstract final class FlashcardSetMetadataSectionConst {
  FlashcardSetMetadataSectionConst._();

  static const double titleBottomSpacing = LumosSpacing.md;
  static const double rowSpacing = LumosSpacing.md;
  static const double ownerAvatarRadius = LumosSpacing.lg;
  static const double ownerNameRightSpacing = LumosSpacing.sm;
  static const double chipHorizontalPadding = LumosSpacing.md;
  static const double chipVerticalPadding = LumosSpacing.xs;
  static const double dividerHorizontalMargin = LumosSpacing.md;
  static const double dividerHeight = LumosSpacing.xxl;
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
    final double titleBottomSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.titleBottomSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.rowSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double ownerAvatarRadius = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.ownerAvatarRadius,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double chipHorizontalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.chipHorizontalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double chipVerticalPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.chipVerticalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dividerHorizontalMargin = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.dividerHorizontalMargin,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dividerHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardSetMetadataSectionConst.dividerHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(title, style: LumosTextStyle.titleMedium),
        SizedBox(height: titleBottomSpacing),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: ownerAvatarRadius,
              backgroundColor: colorScheme.secondaryContainer,
              child: IconTheme(
                data: IconThemeData(color: colorScheme.onSecondaryContainer),
                child: const LumosIcon(Icons.person_rounded),
              ),
            ),
            SizedBox(width: rowSpacing),
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
                borderRadius: context.shapes.pill,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: chipHorizontalPadding,
                  vertical: chipVerticalPadding,
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
              margin: EdgeInsets.symmetric(horizontal: dividerHorizontalMargin),
              width: WidgetSizes.borderWidthRegular,
              height: dividerHeight,
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
