import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../../core/themes/foundation/app_stroke.dart';
import '../../../../../../core/themes/semantic/app_elevation_tokens.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(Insets.spacing16),
          child: LumosCard(
            margin: EdgeInsets.zero,
            elevation: AppElevationTokens.level1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(Insets.spacing16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: emphasizedBorderWidth,
                    ),
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadii.large,
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: colorScheme.primary),
                    child: LumosIcon(icon, size: IconSizes.iconXLarge),
                  ),
                ),
                const SizedBox(height: Insets.spacing16),
                LumosText(title, style: LumosTextStyle.headlineSmall),
                const SizedBox(height: Insets.spacing8),
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
