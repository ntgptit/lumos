import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lumos/core/speech/flutter_tts_engine.dart';
import 'package:lumos/core/speech/tts_engine_speak_request.dart';

class _FakeFlutterTts extends FlutterTts {
  _FakeFlutterTts({required List<dynamic> voiceResponses})
    : _voiceResponses = Queue<dynamic>.from(voiceResponses);

  final Queue<dynamic> _voiceResponses;
  int getVoicesCallCount = 0;
  double? lastSpeechRate;
  double? lastPitch;
  String? lastLanguage;
  Map<String, String>? lastVoice;
  String? lastSpokenText;

  @override
  Future<dynamic> awaitSpeakCompletion(bool awaitCompletion) async {}

  @override
  Future<dynamic> get getVoices async {
    getVoicesCallCount++;
    if (_voiceResponses.isEmpty) {
      return const <Map<String, String>>[];
    }
    if (_voiceResponses.length == 1) {
      return _voiceResponses.first;
    }
    return _voiceResponses.removeFirst();
  }

  @override
  Future<dynamic> setLanguage(String language) async {
    lastLanguage = language;
  }

  @override
  Future<dynamic> setSpeechRate(double rate) async {
    lastSpeechRate = rate;
  }

  @override
  Future<dynamic> setPitch(double pitch) async {
    lastPitch = pitch;
  }

  @override
  Future<dynamic> setVoice(Map<String, String> voice) async {
    lastVoice = voice;
  }

  @override
  Future<dynamic> speak(String text, {bool focus = false}) async {
    lastSpokenText = text;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterTtsEngine', () {
    test('retries voice discovery when the first lookup is empty', () async {
      final _FakeFlutterTts speechEngine = _FakeFlutterTts(
        voiceResponses: <dynamic>[
          const <Map<String, String>>[],
          <Map<String, String>>[
            const <String, String>{'name': 'Korean Voice', 'locale': 'ko-KR'},
          ],
        ],
      );
      final FlutterTtsEngine engine = FlutterTtsEngine(
        speechEngine: speechEngine,
        voiceDiscoveryRetryDelay: Duration.zero,
      );

      final voices = await engine.getAvailableVoices(locale: 'ko-KR');

      expect(voices, hasLength(1));
      expect(voices.first.id, 'Korean Voice');
      expect(speechEngine.getVoicesCallCount, 2);
    });

    test('matches locale tags with different separators', () async {
      final _FakeFlutterTts speechEngine = _FakeFlutterTts(
        voiceResponses: <dynamic>[
          <Map<String, String>>[
            const <String, String>{'name': 'Korean Voice', 'locale': 'ko_KR'},
          ],
        ],
      );
      final FlutterTtsEngine engine = FlutterTtsEngine(
        speechEngine: speechEngine,
        voiceDiscoveryRetryDelay: Duration.zero,
      );

      final voices = await engine.getAvailableVoices(locale: 'ko-KR');

      expect(voices, hasLength(1));
      expect(voices.first.locale, 'ko-KR');
    });

    test(
      'falls back to device voices when locale filtering has no match',
      () async {
        final _FakeFlutterTts speechEngine = _FakeFlutterTts(
          voiceResponses: <dynamic>[
            <Map<String, String>>[
              const <String, String>{
                'name': 'English Voice',
                'locale': 'en-US',
              },
            ],
          ],
        );
        final FlutterTtsEngine engine = FlutterTtsEngine(
          speechEngine: speechEngine,
          voiceDiscoveryRetryDelay: Duration.zero,
        );

        final voices = await engine.getAvailableVoices(locale: 'ko-KR');

        expect(voices, hasLength(1));
        expect(voices.first.id, 'English Voice');
      },
    );

    test('applies pitch and the selected voice before speaking', () async {
      final _FakeFlutterTts speechEngine = _FakeFlutterTts(
        voiceResponses: <dynamic>[
          <Map<String, String>>[
            const <String, String>{'name': 'Korean Voice', 'locale': 'ko-KR'},
          ],
        ],
      );
      final FlutterTtsEngine engine = FlutterTtsEngine(
        speechEngine: speechEngine,
        voiceDiscoveryRetryDelay: Duration.zero,
      );

      await engine.speak(
        request: const TtsEngineSpeakRequest(
          text: '안녕하세요',
          locale: 'ko-KR',
          voice: 'Korean Voice',
          speed: 1.2,
          pitch: 1.1,
        ),
      );

      expect(speechEngine.lastLanguage, 'ko-KR');
      expect(speechEngine.lastSpeechRate, 0.6);
      expect(speechEngine.lastPitch, 1.1);
      expect(speechEngine.lastVoice, <String, String>{
        'name': 'Korean Voice',
        'locale': 'ko-KR',
      });
      expect(speechEngine.lastSpokenText, '안녕하세요');
    });
  });
}
