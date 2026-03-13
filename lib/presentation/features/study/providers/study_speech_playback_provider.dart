import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
FlutterTts studySpeechEngine(Ref ref) {
  final FlutterTts speechEngine = FlutterTts();
  ref.onDispose(() {
    unawaited(speechEngine.stop());
  });
  return speechEngine;
}

@Riverpod(keepAlive: true)
class StudySpeechPlaybackController extends _$StudySpeechPlaybackController {
  @override
  StudySpeechPlaybackState build(int sessionId) {
    final FlutterTts speechEngine = ref.watch(studySpeechEngineProvider);
    speechEngine.setStartHandler(() {
      state = state.copyWith(
        isBusy: false,
        isPlaying: true,
        errorMessage: null,
      );
    });
    speechEngine.setCompletionHandler(() {
      state = state.copyWith(
        isBusy: false,
        isPlaying: false,
        errorMessage: null,
      );
    });
    speechEngine.setCancelHandler(() {
      state = state.copyWith(isBusy: false, isPlaying: false);
    });
    speechEngine.setErrorHandler((dynamic message) {
      state = state.copyWith(
        isBusy: false,
        isPlaying: false,
        errorMessage: message?.toString(),
      );
    });
    ref.onDispose(() {
      unawaited(speechEngine.stop());
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
    final FlutterTts speechEngine = ref.read(studySpeechEngineProvider);
    await speechEngine.stop();
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
    final FlutterTts speechEngine = ref.read(studySpeechEngineProvider);
    try {
      await speechEngine.awaitSpeakCompletion(true);
      await speechEngine.setLanguage(speech.locale);
      await speechEngine.setSpeechRate(speech.speed / 2);
      await speechEngine.setVoice(<String, String>{
        'name': speech.voice,
        'locale': speech.locale,
      });
      await speechEngine.speak(speech.speechText);
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
    final FlutterTts speechEngine = ref.read(studySpeechEngineProvider);
    await speechEngine.stop();
    state = state.copyWith(isBusy: false, isPlaying: false);
  }
}
