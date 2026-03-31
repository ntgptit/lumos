import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double cardPadding = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double headerGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );

    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(title, style: LumosTextStyle.titleMedium),
            SizedBox(height: headerGap),
            LumosText(subtitle, style: LumosTextStyle.bodySmall),
            SizedBox(height: sectionGap),
            child,
          ],
        ),
      ),
    );
  }
}
