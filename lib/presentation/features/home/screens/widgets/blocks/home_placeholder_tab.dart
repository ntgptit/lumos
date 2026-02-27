import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(Insets.spacing16),
          child: LumosCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(Insets.spacing16),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadii.large,
                  ),
                  child: Icon(
                    icon,
                    size: IconSizes.iconXLarge,
                    color: colorScheme.primary,
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
