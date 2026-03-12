import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/providers/speech_preference_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('SpeechPreferenceController', () {
    test('build loads speech preference', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          studyRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final preference = await container.read(
        speechPreferenceControllerProvider.future,
      );

      expect(preference.voice, 'ko-KR-neutral');
    });

    test('savePreference persists updated value', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          studyRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(speechPreferenceControllerProvider.future);

      await container
          .read(speechPreferenceControllerProvider.notifier)
          .savePreference(
            const SpeechPreference(
              enabled: false,
              autoPlay: true,
              voice: 'ko-KR-female',
              speed: 1.2,
              locale: 'ko-KR',
            ),
          );

      final preference = container.read(
        speechPreferenceControllerProvider,
      ).requireValue;
      expect(repository.lastPreference!.voice, 'ko-KR-female');
      expect(preference.autoPlay, isTrue);
    });
  });
}
