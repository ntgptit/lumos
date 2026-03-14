import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

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
    return LumosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.studyProgressMomentumTitle,
              style: LumosTextStyle.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            LumosText(
              l10n.studyProgressMomentumSummary(
                reminder.dueCount,
                reminder.overdueCount,
                reminder.escalationLevel,
              ),
              style: LumosTextStyle.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            LumosProgressBar(value: progressValue),
          ],
        ),
      ),
    );
  }
}
