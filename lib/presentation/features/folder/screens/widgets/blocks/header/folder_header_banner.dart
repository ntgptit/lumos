import 'package:flutter/material.dart';

import '../../../../../../../core/constants/dimensions.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadii.large,
      child: Stack(
        children: <Widget>[
          _buildBannerBackground(colorScheme: colorScheme),
          _buildBannerOverlay(colorScheme: colorScheme),
          _buildBannerContent(colorScheme: colorScheme),
        ],
      ),
    );
  }

  Widget _buildBannerBackground({required ColorScheme colorScheme}) {
    return Positioned.fill(
      child: LumosDecorativeBackground(
        gradientColors: <Color>[
          colorScheme.primaryContainer,
          colorScheme.surfaceContainerHigh,
        ],
        blobs: <LumosDecorativeBlob>[
          LumosDecorativeBlob(
            top: -Insets.spacing32,
            right: -Insets.spacing32,
            fill: colorScheme.tertiaryContainer,
            size: Insets.spacing64 * 2,
          ),
          LumosDecorativeBlob(
            bottom: -Insets.spacing24,
            left: -Insets.spacing24,
            fill: colorScheme.secondaryContainer,
            size: Insets.spacing64,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerOverlay({required ColorScheme colorScheme}) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(
            alpha: WidgetOpacities.scrimLight,
          ),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: WidgetSizes.borderWidthRegular,
          ),
        ),
      ),
    );
  }

  Widget _buildBannerContent({required ColorScheme colorScheme}) {
    return Padding(
      padding: const EdgeInsets.all(Insets.spacing12),
      child: Row(
        children: <Widget>[
          _buildHeaderLeadingIcon(colorScheme: colorScheme),
          const SizedBox(width: Insets.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  _buildManagerTitle(),
                  style: LumosTextStyle.titleLarge,
                ),
                const SizedBox(height: Insets.spacing8),
                LumosText(
                  _buildManagerSubtitle(),
                  style: LumosTextStyle.bodySmall,
                ),
                const SizedBox(height: Insets.spacing8),
                Wrap(
                  spacing: Insets.spacing8,
                  runSpacing: Insets.spacing8,
                  children: <Widget>[
                    FolderHeaderMetaPill(
                      icon: Icons.home_rounded,
                      label: l10n.folderRoot,
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                    ),
                    FolderHeaderMetaPill(
                      icon: _buildSecondaryPillIcon(),
                      label: _buildSecondaryPillLabel(),
                      backgroundColor: _buildSecondaryPillBackgroundColor(
                        colorScheme: colorScheme,
                      ),
                      foregroundColor: _buildSecondaryPillForegroundColor(
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLeadingIcon({required ColorScheme colorScheme}) {
    return Container(
      width: Insets.spacing40,
      height: Insets.spacing40,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadii.medium,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: _buildLeadingIconColor(colorScheme)),
        child: LumosIcon(_buildLeadingIcon(), size: IconSizes.iconMedium),
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
