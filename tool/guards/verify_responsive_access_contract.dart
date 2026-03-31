import 'dart:io';

import 'guard_utils.dart';

class ResponsiveAccessGuardConst {
  const ResponsiveAccessGuardConst._();

  static const String featuresRoot = 'lib/presentation/features';
  static const String allowDirectResponsiveMarker =
      'responsive-access-guard: allow-direct-responsive';
  static final RegExp forbiddenResponsivePattern = RegExp(
    r'\bResponsiveDimensions\.(compactValue|compact)\b',
  );
}

class ResponsiveAccessViolation {
  const ResponsiveAccessViolation({
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
  final Directory root = Directory(ResponsiveAccessGuardConst.featuresRoot);
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${ResponsiveAccessGuardConst.featuresRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<ResponsiveAccessViolation> violations =
      <ResponsiveAccessViolation>[];
  final List<File> files = collectTrackedDartFiles(<String>[
    ResponsiveAccessGuardConst.featuresRoot,
  ]);

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    final List<String> lines = await file.readAsLines();
    for (int index = 0; index < lines.length; index++) {
      final String rawLine = lines[index];
      if (rawLine.contains(
        ResponsiveAccessGuardConst.allowDirectResponsiveMarker,
      )) {
        continue;
      }

      final String sourceLine = _stripLineCommentSmart(rawLine).trim();
      if (!sourceLine.contains('ResponsiveDimensions.')) {
        continue;
      }
      if (!ResponsiveAccessGuardConst.forbiddenResponsivePattern.hasMatch(
        sourceLine,
      )) {
        continue;
      }

      final int lineNumber = index + 1;
      violations.add(
        ResponsiveAccessViolation(
          filePath: path,
          lineNumber: lineNumber,
          reason:
              'Dùng `context.spacing`, `context.componentSize`, hoặc context extension tương ứng thay vì `ResponsiveDimensions` trực tiếp trong feature layer.',
          lineContent: rawLine.trim(),
        ),
      );
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Responsive access contract passed.');
    return;
  }

  stderr.writeln('Responsive access contract failed.');
  for (final ResponsiveAccessViolation violation in violations) {
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
