import 'dart:io';

import 'guard_utils.dart';

class ThemeContextConsistencyGuardConst {
  const ThemeContextConsistencyGuardConst._();

  static const String featuresRoot = 'lib/presentation/features';
  static const String allowThemeOfMarker =
      'theme-context-guard: allow-theme-of';
  static final RegExp themeOfPattern = RegExp(r'\bTheme\.of\s*\(');
}

class ThemeContextConsistencyViolation {
  const ThemeContextConsistencyViolation({
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
  final Directory root = Directory(
    ThemeContextConsistencyGuardConst.featuresRoot,
  );
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${ThemeContextConsistencyGuardConst.featuresRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<ThemeContextConsistencyViolation> violations =
      <ThemeContextConsistencyViolation>[];
  final List<File> files = collectTrackedDartFiles(<String>[
    ThemeContextConsistencyGuardConst.featuresRoot,
  ]);

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    final List<String> lines = await file.readAsLines();
    for (int index = 0; index < lines.length; index++) {
      final String rawLine = lines[index];
      if (rawLine.contains(
        ThemeContextConsistencyGuardConst.allowThemeOfMarker,
      )) {
        continue;
      }

      final String sourceLine = _stripLineCommentSmart(rawLine).trim();
      if (!sourceLine.contains('Theme.of')) {
        continue;
      }
      if (!ThemeContextConsistencyGuardConst.themeOfPattern.hasMatch(
        sourceLine,
      )) {
        continue;
      }

      violations.add(
        ThemeContextConsistencyViolation(
          filePath: path,
          lineNumber: index + 1,
          reason:
              'Dùng context.textTheme, context.colorScheme, context.palette thay vì Theme.of(context).',
          lineContent: rawLine.trim(),
        ),
      );
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Theme context consistency contract passed.');
    return;
  }

  stderr.writeln('Theme context consistency contract failed.');
  for (final ThemeContextConsistencyViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

String _stripLineCommentSmart(String sourceLine) {
  bool inSingleQuote = false;
  bool inDoubleQuote = false;
  bool escaped = false;

  for (int index = 0; index < sourceLine.length - 1; index++) {
    final String char = sourceLine[index];
    if (escaped) {
      escaped = false;
      continue;
    }
    if ((inSingleQuote || inDoubleQuote) && char == r'\') {
      escaped = true;
      continue;
    }
    if (!inDoubleQuote && char == '\'') {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (!inSingleQuote && char == '"') {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) {
      continue;
    }
    if (char != '/' || sourceLine[index + 1] != '/') {
      continue;
    }
    return sourceLine.substring(0, index);
  }

  return sourceLine;
}
