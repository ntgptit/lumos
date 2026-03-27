import 'package:flutter/foundation.dart';

@immutable
class PickedFileData {
  const PickedFileData({
    required this.name,
    this.path,
    this.bytes,
    this.mimeType,
  });

  final String name;
  final String? path;
  final Uint8List? bytes;
  final String? mimeType;
}

abstract interface class FilePickerService {
  Future<PickedFileData?> pickSingle({List<String>? allowedExtensions});
}

class NoopFilePickerService implements FilePickerService {
  const NoopFilePickerService();

  @override
  Future<PickedFileData?> pickSingle({List<String>? allowedExtensions}) async {
    return null;
  }
}
