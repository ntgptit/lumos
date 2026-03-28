import 'package:lumos/core/utils/string_utils.dart';

abstract final class FileUtils {
  static String fileName(String path) {
    final segments = StringUtils.splitByPattern(path, RegExp(r'[\\/]'));
    return segments.isEmpty ? path : segments.last;
  }

  static String fileNameWithoutExtension(String path) {
    final name = fileName(path);
    final index = name.lastIndexOf('.');
    if (index <= 0) {
      return name;
    }
    return StringUtils.prefix(name, index);
  }

  static String extension(String path) {
    final name = fileName(path);
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) {
      return '';
    }

    return StringUtils.normalizeLower(StringUtils.suffix(name, index + 1));
  }

  static bool hasExtension(String path, String expected) {
    return extension(path) ==
        StringUtils.normalizeLower(expected).replaceFirst('.', '');
  }

  static bool isImageFile(String path) {
    return const {
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
    }.contains(extension(path));
  }
}
