class TtsEngineSpeakRequest {
  const TtsEngineSpeakRequest({
    required this.text,
    required this.locale,
    required this.voice,
    required this.speed,
    required this.pitch,
  });

  final String text;
  final String locale;
  final String? voice;
  final double speed;
  final double pitch;
}
