import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/speech/providers/tts_engine_registry_provider.dart';
import '../../../../core/speech/tts_engine_catalog.dart';
import '../../../../core/speech/tts_engine_registry.dart';
import '../../../../core/speech/tts_engine_speak_request.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entities/study/study_models.dart';
import 'profile_speech_preview_state.dart';

part 'profile_speech_preview_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileSpeechPreviewController extends _$ProfileSpeechPreviewController {
  @override
  ProfileSpeechPreviewState build() {
    final TtsEngineRegistry engineRegistry = ref.read(
      ttsEngineRegistryProvider,
    );
    ref.onDispose(() {
      unawaited(engineRegistry.stopAll());
    });
    return const ProfileSpeechPreviewState.initial();
  }

  Future<void> play({
    required SpeechPreference preference,
    required String text,
  }) async {
    final String normalizedText = StringUtils.normalizeName(text);
    if (normalizedText.isEmpty) {
      return;
    }
    state = state.copyWith(isBusy: true, isPlaying: false, errorMessage: null);
    final TtsEngineRegistry engineRegistry = ref.read(
      ttsEngineRegistryProvider,
    );
    final String resolvedAdapter = normalizeTtsAdapter(preference.adapter);
    try {
      await engineRegistry.stopAll();
      state = state.copyWith(isBusy: false, isPlaying: true);
      await engineRegistry
          .resolve(resolvedAdapter)
          .speak(
            request: TtsEngineSpeakRequest(
              text: normalizedText,
              locale: preference.locale,
              voice: preference.voice,
              speed: preference.speed,
              pitch: preference.pitch,
            ),
          );
      state = state.copyWith(
        isBusy: false,
        isPlaying: false,
        errorMessage: null,
      );
    } on Object catch (error) {
      state = state.copyWith(
        isBusy: false,
        isPlaying: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> stop() async {
    final TtsEngineRegistry engineRegistry = ref.read(
      ttsEngineRegistryProvider,
    );
    await engineRegistry.stopAll();
    state = state.copyWith(isBusy: false, isPlaying: false);
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(errorMessage: null);
  }
}
