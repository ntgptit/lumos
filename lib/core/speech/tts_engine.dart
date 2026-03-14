import 'tts_engine_speak_request.dart';
import 'tts_voice_option.dart';

abstract class TtsEngine {
  Future<void> speak({required TtsEngineSpeakRequest request});

  Future<List<TtsVoiceOption>> getAvailableVoices({String? locale});

  Future<void> stop();
}
