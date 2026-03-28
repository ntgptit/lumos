import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';

void main() {
  group('study speech contract helpers', () {
    test('normalizes unknown adapter to flutter tts', () {
      expect(normalizeTtsAdapter('UNKNOWN'), studySpeechAdapterFlutterTts);
      expect(
        normalizeTtsAdapter('flutter_tts'),
        studySpeechAdapterFlutterTts,
      );
    });

    test('voice unspecified stays empty', () {
      expect(studySpeechVoiceUnspecified, isEmpty);
    });

    test('normalizes speed and pitch to the nearest supported values', () {
      expect(normalizeTtsSpeed(1.2), 1.25);
      expect(normalizeTtsSpeed(1.28), 1.25);
      expect(normalizeTtsPitch(0.78), 0.8);
      expect(normalizeTtsPitch(1.11), 1.2);
    });
  });
}
