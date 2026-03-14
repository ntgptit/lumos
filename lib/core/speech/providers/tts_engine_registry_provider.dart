import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/study/study_speech_contract.dart';
import '../flutter_tts_engine.dart';
import '../tts_engine.dart';
import '../tts_engine_registry.dart';

part 'tts_engine_registry_provider.g.dart';

@Riverpod(keepAlive: true)
TtsEngineRegistry ttsEngineRegistry(Ref ref) {
  final FlutterTts speechEngine = FlutterTts();
  final TtsEngineRegistry registry = TtsEngineRegistry(
    engines: <String, TtsEngine>{
      studySpeechAdapterFlutterTts: FlutterTtsEngine(
        speechEngine: speechEngine,
      ),
    },
  );
  ref.onDispose(() {
    unawaited(registry.stopAll());
  });
  return registry;
}
