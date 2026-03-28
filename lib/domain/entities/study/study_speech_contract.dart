import 'package:flutter/foundation.dart';
import 'package:lumos/core/utils/string_utils.dart';

const String studySpeechAdapterFlutterTts = 'FLUTTER_TTS';
const String studySpeechVoiceUnspecified = '';
const List<String> supportedTtsAdapters = <String>[
  studySpeechAdapterFlutterTts,
];
const List<double> supportedTtsSpeeds = <double>[0.5, 0.75, 1, 1.25, 1.5];
const List<double> supportedTtsPitches = <double>[0.8, 1, 1.2];

@immutable
class TtsVoiceOption {
  const TtsVoiceOption({required this.id, required this.label});

  final String id;
  final String label;
}

String normalizeTtsAdapter(String adapter) {
  final normalized = StringUtils.normalizeUpper(adapter);
  if (supportedTtsAdapters.contains(normalized)) {
    return normalized;
  }
  return studySpeechAdapterFlutterTts;
}

double normalizeTtsSpeed(double value) {
  return _closestValue(value: value, supportedValues: supportedTtsSpeeds);
}

double normalizeTtsPitch(double value) {
  return _closestValue(value: value, supportedValues: supportedTtsPitches);
}

double _closestValue({
  required double value,
  required List<double> supportedValues,
}) {
  if (supportedValues.isEmpty) {
    return value;
  }

  var closest = supportedValues.first;
  var minDistance = (closest - value).abs();

  for (final candidate in supportedValues.skip(1)) {
    final distance = (candidate - value).abs();
    if (distance >= minDistance) {
      continue;
    }
    closest = candidate;
    minDistance = distance;
  }

  return closest;
}
