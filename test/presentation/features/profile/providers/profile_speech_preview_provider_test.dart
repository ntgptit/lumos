import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/core/di/service_providers.dart';
import 'package:lumos/core/services/text_to_speech_service.dart';
import 'package:lumos/presentation/features/profile/providers/profile_speech_preview_provider.dart';
import 'package:lumos/presentation/features/profile/providers/profile_speech_preview_state.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('ProfileSpeechPreviewController', () {
    test('plays normalized text with the current locale', () async {
      final _FakeTextToSpeechService service = _FakeTextToSpeechService();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          textToSpeechServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(profileSpeechPreviewControllerProvider.notifier)
          .play(
            preference: sampleSpeechPreference(),
            text: '  안녕하세요.  ',
          );

      final state = container.read(profileSpeechPreviewControllerProvider);
      expect(service.stopCallCount, 1);
      expect(service.spokenTexts, <String>['안녕하세요.']);
      expect(service.locales, <String?>['ko-KR']);
      expect(state.isBusy, isFalse);
      expect(state.isPlaying, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('ignores blank preview text', () async {
      final _FakeTextToSpeechService service = _FakeTextToSpeechService();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          textToSpeechServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(profileSpeechPreviewControllerProvider.notifier)
          .play(preference: sampleSpeechPreference(), text: '   ');

      final state = container.read(profileSpeechPreviewControllerProvider);
      expect(service.stopCallCount, 0);
      expect(service.spokenTexts, isEmpty);
      expect(state, const ProfileSpeechPreviewState.initial());
    });

    test('stores and clears playback errors', () async {
      final _FakeTextToSpeechService service = _FakeTextToSpeechService(
        speakError: StateError('preview failed'),
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          textToSpeechServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(profileSpeechPreviewControllerProvider.notifier)
          .play(
            preference: sampleSpeechPreference(),
            text: '안녕하세요.',
          );

      final notifier = container.read(
        profileSpeechPreviewControllerProvider.notifier,
      );
      expect(
        container.read(profileSpeechPreviewControllerProvider).errorMessage,
        contains('preview failed'),
      );

      notifier.clearError();

      expect(
        container.read(profileSpeechPreviewControllerProvider).errorMessage,
        isNull,
      );
    });
  });
}

class _FakeTextToSpeechService implements TextToSpeechService {
  _FakeTextToSpeechService({this.speakError});

  final Object? speakError;
  final List<String> spokenTexts = <String>[];
  final List<String?> locales = <String?>[];
  int stopCallCount = 0;

  @override
  Future<void> speak(String text, {String? locale}) async {
    if (speakError != null) {
      throw speakError!;
    }
    spokenTexts.add(text);
    locales.add(locale);
  }

  @override
  Future<void> stop() async {
    stopCallCount += 1;
  }
}
