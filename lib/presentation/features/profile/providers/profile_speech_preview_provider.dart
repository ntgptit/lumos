import 'dart:async';

import 'package:lumos/core/di/service_providers.dart';
import 'package:lumos/core/services/text_to_speech_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entities/study/study_models.dart';
import 'profile_speech_preview_state.dart';

part 'profile_speech_preview_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileSpeechPreviewController extends _$ProfileSpeechPreviewController {
  @override
  ProfileSpeechPreviewState build() {
    final TextToSpeechService textToSpeechService = ref.read(
      textToSpeechServiceProvider,
    );
    ref.onDispose(() {
      unawaited(textToSpeechService.stop());
    });
    return const ProfileSpeechPreviewState.initial();
  }

  Future<void> play({
    required SpeechPreference preference,
    required String text,
  }) async {
    final String normalizedText = StringUtils.normalizeText(text);
    if (normalizedText.isEmpty) {
      return;
    }
    state = state.copyWith(isBusy: true, isPlaying: false, errorMessage: null);
    final TextToSpeechService textToSpeechService = ref.read(
      textToSpeechServiceProvider,
    );
    try {
      await textToSpeechService.stop();
      state = state.copyWith(isBusy: false, isPlaying: true);
      await textToSpeechService.speak(
        normalizedText,
        locale: preference.locale,
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
    final TextToSpeechService textToSpeechService = ref.read(
      textToSpeechServiceProvider,
    );
    await textToSpeechService.stop();
    state = state.copyWith(isBusy: false, isPlaying: false);
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(errorMessage: null);
  }
}
