import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../utils/string_utils.dart';
import 'tts_engine.dart';
import 'tts_engine_speak_request.dart';
import 'tts_voice_option.dart';

const int _defaultVoiceDiscoveryMaxAttempts = 4;
const Duration _defaultVoiceDiscoveryRetryDelay = Duration(milliseconds: 150);
const String _flutterTtsEngineLogTag = '[FlutterTtsEngine]';

class FlutterTtsEngine implements TtsEngine {
  FlutterTtsEngine({
    required FlutterTts speechEngine,
    int voiceDiscoveryMaxAttempts = _defaultVoiceDiscoveryMaxAttempts,
    Duration voiceDiscoveryRetryDelay = _defaultVoiceDiscoveryRetryDelay,
  }) : _speechEngine = speechEngine,
       _voiceDiscoveryMaxAttempts = voiceDiscoveryMaxAttempts,
       _voiceDiscoveryRetryDelay = voiceDiscoveryRetryDelay;

  final FlutterTts _speechEngine;
  final int _voiceDiscoveryMaxAttempts;
  final Duration _voiceDiscoveryRetryDelay;

  @override
  Future<void> speak({required TtsEngineSpeakRequest request}) async {
    await _speechEngine.awaitSpeakCompletion(true);
    await _speechEngine.setLanguage(request.locale);
    await _speechEngine.setSpeechRate(request.speed / 2);
    await _speechEngine.setPitch(request.pitch);
    final TtsVoiceOption? selectedVoice = await _resolveVoiceOption(
      voiceId: request.voice,
      locale: request.locale,
    );
    if (selectedVoice != null) {
      await _speechEngine.setVoice(<String, String>{
        'name': selectedVoice.id,
        'locale': selectedVoice.locale,
      });
    }
    await _speechEngine.speak(request.text);
  }

  @override
  Future<List<TtsVoiceOption>> getAvailableVoices({String? locale}) async {
    try {
      final List<TtsVoiceOption> voiceOptions = await _discoverVoiceOptions();
      if (locale == null || locale.isEmpty) {
        _logDebug(
          'getAvailableVoices locale=<all> count=${voiceOptions.length} preview=${_previewVoiceOptions(voiceOptions)}',
        );
        return voiceOptions;
      }
      final List<TtsVoiceOption> localizedVoiceOptions = voiceOptions
          .where(
            (TtsVoiceOption option) => _matchesLocale(option.locale, locale),
          )
          .toList(growable: false);
      if (localizedVoiceOptions.isNotEmpty) {
        _logDebug(
          'getAvailableVoices locale=$locale localizedCount=${localizedVoiceOptions.length} preview=${_previewVoiceOptions(localizedVoiceOptions)}',
        );
        return localizedVoiceOptions;
      }
      _logDebug(
        'getAvailableVoices locale=$locale fallbackToAll count=${voiceOptions.length} preview=${_previewVoiceOptions(voiceOptions)}',
      );
      return voiceOptions;
    } on Object catch (error, stackTrace) {
      _logDebug(
        'getAvailableVoices locale=$locale failed error=$error stack=${StringUtils.firstLine(stackTrace.toString())}',
      );
      return const <TtsVoiceOption>[];
    }
  }

  @override
  Future<void> stop() async {
    await _speechEngine.stop();
  }

  Future<TtsVoiceOption?> _resolveVoiceOption({
    required String? voiceId,
    required String locale,
  }) async {
    final String normalizedVoiceId = StringUtils.normalizeName(voiceId ?? '');
    if (normalizedVoiceId.isEmpty) {
      return null;
    }
    final List<TtsVoiceOption> voiceOptions = await getAvailableVoices(
      locale: locale,
    );
    for (final TtsVoiceOption option in voiceOptions) {
      if (option.id == normalizedVoiceId) {
        return option;
      }
    }
    return null;
  }

  Future<List<TtsVoiceOption>> _discoverVoiceOptions() async {
    for (int attempt = 0; attempt < _voiceDiscoveryMaxAttempts; attempt++) {
      final dynamic rawVoices = await _speechEngine.getVoices;
      final List<TtsVoiceOption> voiceOptions = _mapVoiceOptions(rawVoices);
      _logDebug(
        'discover attempt=${attempt + 1}/$_voiceDiscoveryMaxAttempts rawType=${rawVoices.runtimeType} count=${voiceOptions.length} preview=${_previewVoiceOptions(voiceOptions)}',
      );
      if (voiceOptions.isNotEmpty) {
        return voiceOptions;
      }
      final bool isLastAttempt = attempt == _voiceDiscoveryMaxAttempts - 1;
      if (isLastAttempt) {
        return const <TtsVoiceOption>[];
      }
      await Future<void>.delayed(_voiceDiscoveryRetryDelay);
    }
    return const <TtsVoiceOption>[];
  }

  List<TtsVoiceOption> _mapVoiceOptions(dynamic rawVoices) {
    if (rawVoices is! List) {
      return const <TtsVoiceOption>[];
    }
    final Map<String, TtsVoiceOption> uniqueVoiceOptions =
        <String, TtsVoiceOption>{};
    for (final dynamic rawVoice in rawVoices) {
      final TtsVoiceOption? option = _mapVoiceOption(rawVoice);
      if (option == null) {
        continue;
      }
      uniqueVoiceOptions.putIfAbsent(
        '${option.locale}::${option.id}',
        () => option,
      );
    }
    final List<TtsVoiceOption> voiceOptions = uniqueVoiceOptions.values.toList(
      growable: false,
    );
    voiceOptions.sort(_compareVoiceOptions);
    return voiceOptions;
  }

  TtsVoiceOption? _mapVoiceOption(dynamic rawVoice) {
    if (rawVoice is! Map) {
      return null;
    }
    final String name = rawVoice['name']?.toString() ?? '';
    final String locale = _normalizeLocale(
      rawVoice['locale']?.toString() ?? '',
    );
    if (name.isEmpty || locale.isEmpty) {
      return null;
    }
    final String gender = rawVoice['gender']?.toString() ?? '';
    final String quality = rawVoice['quality']?.toString() ?? '';
    final List<String> labelParts = <String>[name];
    if (gender.isNotEmpty) {
      labelParts.add(gender);
    }
    if (quality.isNotEmpty) {
      labelParts.add(quality);
    }
    return TtsVoiceOption(
      id: name,
      label: labelParts.join(' · '),
      locale: locale,
    );
  }

  int _compareVoiceOptions(TtsVoiceOption left, TtsVoiceOption right) {
    final int localeComparison = StringUtils.compareNormalizedLower(
      left.locale,
      right.locale,
    );
    if (localeComparison != 0) {
      return localeComparison;
    }
    return StringUtils.compareNormalizedLower(left.label, right.label);
  }

  bool _matchesLocale(String voiceLocale, String targetLocale) {
    final String normalizedVoiceLocale = _normalizeLocale(voiceLocale);
    final String normalizedTargetLocale = _normalizeLocale(targetLocale);
    if (normalizedVoiceLocale.isEmpty || normalizedTargetLocale.isEmpty) {
      return false;
    }
    if (StringUtils.normalizeLower(normalizedVoiceLocale) ==
        StringUtils.normalizeLower(normalizedTargetLocale)) {
      return true;
    }
    return _extractLanguageCode(normalizedVoiceLocale) ==
        _extractLanguageCode(normalizedTargetLocale);
  }

  String _normalizeLocale(String rawLocale) {
    return StringUtils.normalizeLocaleTag(rawLocale);
  }

  String _extractLanguageCode(String locale) {
    return StringUtils.localeLanguageCode(locale);
  }

  void _logDebug(String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint('$_flutterTtsEngineLogTag $message');
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
}
