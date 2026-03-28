import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/services/text_to_speech_service.dart';

void main() {
  group('NoopTextToSpeechService', () {
    test('speak completes without throwing', () async {
      const NoopTextToSpeechService service = NoopTextToSpeechService();

      await service.speak('hello', locale: 'en-US');
    });

    test('stop completes without throwing', () async {
      const NoopTextToSpeechService service = NoopTextToSpeechService();

      await service.stop();
    });
  });
}
