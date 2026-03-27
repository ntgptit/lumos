abstract final class FileUtils {
  static String fileName(String path) {
    final segments = path.split(RegExp(r'[\\/]'));
    return segments.isEmpty ? path : segments.last;
  }

  static String fileNameWithoutExtension(String path) {
    final name = fileName(path);
    final index = name.lastIndexOf('.');
    if (index <= 0) {
      return name;
    }
    return name.substring(0, index);
  }

  static String extension(String path) {
    final name = fileName(path);
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) {
      return '';
    }

    return name.substring(index + 1).toLowerCase();
  }

  static bool hasExtension(String path, String expected) {
    return extension(path) == expected.toLowerCase().replaceFirst('.', '');
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
