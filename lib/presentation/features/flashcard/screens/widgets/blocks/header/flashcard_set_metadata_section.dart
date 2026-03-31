import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';

abstract final class FlashcardSetMetadataSectionConst {
  FlashcardSetMetadataSectionConst._();

  static const double titleBottomSpacing =
      16;
  static const double rowSpacing =
      16;
  static const double ownerAvatarRadius =
      24;
  static const double ownerNameRightSpacing =
      12;
  static const double chipHorizontalPadding =
      16;
  static const double chipVerticalPadding =
      8;
  static const double dividerHorizontalMargin =
      16;
  static const double dividerHeight =
      48;
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
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String ownerName = l10n.flashcardOwnerFallback;
    final double titleBottomSpacing = context.compactValue(
      baseValue: FlashcardSetMetadataSectionConst.titleBottomSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowSpacing = context.compactValue(
      baseValue: FlashcardSetMetadataSectionConst.rowSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double ownerAvatarRadius = context.compactValue(
      baseValue: FlashcardSetMetadataSectionConst.ownerAvatarRadius,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double chipHorizontalPadding = context.compactValue(
      baseValue: FlashcardSetMetadataSectionConst.chipHorizontalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double chipVerticalPadding = context.compactValue(
      baseValue: FlashcardSetMetadataSectionConst.chipVerticalPadding,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dividerHorizontalMargin = context.compactValue(
      baseValue: FlashcardSetMetadataSectionConst.dividerHorizontalMargin,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double dividerHeight = context.compactValue(
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
                child: LumosIcon(Icons.person_rounded),
              ),
            ),
            SizedBox(width: rowSpacing),
            LumosInlineText(
              ownerName,
              style: context.theme.textTheme.bodyMedium,
            ),
            SizedBox(
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
                  style: context.theme.textTheme.labelLarge?.copyWith(
                   
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: dividerHorizontalMargin),
              width: AppStroke.regular,
              height: dividerHeight,
              color: colorScheme.outlineVariant,
            ),
            Expanded(
              child: LumosInlineText(
                l10n.flashcardTotalLabel(totalFlashcards),
                style: context.theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
