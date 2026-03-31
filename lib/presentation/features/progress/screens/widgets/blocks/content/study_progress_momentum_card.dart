import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

class StudyProgressMomentumCard extends StatelessWidget {
  const StudyProgressMomentumCard({
    required this.analytics,
    required this.reminder,
    required this.l10n,
    super.key,
  });

  final StudyAnalyticsOverview analytics;
  final StudyReminderSummary reminder;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final int totalAttempts =
        analytics.passedAttempts + analytics.failedAttempts + 1;
    final double progressValue = analytics.totalLearnedItems == 0
        ? 0
        : analytics.passedAttempts / totalAttempts;
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
              l10n.studyProgressMomentumTitle,
              style: LumosTextStyle.headlineSmall,
            ),
            SizedBox(
              height: context.spacing.sm,
            ),
            LumosText(
              l10n.studyProgressMomentumSummary(
                reminder.dueCount,
                reminder.overdueCount,
                reminder.escalationLevel,
              ),
              style: LumosTextStyle.bodyMedium,
            ),
            SizedBox(
              height: context.spacing.md,
            ),
            LumosValueBar(value: progressValue),
          ],
        ),
      ),
    );
  }
}
