import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/core/speech/providers/tts_engine_registry_provider.dart';
import 'package:lumos/core/speech/tts_engine.dart';
import 'package:lumos/core/speech/tts_engine_registry.dart';
import 'package:lumos/core/speech/tts_engine_speak_request.dart';
import 'package:lumos/core/speech/tts_voice_option.dart';
import 'package:lumos/data/repositories/profile/profile_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/profile/screens/profile_content.dart';

import '../../../../testkit/feature_fixtures.dart';

class _FakeTtsEngine implements TtsEngine {
  _FakeTtsEngine({required this.voiceOptions});

  final List<TtsVoiceOption> voiceOptions;
  TtsEngineSpeakRequest? lastSpeakRequest;
  int stopCallCount = 0;

  @override
  Future<List<TtsVoiceOption>> getAvailableVoices({String? locale}) async {
    return voiceOptions;
  }

  @override
  Future<void> speak({required TtsEngineSpeakRequest request}) async {
    lastSpeakRequest = request;
  }

  @override
  Future<void> stop() async {
    stopCallCount += 1;
  }
}

void main() {
  group('ProfileContent', () {
    testWidgets(
      'keeps device default voice selected when persisted voice is unspecified',
      (WidgetTester tester) async {
        final _FakeTtsEngine speechEngine = _FakeTtsEngine(
          voiceOptions: const <TtsVoiceOption>[
            TtsVoiceOption(
              id: 'Google 한국의',
              label: 'Google 한국의',
              locale: 'ko-KR',
            ),
          ],
        );
        await tester.pumpWidget(
          _buildProfileContent(
            profileRepository: FakeProfileRepository(),
            speechEngine: speechEngine,
          ),
        );

        await tester.pumpAndSettle();

        final DropdownButtonFormField<String> voiceDropdown =
            _findStringDropdownByLabel(tester, 'Voice');
        expect(voiceDropdown.initialValue, studySpeechVoiceUnspecified);
        expect(find.text('Device default voice'), findsOneWidget);
      },
    );

    testWidgets(
      'keeps persisted voice selected when the device exposes that voice',
      (WidgetTester tester) async {
        final _FakeTtsEngine speechEngine = _FakeTtsEngine(
          voiceOptions: const <TtsVoiceOption>[
            TtsVoiceOption(
              id: 'Google 한국의',
              label: 'Google 한국의',
              locale: 'ko-KR',
            ),
          ],
        );
        await tester.pumpWidget(
          _buildProfileContent(
            profileRepository: FakeProfileRepository(
              profile: sampleProfileData().copyWith(
                speechPreference: sampleSpeechPreference().copyWith(
                  voice: 'Google 한국의',
                ),
              ),
            ),
            speechEngine: speechEngine,
          ),
        );

        await tester.pumpAndSettle();

        final DropdownButtonFormField<String> voiceDropdown =
            _findStringDropdownByLabel(tester, 'Voice');
        expect(voiceDropdown.initialValue, 'Google 한국의');
      },
    );

    testWidgets(
      'plays preview with the current speech preference and default sample text',
      (WidgetTester tester) async {
        final _FakeTtsEngine speechEngine = _FakeTtsEngine(
          voiceOptions: const <TtsVoiceOption>[
            TtsVoiceOption(
              id: 'Google 한국의',
              label: 'Google 한국의',
              locale: 'ko-KR',
            ),
          ],
        );
        await tester.pumpWidget(
          _buildProfileContent(
            profileRepository: FakeProfileRepository(
              profile: sampleProfileData().copyWith(
                speechPreference: sampleSpeechPreference().copyWith(
                  voice: 'Google 한국의',
                  pitch: 1.2,
                ),
              ),
            ),
            speechEngine: speechEngine,
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Pitch'), findsOneWidget);
        expect(find.textContaining('안녕하세요.'), findsOneWidget);

        await tester.ensureVisible(find.text('Play preview'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Play preview'));
        await tester.pumpAndSettle();

        expect(speechEngine.lastSpeakRequest, isNotNull);
        expect(speechEngine.lastSpeakRequest!.voice, 'Google 한국의');
        expect(speechEngine.lastSpeakRequest!.pitch, 1.2);
        expect(speechEngine.lastSpeakRequest!.text, contains('안녕하세요.'));
      },
    );
  });
}

Widget _buildProfileContent({
  required FakeProfileRepository profileRepository,
  required _FakeTtsEngine speechEngine,
}) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(profileRepository),
      ttsEngineRegistryProvider.overrideWithValue(
        TtsEngineRegistry(
          engines: <String, TtsEngine>{
            studySpeechAdapterFlutterTts: speechEngine,
          },
        ),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: ProfileContent()),
    ),
  );
}

DropdownButtonFormField<String> _findStringDropdownByLabel(
  WidgetTester tester,
  String labelText,
) {
  final Iterable<DropdownButtonFormField<String>> dropdowns = tester
      .widgetList<DropdownButtonFormField<String>>(
        find.byWidgetPredicate((Widget widget) {
          if (widget is! DropdownButtonFormField<String>) {
            return false;
          }
          return widget.decoration.labelText == labelText;
        }),
      );
  return dropdowns.single;
}
