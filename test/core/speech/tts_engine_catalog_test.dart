import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/speech/tts_engine_catalog.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';

void main() {
  group('tts engine catalog', () {
    test('normalizes unknown adapter to flutter tts', () {
      expect(normalizeTtsAdapter('UNKNOWN'), studySpeechAdapterFlutterTts);
      expect(normalizeTtsAdapter(null), studySpeechAdapterFlutterTts);
    });

    test('voice unspecified stays empty until device voices are loaded', () {
      expect(studySpeechVoiceUnspecified, isEmpty);
    });

    test('normalizes unsupported speed and pitch to defaults', () {
      expect(normalizeTtsSpeed(1.2), 1.2);
      expect(normalizeTtsSpeed(1.3), 1.0);
      expect(normalizeTtsPitch(1.5), 1.5);
      expect(normalizeTtsPitch(1.7), 1.0);
    });
  });
}
