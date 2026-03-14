import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/presentation/features/progress/providers/study_overview_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  test('studyOverview combines reminder and analytics payloads', () async {
    final FakeStudyRepository repository = FakeStudyRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: [
        studyRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final StudyOverviewData overview = await container.read(
      studyOverviewProvider.future,
    );

    expect(overview.reminder.dueCount, 4);
    expect(overview.analytics.totalLearnedItems, 12);
  });
}
