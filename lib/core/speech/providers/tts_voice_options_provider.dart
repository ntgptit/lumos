import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../tts_engine_catalog.dart';
import '../tts_engine_registry.dart';
import '../tts_voice_option.dart';
import 'tts_engine_registry_provider.dart';

part 'tts_voice_options_provider.g.dart';

const String _ttsVoiceOptionsProviderLogTag = '[TtsVoiceOptionsProvider]';

@Riverpod(keepAlive: true)
Future<List<TtsVoiceOption>> ttsVoiceOptions(
  Ref ref,
  String adapter,
  String locale,
) async {
  final String resolvedAdapter = normalizeTtsAdapter(adapter);
  final TtsEngineRegistry engineRegistry = ref.watch(ttsEngineRegistryProvider);
  final List<TtsVoiceOption> voiceOptions = await engineRegistry
      .resolve(resolvedAdapter)
      .getAvailableVoices(locale: locale);
  _logVoiceOptions(
    'adapter=$adapter resolvedAdapter=$resolvedAdapter locale=$locale count=${voiceOptions.length} preview=${_previewVoiceOptions(voiceOptions)}',
  );
  if (voiceOptions.isNotEmpty) {
    return voiceOptions;
  }
  return const <TtsVoiceOption>[];
}

void _logVoiceOptions(String message) {
  if (!kDebugMode) {
    return;
  }
  debugPrint('$_ttsVoiceOptionsProviderLogTag $message');
}

String _previewVoiceOptions(List<TtsVoiceOption> voiceOptions) {
  if (voiceOptions.isEmpty) {
    return '[]';
  }
  return voiceOptions
      .take(3)
      .map((TtsVoiceOption option) => '${option.id}(${option.locale})')
      .join(', ');
}
