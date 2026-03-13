import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/providers/study_preference_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('StudyPreferenceController', () {
    test('build loads study preference', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final preference = await container.read(
        studyPreferenceControllerProvider.future,
      );

      expect(preference.firstLearningCardLimit, 20);
    });

    test('savePreference persists updated value', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(studyPreferenceControllerProvider.future);

      await container
          .read(studyPreferenceControllerProvider.notifier)
          .savePreference(const StudyPreference(firstLearningCardLimit: 12));

      final preference = container
          .read(studyPreferenceControllerProvider)
          .requireValue;
      expect(repository.lastStudyPreference!.firstLearningCardLimit, 12);
      expect(preference.firstLearningCardLimit, 12);
    });
  });
}
