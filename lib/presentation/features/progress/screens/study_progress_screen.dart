import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/study_overview_provider.dart';
import 'widgets/blocks/content/study_progress_distribution_card.dart';
import 'widgets/blocks/content/study_progress_momentum_card.dart';
import 'widgets/blocks/content/study_progress_recommendation_card.dart';
import 'widgets/states/study_progress_error_view.dart';
import 'widgets/states/study_progress_loading_view.dart';

class StudyProgressScreen extends ConsumerWidget {
  const StudyProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double screenPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final AsyncValue<StudyOverviewData> overviewAsync = ref.watch(
      studyOverviewProvider,
    );
    return overviewAsync.when(
      loading: () => const StudyProgressLoadingView(),
      error: (Object error, StackTrace stackTrace) {
        return StudyProgressErrorView(
          errorMessage: error.toString(),
          onRetry: () {
            ref.invalidate(studyOverviewProvider);
          },
        );
      },
      data: (StudyOverviewData data) {
        return ListView(
          padding: EdgeInsets.all(screenPadding),
          children: <Widget>[
            StudyProgressMomentumCard(
              analytics: data.analytics,
              reminder: data.reminder,
              l10n: l10n,
            ),
            SizedBox(height: sectionGap),
            if (data.reminder.recommendation case final recommendation?)
              StudyProgressRecommendationCard(
                recommendation: recommendation,
                l10n: l10n,
                onStartReview: () {
                  const StudySessionRouteData().push(context);
                },
              ),
            SizedBox(height: sectionGap),
            StudyProgressDistributionCard(
              analytics: data.analytics,
              l10n: l10n,
            ),
          ],
        );
      },
    );
  }
}

