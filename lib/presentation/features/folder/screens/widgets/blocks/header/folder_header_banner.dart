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
    final double leadingBoxSize = context.component.listItemLeadingSize;
    final double bannerPadding = context.compactValue(
      baseValue: context.spacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleRowGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowGap = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double blobLargeOffset = context.compactValue(
      baseValue:
          context.spacing.xxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double blobLargeSize = context.compactValue(
      baseValue:
          96 +
          context.spacing.xxxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final ColorScheme colorScheme = context.colorScheme;
    final String managerTitle = _buildManagerTitle();
    final String managerSubtitle = _buildManagerSubtitle();
    final IconData leadingIcon = _buildLeadingIcon();
    final Color leadingIconColor = _buildLeadingIconColor(colorScheme);
    final IconData contextPillIcon = _buildContextPillIcon();
    final String contextPillLabel = _buildContextPillLabel();
    final Widget leadingIconWidget = Container(
      width: leadingBoxSize,
      height: leadingBoxSize,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: context.shapes.control,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: AppStroke.regular,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: leadingIconColor),
        child: LumosIcon(leadingIcon, size: context.iconSize.lg),
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
                  width: AppStroke.regular,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(bannerPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                leadingIconWidget,
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
                              managerTitle,
                              style: LumosTextStyle.titleLarge,
                            ),
                          ),
                          SizedBox(width: titleRowGap),
                          FolderHeaderMetaPill(
                            icon: contextPillIcon,
                            label: contextPillLabel,
                            backgroundColor: colorScheme.surfaceContainerHigh,
                            foregroundColor: colorScheme.onSurface,
                          ),
                        ],
                      ),
                      SizedBox(height: titleGap),
                      LumosText(
                        managerSubtitle,
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
    return colorScheme.onSurface;
  }

  IconData _buildContextPillIcon() {
    if (isDeckManager) {
      return Icons.style_outlined;
    }
    if (currentDepth == 0) {
      return Icons.home_rounded;
    }
    return Icons.account_tree_rounded;
  }

  String _buildContextPillLabel() {
    if (isDeckManager) {
      return l10n.deckCount(deckCount);
    }
    if (currentDepth == 0) {
      return l10n.folderRoot;
    }
    return l10n.folderDepth(currentDepth);
  }
}
