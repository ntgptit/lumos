import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/study/study_repository_impl.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/study/study_repository.dart';

part 'study_overview_provider.g.dart';

class StudyOverviewData {
  const StudyOverviewData({required this.reminder, required this.analytics});

  final StudyReminderSummary reminder;
  final StudyAnalyticsOverview analytics;
}

@Riverpod(keepAlive: true)
Future<StudyOverviewData> studyOverview(Ref ref) async {
  final StudyRepository repository = ref.read(studyRepositoryProvider);
  final StudyReminderSummary reminder = await repository.getReminderSummary();
  final StudyAnalyticsOverview analytics = await repository
      .getAnalyticsOverview();
  return StudyOverviewData(reminder: reminder, analytics: analytics);
}
