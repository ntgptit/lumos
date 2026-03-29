import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_pill.dart';

class DeckHeroBanner extends StatelessWidget {
  const DeckHeroBanner({
    required this.l10n,
    required this.deckCount,
    super.key,
  });

  final AppLocalizations l10n;
  final int? deckCount;

  @override
  Widget build(BuildContext context) {
    final double leadingBoxSize = context.component.listItemLeadingSize;
    final double bannerPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleRowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double blobLargeOffset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double blobLargeSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.canvas + LumosSpacing.xxxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final ColorScheme colorScheme = context.colorScheme;

    return ClipRRect(
      borderRadius: context.shapes.hero,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: LumosDecorativeBackground(
              gradientColors: <Color>[
                colorScheme.primaryContainer,
                colorScheme.surfaceContainer,
              ],
              blobs: <LumosDecorativeBlob>[
                LumosDecorativeBlob(
                  top: -blobLargeOffset,
                  right: -blobLargeOffset,
                  fill: colorScheme.tertiaryContainer,
                  size: blobLargeSize,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: WidgetSizes.borderWidthRegular,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(bannerPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: leadingBoxSize,
                  height: leadingBoxSize,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: context.shapes.control,
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: WidgetSizes.borderWidthRegular,
                    ),
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: colorScheme.onSurface),
                    child: LumosIcon(Icons.style_rounded, size: context.iconSize.lg),
                  ),
                ),
                SizedBox(width: rowGap),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: LumosText(
                              l10n.deckManagerTitle,
                              style: LumosTextStyle.titleLarge,
                            ),
                          ),
                          SizedBox(width: titleRowGap),
                          if (deckCount == null)
                            LumosSkeletonBox(
                              width: context.spacing.xxxl * 2,
                              height: context.spacing.xl,
                              borderRadius: context.shapes.pill,
                            ),
                          if (deckCount != null)
                            LumosPill(
                              backgroundColor: colorScheme.surfaceContainerHigh,
                              child: LumosText(
                                l10n.deckCount(deckCount!),
                                style: LumosTextStyle.labelLarge,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: titleGap),
                      LumosText(
                        l10n.deckManagerSubtitle,
                        style: LumosTextStyle.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
