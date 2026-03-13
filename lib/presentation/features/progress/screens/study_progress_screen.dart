import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/study_overview_provider.dart';

class StudyProgressScreen extends ConsumerWidget {
  const StudyProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<StudyOverviewData> overviewAsync = ref.watch(
      studyOverviewProvider,
    );
    return overviewAsync.when(
      loading: () => const Center(child: LumosLoadingIndicator()),
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: LumosErrorState(
            errorMessage: error.toString(),
            onRetry: () {
              ref.invalidate(studyOverviewProvider);
            },
          ),
        );
      },
      data: (StudyOverviewData data) {
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            LumosCard(
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
                        data.reminder.dueCount,
                        data.reminder.overdueCount,
                        data.reminder.escalationLevel,
                      ),
                      style: LumosTextStyle.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LumosProgressBar(
                      value: data.analytics.totalLearnedItems == 0
                          ? 0
                          : (data.analytics.passedAttempts /
                                (data.analytics.passedAttempts + data.analytics.failedAttempts + 1)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (data.reminder.recommendation case final recommendation?)
              LumosCard(
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
                        onPressed: () {
                          context.pushNamed(
                            AppRouteName.studySession,
                            pathParameters: <String, String>{
                              AppRouteParam.deckId:
                                  recommendation.deckId.toString(),
                            },
                            queryParameters: <String, String>{
                              AppRouteQuery.deckName: recommendation.deckName,
                            },
                          );
                        },
                        label: l10n.studyProgressStartReviewAction,
                        icon: Icons.play_arrow_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            LumosCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LumosText(
                      l10n.studyProgressBoxDistributionTitle,
                      style: LumosTextStyle.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...data.analytics.boxDistribution.entries.map((MapEntry<int, int> entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
