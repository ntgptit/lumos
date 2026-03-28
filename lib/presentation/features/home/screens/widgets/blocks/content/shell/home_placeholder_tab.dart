import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/tokens/visual/elevation_tokens.dart';

class HomePlaceholderTab extends StatelessWidget {
  const HomePlaceholderTab({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  static const double emphasizedBorderWidth = AppStroke.thin;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double screenPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: EdgeInsets.all(screenPadding),
          child: LumosCard(
            margin: EdgeInsets.zero,
            elevation: AppElevationTokens.level1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(LumosSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: emphasizedBorderWidth,
                    ),
                    color: colorScheme.surfaceContainer,
                    borderRadius: context.shapes.card,
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: colorScheme.primary),
                    child: LumosIcon(icon, size: IconSizes.iconXLarge),
                  ),
                ),
                const SizedBox(height: LumosSpacing.lg),
                LumosText(title, style: LumosTextStyle.headlineSmall),
                const SizedBox(height: LumosSpacing.sm),
                LumosText(
                  subtitle,
                  style: LumosTextStyle.bodyMedium,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
