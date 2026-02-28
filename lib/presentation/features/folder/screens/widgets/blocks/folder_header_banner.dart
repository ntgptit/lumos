import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

import 'folder_header_meta_pill.dart';

class FolderHeaderBanner extends StatelessWidget {
  const FolderHeaderBanner({
    required this.l10n,
    required this.currentDepth,
    super.key,
  });

  final AppLocalizations l10n;
  final int currentDepth;

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
                  l10n.folderManagerTitle,
                  style: LumosTextStyle.titleLarge,
                ),
                const SizedBox(height: Insets.spacing8),
                LumosText(
                  l10n.folderManagerSubtitle,
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
                      icon: Icons.account_tree_rounded,
                      label: l10n.folderDepth(currentDepth),
                      backgroundColor: colorScheme.tertiaryContainer,
                      foregroundColor: colorScheme.onTertiaryContainer,
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
          color: colorScheme.primary,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: colorScheme.primary),
        child: const LumosIcon(
          Icons.folder_copy_rounded,
          size: IconSizes.iconMedium,
        ),
      ),
    );
  }
}
