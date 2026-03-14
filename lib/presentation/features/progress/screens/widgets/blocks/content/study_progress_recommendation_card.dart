import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

class StudyProgressRecommendationCard extends StatelessWidget {
  const StudyProgressRecommendationCard({
    required this.recommendation,
    required this.l10n,
    required this.onStartReview,
    super.key,
  });

  final ReminderRecommendation recommendation;
  final AppLocalizations l10n;
  final VoidCallback onStartReview;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.studyProgressRecommendedReviewTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            LumosText(
              l10n.studyProgressRecommendedReviewSummary(
                recommendation.deckName,
                recommendation.dueCount,
              ),
              style: LumosTextStyle.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            LumosPrimaryButton(
              onPressed: onStartReview,
              label: l10n.studyProgressStartReviewAction,
              icon: Icons.play_arrow_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
