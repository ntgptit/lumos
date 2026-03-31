import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

class StudyProgressDistributionCard extends StatelessWidget {
  const StudyProgressDistributionCard({
    required this.analytics,
    required this.l10n,
    super.key,
  });

  final StudyAnalyticsOverview analytics;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final double cardPadding = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.studyProgressBoxDistributionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            SizedBox(
              height: context.spacing.md,
            ),
            ...analytics.boxDistribution.entries.map(
              (MapEntry<int, int> entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: context.spacing.sm,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: LumosText(
                        l10n.studyProgressBoxLabel(entry.key),
                        style: LumosTextStyle.bodyMedium,
                      ),
                    ),
                    LumosText(
                      '${entry.value}',
                      style: LumosTextStyle.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
