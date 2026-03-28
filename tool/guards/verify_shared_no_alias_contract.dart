import 'dart:io';

class SharedNoAliasGuardConst {
  const SharedNoAliasGuardConst._();

  static const String sharedRoot = 'lib/presentation/shared';
  static const String dartExtension = '.dart';
  static const String generatedExtension = '.g.dart';
  static const String freezedExtension = '.freezed.dart';
  static const String exportPrefix = 'export ';
  static const String typedefPrefix = 'typedef ';
  static const String sharedRootLabel = 'lib/presentation/shared/**';
  static const String legacySharedRootLabel =
      'lib/presentation/shared/widgets/**';
}

class SharedNoAliasViolation {
  const SharedNoAliasViolation({
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
  final Directory sharedRoot = Directory(SharedNoAliasGuardConst.sharedRoot);
  if (!sharedRoot.existsSync()) {
    stderr.writeln('Missing `${SharedNoAliasGuardConst.sharedRoot}` directory.');
    exitCode = 1;
    return;
  }

  final List<SharedNoAliasViolation> violations = _collectViolations(
    sharedRoot: sharedRoot,
  );
  if (violations.isEmpty) {
    stdout.writeln('Shared no-alias contract passed.');
    return;
  }

  stderr.writeln('Shared no-alias contract failed.');
  for (final SharedNoAliasViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

List<SharedNoAliasViolation> _collectViolations({
  required Directory sharedRoot,
}) {
  final List<SharedNoAliasViolation> violations = <SharedNoAliasViolation>[];
  final List<File> files = _collectSourceFiles(sharedRoot);

  for (final File file in files) {
    final String path = _normalizePath(file.path);
    final List<String> lines = file.readAsLinesSync();
    for (int index = 0; index < lines.length; index++) {
      final String rawLine = lines[index];
      final String sourceLine = _stripLineComment(rawLine).trim();
      if (sourceLine.isEmpty) {
        continue;
      }
      if (sourceLine.startsWith(SharedNoAliasGuardConst.exportPrefix)) {
        violations.add(
          SharedNoAliasViolation(
            filePath: path,
            lineNumber: index + 1,
            reason:
                'Shared API surface must not use `export` aliasing. '
                'Define concrete shared types under '
                '`${SharedNoAliasGuardConst.sharedRootLabel}` instead of '
                'reintroducing `${SharedNoAliasGuardConst.legacySharedRootLabel}` '
                'or any other compat layer.',
            lineContent: rawLine.trim(),
          ),
        );
      }
      if (sourceLine.startsWith(SharedNoAliasGuardConst.typedefPrefix)) {
        violations.add(
          SharedNoAliasViolation(
            filePath: path,
            lineNumber: index + 1,
            reason:
                'Shared API surface must not use `typedef` aliasing. '
                'Create a concrete shared type under '
                '`${SharedNoAliasGuardConst.sharedRootLabel}`.',
            lineContent: rawLine.trim(),
          ),
        );
      }
    }
  }

  return violations;
}

List<File> _collectSourceFiles(Directory root) {
  final List<File> files = <File>[];
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }
    final String path = _normalizePath(entity.path);
    if (!path.endsWith(SharedNoAliasGuardConst.dartExtension)) {
      continue;
    }
    if (path.endsWith(SharedNoAliasGuardConst.generatedExtension)) {
      continue;
    }
    if (path.endsWith(SharedNoAliasGuardConst.freezedExtension)) {
      continue;
    }
    files.add(entity);
  }
  return files;
}

String _normalizePath(String path) {
  return path.replaceAll('\\', '/');
}

String _stripLineComment(String sourceLine) {
  final int commentIndex = sourceLine.indexOf('//');
  if (commentIndex < 0) {
    return sourceLine;
  }
  return sourceLine.substring(0, commentIndex);
}
