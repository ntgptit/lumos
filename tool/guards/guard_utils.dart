import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

const String _dartExtension = '.dart';
const String _generatedExtension = '.g.dart';
const String _freezedExtension = '.freezed.dart';

List<File> collectTrackedDartFiles(List<String> roots) {
  final Set<String> seenPaths = <String>{};
  final List<File> files = <File>[];

  for (final String rootPath in roots) {
    final FileSystemEntityType entityType = FileSystemEntity.typeSync(rootPath);
    if (entityType == FileSystemEntityType.notFound) {
      continue;
    }
    if (entityType == FileSystemEntityType.file) {
      if (!_isTrackedDartFile(rootPath)) {
        continue;
      }
      final String normalizedPath = normalizeGuardPath(rootPath);
      if (!seenPaths.add(normalizedPath)) {
        continue;
      }
      files.add(File(rootPath));
      continue;
    }

    final Directory directory = Directory(rootPath);
    final Iterable<File> nestedFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => _isTrackedDartFile(file.path));
    for (final File file in nestedFiles) {
      final String normalizedPath = normalizeGuardPath(file.path);
      if (!seenPaths.add(normalizedPath)) {
        continue;
      }
      files.add(file);
    }
  }

  return files;
}

String normalizeGuardPath(String path) {
  return path.replaceAll('\\', '/');
}

String lineContentAt(List<String> lines, int lineNumber) {
  if (lineNumber <= 0 || lineNumber > lines.length) {
    return '';
  }
  return lines[lineNumber - 1].trim();
}

bool lineHasMarker({
  required List<String> lines,
  required int lineNumber,
  required String marker,
}) {
  if (lineNumber <= 0 || lineNumber > lines.length) {
    return false;
  }
  return lines[lineNumber - 1].contains(marker);
}

bool nodeHasMarker({
  required AstNode node,
  required List<String> lines,
  required LineInfo lineInfo,
  required String marker,
}) {
  final int startLine = lineInfo.getLocation(node.offset).lineNumber;
  final int endLine = lineInfo.getLocation(node.end).lineNumber;

  for (int lineNumber = startLine; lineNumber <= endLine; lineNumber++) {
    if (lineHasMarker(lines: lines, lineNumber: lineNumber, marker: marker)) {
      return true;
    }
  }

  return false;
}

bool fileHasMarker({required List<String> lines, required String marker}) {
  for (final String line in lines) {
    if (!line.contains(marker)) {
      continue;
    }
    return true;
  }
  return false;
}

bool _isTrackedDartFile(String path) {
  if (!path.endsWith(_dartExtension)) {
    return false;
  }
  if (path.endsWith(_generatedExtension)) {
    return false;
  }
  if (path.endsWith(_freezedExtension)) {
    return false;
  }
  return true;
}
