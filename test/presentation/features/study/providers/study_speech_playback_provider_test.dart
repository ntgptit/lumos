import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/core/di/service_providers.dart';
import 'package:lumos/core/services/text_to_speech_service.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';
import 'package:lumos/presentation/features/study/providers/study_speech_playback_provider.dart';

void main() {
  group('StudySpeechPlaybackController', () {
    test('syncCurrentItem auto plays when speech allows it', () async {
      final _FakeTextToSpeechService service = _FakeTextToSpeechService();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          textToSpeechServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(studySpeechPlaybackControllerProvider(7).notifier)
          .syncCurrentItem(
            flashcardId: 101,
            speech: const SpeechCapability(
              enabled: true,
              autoPlay: true,
              available: true,
              adapter: studySpeechAdapterFlutterTts,
              locale: 'ko-KR',
              voice: studySpeechVoiceUnspecified,
              speed: 1,
              pitch: 1,
              fieldName: 'prompt',
              sourceType: 'text',
              audioUrl: '',
              allowedActions: <String>[
                StudySpeechPlaybackConst.playSpeechAction,
              ],
              speechText: '안녕하세요',
            ),
          );

      final state = container.read(studySpeechPlaybackControllerProvider(7));
      expect(service.stopCallCount, 2);
      expect(service.spokenTexts, <String>['안녕하세요']);
      expect(service.locales, <String?>['ko-KR']);
      expect(state.activeFlashcardId, 101);
      expect(state.autoPlayedFlashcardId, 101);
      expect(state.isPlaying, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('play ignores unavailable speech payloads', () async {
      final _FakeTextToSpeechService service = _FakeTextToSpeechService();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          textToSpeechServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(studySpeechPlaybackControllerProvider(7).notifier)
          .play(
            flashcardId: 101,
            speech: const SpeechCapability(
              enabled: true,
              autoPlay: false,
              available: false,
              adapter: studySpeechAdapterFlutterTts,
              locale: 'ko-KR',
              voice: studySpeechVoiceUnspecified,
              speed: 1,
              pitch: 1,
              fieldName: 'prompt',
              sourceType: 'text',
              audioUrl: '',
              allowedActions: <String>[],
              speechText: '',
            ),
          );

      expect(service.stopCallCount, 0);
      expect(service.spokenTexts, isEmpty);
      expect(
        container.read(studySpeechPlaybackControllerProvider(7)),
        const StudySpeechPlaybackState.initial(),
      );
    });

    test('stores playback errors and stop resets flags', () async {
      final _FakeTextToSpeechService service = _FakeTextToSpeechService(
        speakError: StateError('playback failed'),
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          textToSpeechServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        studySpeechPlaybackControllerProvider(7).notifier,
      );
      await notifier.play(
        flashcardId: 101,
        speech: const SpeechCapability(
          enabled: true,
          autoPlay: false,
          available: true,
          adapter: studySpeechAdapterFlutterTts,
          locale: 'ko-KR',
          voice: studySpeechVoiceUnspecified,
          speed: 1,
          pitch: 1,
          fieldName: 'prompt',
          sourceType: 'text',
          audioUrl: '',
          allowedActions: <String>[
            StudySpeechPlaybackConst.playSpeechAction,
          ],
          speechText: '안녕하세요',
        ),
      );

      expect(
        container.read(studySpeechPlaybackControllerProvider(7)).errorMessage,
        contains('playback failed'),
      );

      await notifier.stop();

      final state = container.read(studySpeechPlaybackControllerProvider(7));
      expect(service.stopCallCount, 2);
      expect(state.isBusy, isFalse);
      expect(state.isPlaying, isFalse);
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
