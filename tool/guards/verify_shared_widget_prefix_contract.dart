import 'dart:io';

class SharedWidgetPrefixGuardConst {
  const SharedWidgetPrefixGuardConst._();

  static const String sharedRoot = 'lib/presentation/shared';
  static const String dartExtension = '.dart';
  static const String generatedExtension = '.g.dart';
  static const String freezedExtension = '.freezed.dart';
  static const String widgetFilePrefix = 'lumos_';
  static const String widgetClassPrefix = 'Lumos';
  static const List<String> widgetDirectoryPrefixes = <String>[
    'lib/presentation/shared/composites/',
    'lib/presentation/shared/layouts/',
    'lib/presentation/shared/primitives/',
    'lib/presentation/shared/screens/',
  ];
}

class SharedWidgetPrefixViolation {
  const SharedWidgetPrefixViolation({
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

final RegExp _publicClassPattern = RegExp(
  r'^class\s+(?!_)(\w+)(?:<[^>]+>)?\s+extends\s+([A-Za-z_]\w*)',
);

Future<void> main() async {
  final Directory sharedRoot = Directory(SharedWidgetPrefixGuardConst.sharedRoot);
  if (!sharedRoot.existsSync()) {
    stderr.writeln(
      'Missing `${SharedWidgetPrefixGuardConst.sharedRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<SharedWidgetPrefixViolation> violations = _collectViolations(
    sharedRoot: sharedRoot,
  );
  if (violations.isEmpty) {
    stdout.writeln('Shared widget prefix contract passed.');
    return;
  }

  stderr.writeln('Shared widget prefix contract failed.');
  for (final SharedWidgetPrefixViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

List<SharedWidgetPrefixViolation> _collectViolations({
  required Directory sharedRoot,
}) {
  final List<SharedWidgetPrefixViolation> violations =
      <SharedWidgetPrefixViolation>[];
  final List<File> files = _collectSourceFiles(sharedRoot);

  for (final File file in files) {
    final String path = _normalizePath(file.path);
    if (!_isWidgetPath(path)) {
      continue;
    }

    final List<String> lines = file.readAsLinesSync();
    final List<_WidgetDeclaration> widgetDeclarations = _collectWidgetClasses(
      lines: lines,
    );
    if (widgetDeclarations.isEmpty) {
      continue;
    }

    final String fileName = path.split('/').last;
    final bool hasPrefixedFileName = fileName.startsWith(
      SharedWidgetPrefixGuardConst.widgetFilePrefix,
    );
    if (!hasPrefixedFileName) {
      violations.add(
        SharedWidgetPrefixViolation(
          filePath: path,
          lineNumber: 1,
          reason:
              'Shared widget file name must start with '
              '`${SharedWidgetPrefixGuardConst.widgetFilePrefix}`.',
          lineContent: fileName,
        ),
      );
    }

    for (final _WidgetDeclaration declaration in widgetDeclarations) {
      final bool hasPrefixedClassName = declaration.className.startsWith(
        SharedWidgetPrefixGuardConst.widgetClassPrefix,
      );
      if (hasPrefixedClassName) {
        continue;
      }
      violations.add(
        SharedWidgetPrefixViolation(
          filePath: path,
          lineNumber: declaration.lineNumber,
          reason:
              'Shared widget type must start with '
              '`${SharedWidgetPrefixGuardConst.widgetClassPrefix}`.',
          lineContent: declaration.lineContent,
        ),
      );
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
    if (!path.endsWith(SharedWidgetPrefixGuardConst.dartExtension)) {
      continue;
    }
    if (path.endsWith(SharedWidgetPrefixGuardConst.generatedExtension)) {
      continue;
    }
    if (path.endsWith(SharedWidgetPrefixGuardConst.freezedExtension)) {
      continue;
    }
    files.add(entity);
  }
  return files;
}

List<_WidgetDeclaration> _collectWidgetClasses({required List<String> lines}) {
  final List<_WidgetDeclaration> declarations = <_WidgetDeclaration>[];

  for (int index = 0; index < lines.length; index++) {
    final String rawLine = lines[index];
    final String sourceLine = _stripLineComment(rawLine).trim();
    if (sourceLine.isEmpty) {
      continue;
    }
    final RegExpMatch? match = _publicClassPattern.firstMatch(sourceLine);
    if (match == null) {
      continue;
    }

    final String className = match.group(1) ?? '';
    final String superClassName = match.group(2) ?? '';
    final bool isWidgetDeclaration = _isWidgetSuperclass(superClassName);
    if (!isWidgetDeclaration) {
      continue;
    }

    declarations.add(
      _WidgetDeclaration(
        className: className,
        lineNumber: index + 1,
        lineContent: rawLine.trim(),
      ),
    );
  }

  return declarations;
}

bool _isWidgetPath(String path) {
  for (final String prefix
      in SharedWidgetPrefixGuardConst.widgetDirectoryPrefixes) {
    if (path.startsWith(prefix)) {
      return true;
    }
  }
  return false;
}

bool _isWidgetSuperclass(String superClassName) {
  if (superClassName.endsWith('Widget')) {
    return true;
  }
  if (superClassName.startsWith(SharedWidgetPrefixGuardConst.widgetClassPrefix)) {
    return true;
  }
  return false;
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

class _WidgetDeclaration {
  const _WidgetDeclaration({
    required this.className,
    required this.lineNumber,
    required this.lineContent,
  });

  final String className;
  final int lineNumber;
  final String lineContent;
}
