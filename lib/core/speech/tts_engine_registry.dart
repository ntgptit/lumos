import 'tts_engine.dart';
import 'tts_engine_catalog.dart';

class TtsEngineRegistry {
  const TtsEngineRegistry({required Map<String, TtsEngine> engines})
    : _engines = engines;

  final Map<String, TtsEngine> _engines;

  TtsEngine resolve(String adapter) {
    final String resolvedAdapter = normalizeTtsAdapter(adapter);
    final TtsEngine? engine = _engines[resolvedAdapter];
    if (engine != null) {
      return engine;
    }
    final TtsEngine? fallbackEngine = _engines[normalizeTtsAdapter(null)];
    if (fallbackEngine != null) {
      return fallbackEngine;
    }
    throw StateError('No TTS engine is registered for adapter: $adapter');
  }

  Future<void> stopAll() async {
    for (final TtsEngine engine in _engines.values) {
      await engine.stop();
    }
  }
}
