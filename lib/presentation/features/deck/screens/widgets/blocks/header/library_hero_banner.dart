import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/cards/lumos_hero_banner.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_pill.dart';

class LibraryHeroBanner extends StatelessWidget {
  const LibraryHeroBanner({
    required this.l10n,
    required this.folderCount,
    super.key,
  });

  final AppLocalizations l10n;
  final int? folderCount;

  @override
  Widget build(BuildContext context) {
    final double leadingBoxSize = context.component.listItemLeadingSize;
    final double rowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosHeroBanner(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: leadingBoxSize,
            height: leadingBoxSize,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHigh,
              borderRadius: context.shapes.control,
              border: Border.all(
                color: context.colorScheme.outlineVariant,
                width: WidgetSizes.borderWidthRegular,
              ),
            ),
            child: IconTheme(
              data: IconThemeData(color: context.colorScheme.onSurface),
              child: LumosIcon(Icons.layers_rounded, size: context.iconSize.lg),
            ),
          ),
          SizedBox(width: rowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: LumosText(
                        l10n.homeTabLibrary,
                        style: LumosTextStyle.titleLarge,
                      ),
                    ),
                    SizedBox(width: titleGap),
                    if (folderCount == null)
                      LumosSkeletonBox(
                        width: context.spacing.xxxl * 2,
                        height: context.spacing.xl,
                        borderRadius: context.shapes.pill,
                      ),
                    if (folderCount != null)
                      LumosPill(
                        backgroundColor:
                            context.colorScheme.surfaceContainerHigh,
                        child: LumosText(
                          l10n.libraryRootFolderCount(folderCount!),
                          style: LumosTextStyle.labelLarge,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: titleGap),
                LumosText(
                  l10n.homeLibrarySubtitle,
                  style: LumosTextStyle.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
