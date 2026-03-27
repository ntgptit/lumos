abstract interface class ShareService {
  Future<void> shareText(String text, {String? subject});
}

class NoopShareService implements ShareService {
  const NoopShareService();

  @override
  Future<void> shareText(String text, {String? subject}) async {}
}
