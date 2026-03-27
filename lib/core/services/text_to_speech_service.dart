abstract interface class TextToSpeechService {
  Future<void> speak(String text, {String? locale});

  Future<void> stop();
}

class NoopTextToSpeechService implements TextToSpeechService {
  const NoopTextToSpeechService();

  @override
  Future<void> speak(String text, {String? locale}) async {}

  @override
  Future<void> stop() async {}
}
