abstract interface class AudioService {
  Future<void> play(String source);

  Future<void> pause();

  Future<void> stop();
}

class NoopAudioService implements AudioService {
  const NoopAudioService();

  @override
  Future<void> play(String source) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> stop() async {}
}
