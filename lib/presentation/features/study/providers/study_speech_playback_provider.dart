import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/speech/providers/tts_engine_registry_provider.dart';
import '../../../../core/speech/tts_engine_catalog.dart';
import '../../../../core/speech/tts_engine_registry.dart';
import '../../../../core/speech/tts_engine_speak_request.dart';
import '../../../../domain/entities/study/study_models.dart';

part 'study_speech_playback_provider.g.dart';

abstract final class StudySpeechPlaybackConst {
  StudySpeechPlaybackConst._();

  static const String playSpeechAction = 'play_speech';
  static const String replaySpeechAction = 'replay_speech';
}

@immutable
class StudySpeechPlaybackState {
  const StudySpeechPlaybackState({
    required this.isBusy,
    required this.isPlaying,
    required this.activeFlashcardId,
    required this.autoPlayedFlashcardId,
    required this.errorMessage,
  });

  const StudySpeechPlaybackState.initial()
    : isBusy = false,
      isPlaying = false,
      activeFlashcardId = null,
      autoPlayedFlashcardId = null,
      errorMessage = null;

  final bool isBusy;
  final bool isPlaying;
  final int? activeFlashcardId;
  final int? autoPlayedFlashcardId;
  final String? errorMessage;

  StudySpeechPlaybackState copyWith({
    bool? isBusy,
    bool? isPlaying,
    Object? activeFlashcardId = _unsetSpeechValue,
    Object? autoPlayedFlashcardId = _unsetSpeechValue,
    Object? errorMessage = _unsetSpeechValue,
  }) {
    return StudySpeechPlaybackState(
      isBusy: isBusy ?? this.isBusy,
      isPlaying: isPlaying ?? this.isPlaying,
      activeFlashcardId: identical(activeFlashcardId, _unsetSpeechValue)
          ? this.activeFlashcardId
          : activeFlashcardId as int?,
      autoPlayedFlashcardId: identical(autoPlayedFlashcardId, _unsetSpeechValue)
          ? this.autoPlayedFlashcardId
          : autoPlayedFlashcardId as int?,
      errorMessage: identical(errorMessage, _unsetSpeechValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const Object _unsetSpeechValue = Object();

@Riverpod(keepAlive: true)
class StudySpeechPlaybackController extends _$StudySpeechPlaybackController {
  @override
  StudySpeechPlaybackState build(int sessionId) {
    final TtsEngineRegistry engineRegistry = ref.read(
      ttsEngineRegistryProvider,
    );
    ref.onDispose(() {
      unawaited(engineRegistry.stopAll());
    });
    return const StudySpeechPlaybackState.initial();
  }

  Future<void> syncCurrentItem({
    required int flashcardId,
    required SpeechCapability speech,
  }) async {
    if (state.activeFlashcardId == flashcardId) {
      return;
    }
    final TtsEngineRegistry engineRegistry = ref.read(
      ttsEngineRegistryProvider,
    );
    await engineRegistry.stopAll();
    state = state.copyWith(
      isBusy: false,
      isPlaying: false,
      activeFlashcardId: flashcardId,
      autoPlayedFlashcardId: null,
      errorMessage: null,
    );
    final bool canAutoPlay =
        speech.available &&
        speech.autoPlay &&
        speech.allowedActions.contains(
          StudySpeechPlaybackConst.playSpeechAction,
        );
    if (!canAutoPlay) {
      return;
    }
    await play(flashcardId: flashcardId, speech: speech, isAutoPlay: true);
  }

  Future<void> play({
    required int flashcardId,
    required SpeechCapability speech,
    bool isAutoPlay = false,
  }) async {
    if (!speech.available || speech.speechText.isEmpty) {
      return;
    }
    state = state.copyWith(
      isBusy: true,
      isPlaying: false,
      activeFlashcardId: flashcardId,
      errorMessage: null,
    );
    final TtsEngineRegistry engineRegistry = ref.read(
      ttsEngineRegistryProvider,
    );
    final String resolvedAdapter = normalizeTtsAdapter(speech.adapter);
    try {
      await engineRegistry.stopAll();
      state = state.copyWith(isBusy: false, isPlaying: true);
      await engineRegistry
          .resolve(resolvedAdapter)
          .speak(
            request: TtsEngineSpeakRequest(
              text: speech.speechText,
              locale: speech.locale,
              voice: speech.voice,
              speed: speech.speed,
              pitch: speech.pitch,
            ),
          );
      state = state.copyWith(
        isBusy: false,
        isPlaying: false,
        errorMessage: null,
      );
      if (isAutoPlay) {
        state = state.copyWith(autoPlayedFlashcardId: flashcardId);
      }
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
}
