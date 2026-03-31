import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

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
              l10n.studyProgressRecommendedReviewTitle,
              style: LumosTextStyle.titleLarge,
            ),
            SizedBox(
              height: context.spacing.sm,
            ),
            LumosText(
              l10n.studyProgressRecommendedReviewSummary(
                recommendation.deckName,
                recommendation.dueCount,
              ),
              style: LumosTextStyle.bodyMedium,
            ),
            SizedBox(
              height: context.spacing.md,
            ),
            LumosPrimaryButton(
              onPressed: onStartReview,
              text: l10n.studyProgressStartReviewAction,
              icon: Icons.play_arrow_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
