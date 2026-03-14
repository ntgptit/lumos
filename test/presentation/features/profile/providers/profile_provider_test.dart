import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/profile/profile_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';
import 'package:lumos/presentation/features/profile/providers/profile_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('ProfileController', () {
    test('build loads aggregated profile', () async {
      final FakeProfileRepository repository = FakeProfileRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final profile = await container.read(profileControllerProvider.future);

      expect(profile.user.username, 'tester');
      expect(profile.studyPreference.firstLearningCardLimit, 20);
      expect(profile.speechPreference.voice, studySpeechVoiceUnspecified);
    });

    test('updateStudyPreference persists updated value', () async {
      final FakeProfileRepository repository = FakeProfileRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(profileControllerProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .updateStudyPreference(
            const StudyPreference(firstLearningCardLimit: 12),
          );

      final profile = container.read(profileControllerProvider).requireValue;
      expect(repository.lastStudyPreference!.firstLearningCardLimit, 12);
      expect(profile.studyPreference.firstLearningCardLimit, 12);
    });

    test('updateSpeechPreference persists updated value', () async {
      final FakeProfileRepository repository = FakeProfileRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(profileControllerProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .updateSpeechPreference(
            const SpeechPreference(
              enabled: false,
              autoPlay: true,
              adapter: studySpeechAdapterFlutterTts,
              voice: 'ko-KR-female',
              speed: 1.2,
              pitch: 1.2,
              locale: 'ko-KR',
            ),
          );

      final profile = container.read(profileControllerProvider).requireValue;
      expect(
        repository.lastSpeechPreference!.adapter,
        studySpeechAdapterFlutterTts,
      );
      expect(repository.lastSpeechPreference!.voice, 'ko-KR-female');
      expect(repository.lastSpeechPreference!.pitch, 1.2);
      expect(profile.speechPreference.autoPlay, isTrue);
    });
  });
}
