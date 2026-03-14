import '../../domain/entities/study/study_speech_contract.dart';

const List<String> supportedTtsAdapters = <String>[
  studySpeechAdapterFlutterTts,
];
const List<double> supportedTtsSpeeds = <double>[0.8, 1.0, 1.2, 1.5];
const List<double> supportedTtsPitches = <double>[0.8, 1.0, 1.2, 1.5];

String normalizeTtsAdapter(String? adapter) {
  if (adapter != null && supportedTtsAdapters.contains(adapter)) {
    return adapter;
  }
  return studySpeechAdapterFlutterTts;
}

double normalizeTtsSpeed(double? speed) {
  if (speed != null && supportedTtsSpeeds.contains(speed)) {
    return speed;
  }
  return 1.0;
}

double normalizeTtsPitch(double? pitch) {
  if (pitch != null && supportedTtsPitches.contains(pitch)) {
    return pitch;
  }
  return 1.0;
}
