import 'dart:io';

class FeatureScreenWidgetCompositeBoundaryConst {
  const FeatureScreenWidgetCompositeBoundaryConst._();

  static const String featuresRoot = 'lib/presentation/features/';
  static const String screensWidgetsMarker = '/screens/widgets/';
  static const String dartExtension = '.dart';
  static const String generatedExtension = '.g.dart';
  static const String freezedExtension = '.freezed.dart';
  static const String importPrefix = 'import ';
  static const String sharedPrimitivesImportPrefix =
      'package:lumos/presentation/shared/primitives/';
  static const String sharedPrimitivesRelativeMarker =
      'presentation/shared/primitives/';
}

class FeatureScreenWidgetCompositeBoundaryViolation {
  const FeatureScreenWidgetCompositeBoundaryViolation({
    required this.filePath,
    required this.lineNumber,
    required this.reason,
    required this.lineContent,
  });

  final String filePath;
  final int lineNumber;
  final String reason;
  final String lineContent;
}

Future<void> main() async {
  final Directory featuresRoot = Directory(
    FeatureScreenWidgetCompositeBoundaryConst.featuresRoot,
  );
  if (!featuresRoot.existsSync()) {
    stderr.writeln(
      'Missing `${FeatureScreenWidgetCompositeBoundaryConst.featuresRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<FeatureScreenWidgetCompositeBoundaryViolation> violations =
      _collectViolations(featuresRoot: featuresRoot);
  if (violations.isEmpty) {
    stdout.writeln('Feature screen widget composite boundary contract passed.');
    return;
  }

  stderr.writeln('Feature screen widget composite boundary contract failed.');
  for (final FeatureScreenWidgetCompositeBoundaryViolation violation
      in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

List<FeatureScreenWidgetCompositeBoundaryViolation> _collectViolations({
  required Directory featuresRoot,
}) {
  final List<FeatureScreenWidgetCompositeBoundaryViolation> violations =
      <FeatureScreenWidgetCompositeBoundaryViolation>[];
  final List<File> files = _collectSourceFiles(root: featuresRoot);

  for (final File file in files) {
    final String normalizedPath = _normalizePath(file.path);
    if (!_isFeatureScreenWidgetPath(normalizedPath)) {
      continue;
    }

    final List<String> lines = file.readAsLinesSync();
    for (int index = 0; index < lines.length; index++) {
      final String rawLine = lines[index];
      final String line = _stripLineComment(rawLine).trim();
      if (!line.startsWith(FeatureScreenWidgetCompositeBoundaryConst.importPrefix)) {
        continue;
      }
      if (!_isSharedPrimitiveImport(line)) {
        continue;
      }
      violations.add(
        FeatureScreenWidgetCompositeBoundaryViolation(
          filePath: normalizedPath,
          lineNumber: index + 1,
          reason:
              'Feature `screens/widgets` files must depend on '
              '`lib/presentation/shared/composites/**` instead of direct '
              '`lib/presentation/shared/primitives/**` imports.',
          lineContent: rawLine.trim(),
        ),
      );
    }
  }

  return violations;
}

List<File> _collectSourceFiles({required Directory root}) {
  final List<File> files = <File>[];
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }
    final String path = _normalizePath(entity.path);
    if (!path.endsWith(FeatureScreenWidgetCompositeBoundaryConst.dartExtension)) {
      continue;
    }
    if (path.endsWith(
      FeatureScreenWidgetCompositeBoundaryConst.generatedExtension,
    )) {
      continue;
    }
    if (path.endsWith(
      FeatureScreenWidgetCompositeBoundaryConst.freezedExtension,
    )) {
      continue;
    }
    files.add(entity);
  }
  return files;
}

bool _isFeatureScreenWidgetPath(String normalizedPath) {
  if (!normalizedPath.startsWith(
    FeatureScreenWidgetCompositeBoundaryConst.featuresRoot,
  )) {
    return false;
  }
  return normalizedPath.contains(
    FeatureScreenWidgetCompositeBoundaryConst.screensWidgetsMarker,
  );
}

bool _isSharedPrimitiveImport(String line) {
  if (line.contains(
    FeatureScreenWidgetCompositeBoundaryConst.sharedPrimitivesImportPrefix,
  )) {
    return true;
  }
  return line.contains(
    FeatureScreenWidgetCompositeBoundaryConst.sharedPrimitivesRelativeMarker,
  );
}

String _normalizePath(String path) {
  return path.replaceAll('\\', '/');
}

String _stripLineComment(String line) {
  final int commentIndex = line.indexOf('//');
  if (commentIndex < 0) {
    return line;
  }
  return line.substring(0, commentIndex);
}
