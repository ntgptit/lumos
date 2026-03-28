import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';

import 'folder_header_meta_pill.dart';

class FolderHeaderBanner extends StatelessWidget {
  const FolderHeaderBanner({
    required this.l10n,
    required this.currentDepth,
    required this.isDeckManager,
    required this.deckCount,
    super.key,
  });

  final AppLocalizations l10n;
  final int currentDepth;
  final bool isDeckManager;
  final int deckCount;

  @override
  Widget build(BuildContext context) {
    final double leadingBoxSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.section,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
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
    final double rowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double pillGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double blobLargeOffset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double blobLargeSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.canvas * 2,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double blobSmallOffset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double blobSmallSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.canvas,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String managerTitle = _buildManagerTitle();
    final String managerSubtitle = _buildManagerSubtitle();
    final IconData leadingIcon = _buildLeadingIcon();
    final Color leadingIconColor = _buildLeadingIconColor(colorScheme);
    final IconData secondaryPillIcon = _buildSecondaryPillIcon();
    final String secondaryPillLabel = _buildSecondaryPillLabel();
    final Color secondaryPillBackgroundColor =
        _buildSecondaryPillBackgroundColor(colorScheme: colorScheme);
    final Color secondaryPillForegroundColor =
        _buildSecondaryPillForegroundColor(colorScheme: colorScheme);
    final Widget leadingIconWidget = Container(
      width: leadingBoxSize,
      height: leadingBoxSize,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: context.shapes.card,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: leadingIconColor),
        child: LumosIcon(leadingIcon, size: IconSizes.iconMedium),
      ),
    );
    return ClipRRect(
      borderRadius: context.shapes.hero,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: LumosDecorativeBackground(
              gradientColors: <Color>[
                colorScheme.primaryContainer,
                colorScheme.surfaceContainerHigh,
              ],
              blobs: <LumosDecorativeBlob>[
                LumosDecorativeBlob(
                  top: -blobLargeOffset,
                  right: -blobLargeOffset,
                  fill: colorScheme.tertiaryContainer,
                  size: blobLargeSize,
                ),
                LumosDecorativeBlob(
                  bottom: -blobSmallOffset,
                  left: -blobSmallOffset,
                  fill: colorScheme.secondaryContainer,
                  size: blobSmallSize,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(
                  alpha: AppOpacity.scrimLight,
                ),
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
              children: <Widget>[
                leadingIconWidget,
                SizedBox(width: rowGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LumosText(managerTitle, style: LumosTextStyle.titleLarge),
                      SizedBox(height: titleGap),
                      LumosText(
                        managerSubtitle,
                        style: LumosTextStyle.bodySmall,
                      ),
                      SizedBox(height: titleGap),
                      Wrap(
                        spacing: pillGap,
                        runSpacing: pillGap,
                        children: <Widget>[
                          FolderHeaderMetaPill(
                            icon: Icons.home_rounded,
                            label: l10n.folderRoot,
                            backgroundColor: colorScheme.secondaryContainer,
                            foregroundColor: colorScheme.onSecondaryContainer,
                          ),
                          FolderHeaderMetaPill(
                            icon: secondaryPillIcon,
                            label: secondaryPillLabel,
                            backgroundColor: secondaryPillBackgroundColor,
                            foregroundColor: secondaryPillForegroundColor,
                          ),
                        ],
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

  String _buildManagerTitle() {
    if (isDeckManager) {
      return l10n.deckManagerTitle;
    }
    return l10n.folderManagerTitle;
  }

  String _buildManagerSubtitle() {
    if (isDeckManager) {
      return l10n.deckManagerSubtitle;
    }
    return l10n.folderManagerSubtitle;
  }

  IconData _buildLeadingIcon() {
    if (isDeckManager) {
      return Icons.style_rounded;
    }
    return Icons.folder_copy_rounded;
  }

  Color _buildLeadingIconColor(ColorScheme colorScheme) {
    if (isDeckManager) {
      return colorScheme.tertiary;
    }
    return colorScheme.primary;
  }

  IconData _buildSecondaryPillIcon() {
    if (isDeckManager) {
      return Icons.style_outlined;
    }
    return Icons.account_tree_rounded;
  }

  String _buildSecondaryPillLabel() {
    if (isDeckManager) {
      return l10n.deckCount(deckCount);
    }
    return l10n.folderDepth(currentDepth);
  }

  Color _buildSecondaryPillBackgroundColor({required ColorScheme colorScheme}) {
    if (isDeckManager) {
      return colorScheme.tertiaryContainer;
    }
    return colorScheme.tertiaryContainer;
  }

  Color _buildSecondaryPillForegroundColor({required ColorScheme colorScheme}) {
    if (isDeckManager) {
      return colorScheme.onTertiaryContainer;
    }
    return colorScheme.onTertiaryContainer;
  }
}
