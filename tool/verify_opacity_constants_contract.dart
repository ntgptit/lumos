import 'dart:io';

class OpacityContractConst {
  const OpacityContractConst._();

  static const String libRoot = 'lib';
  static const String dimensionsPath =
      'lib/core/themes/constants/dimensions.dart';
  static const String allowedClassName = 'WidgetOpacities';
  static const String generatedSuffix = '.g.dart';
  static const String freezedSuffix = '.freezed.dart';
  static const String dartSuffix = '.dart';
}

class OpacityViolation {
  const OpacityViolation({
    required this.filePath,
    required this.lineNumber,
    required this.message,
    required this.lineContent,
  });

  final String filePath;
  final int lineNumber;
  final String message;
  final String lineContent;
}

const Map<String, String> _allowedOpacityConstants = <String, String>{
  'transparent': 'Insets.spacing0',
  'divider': '0.12',
  'scrimLight': '0.32',
  'scrimDark': '0.4',
  'disabledContent': '0.38',
  'stateHover': '0.08',
  'stateFocus': '0.12',
  'statePress': '0.12',
  'stateDrag': '0.16',
  'elevationLevel1': '0.05',
  'elevationLevel2': '0.08',
  'elevationLevel3': '0.11',
  'elevationLevel4': '0.12',
  'elevationLevel5': '0.14',
  'lowEmphasis': 'Insets.spacing0',
  'hint': 'Insets.spacing0',
  'hintCustom': '0.38',
};

final RegExp _constDoubleRegExp = RegExp(
  r'^\s*static\s+const\s+double\s+([A-Za-z0-9_]+)\s*=\s*([^;]+);',
);
final RegExp _opacityWordRegExp = RegExp(r'(opacity|Opacity|alpha|Alpha)');
final RegExp _widgetOpacitiesUseRegExp = RegExp(
  r'WidgetOpacities\.([A-Za-z0-9_]+)',
);

Future<void> main() async {
  final List<OpacityViolation> violations = <OpacityViolation>[];
  await _checkWidgetOpacitiesClass(violations);
  await _checkNoExtraOpacityConstants(violations);
  await _checkOnlyAllowedWidgetOpacityUsages(violations);

  if (violations.isEmpty) {
    stdout.writeln('Opacity constants contract passed.');
    return;
  }

  stderr.writeln('Opacity constants contract failed.');
  for (final OpacityViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.message} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

Future<void> _checkWidgetOpacitiesClass(
  List<OpacityViolation> violations,
) async {
  final File dimensionsFile = File(OpacityContractConst.dimensionsPath);
  if (!dimensionsFile.existsSync()) {
    violations.add(
      const OpacityViolation(
        filePath: OpacityContractConst.dimensionsPath,
        lineNumber: 1,
        message: 'Missing dimensions file for opacity contract.',
        lineContent: OpacityContractConst.dimensionsPath,
      ),
    );
    return;
  }

  final List<String> lines = await dimensionsFile.readAsLines();
  final Map<String, String> foundConstants = <String, String>{};
  int classStartLine = -1;
  bool inWidgetOpacitiesClass = false;
  int braceBalance = 0;

  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];
    if (!inWidgetOpacitiesClass &&
        line.contains('class ${OpacityContractConst.allowedClassName}')) {
      inWidgetOpacitiesClass = true;
      classStartLine = i + 1;
      braceBalance += _countChar(line, '{');
      braceBalance -= _countChar(line, '}');
      continue;
    }

    if (!inWidgetOpacitiesClass) {
      continue;
    }

    braceBalance += _countChar(line, '{');
    braceBalance -= _countChar(line, '}');

    final RegExpMatch? match = _constDoubleRegExp.firstMatch(line);
    if (match != null) {
      final String name = match.group(1)!;
      final String value = match.group(2)!.trim();
      foundConstants[name] = value;
    }

    if (braceBalance <= 0) {
      inWidgetOpacitiesClass = false;
    }
  }

  if (classStartLine < 0) {
    violations.add(
      const OpacityViolation(
        filePath: OpacityContractConst.dimensionsPath,
        lineNumber: 1,
        message: 'Missing WidgetOpacities class.',
        lineContent: OpacityContractConst.allowedClassName,
      ),
    );
    return;
  }

  for (final MapEntry<String, String> entry
      in _allowedOpacityConstants.entries) {
    final String? actualValue = foundConstants[entry.key];
    if (actualValue == null) {
      violations.add(
        OpacityViolation(
          filePath: OpacityContractConst.dimensionsPath,
          lineNumber: classStartLine,
          message: 'Missing required opacity constant `${entry.key}`.',
          lineContent: OpacityContractConst.allowedClassName,
        ),
      );
      continue;
    }
    if (actualValue == entry.value) {
      continue;
    }
    violations.add(
      OpacityViolation(
        filePath: OpacityContractConst.dimensionsPath,
        lineNumber: classStartLine,
        message:
            'Invalid value for `${entry.key}`. Expected `${entry.value}` got `$actualValue`.',
        lineContent: OpacityContractConst.allowedClassName,
      ),
    );
  }

  for (final String foundName in foundConstants.keys) {
    if (_allowedOpacityConstants.containsKey(foundName)) {
      continue;
    }
    violations.add(
      OpacityViolation(
        filePath: OpacityContractConst.dimensionsPath,
        lineNumber: classStartLine,
        message: 'Extra opacity constant is not allowed: `$foundName`.',
        lineContent: OpacityContractConst.allowedClassName,
      ),
    );
  }
}

Future<void> _checkNoExtraOpacityConstants(
  List<OpacityViolation> violations,
) async {
  final Directory root = Directory(OpacityContractConst.libRoot);
  if (!root.existsSync()) {
    return;
  }

  final List<FileSystemEntity> entities = root.listSync(recursive: true);
  for (final FileSystemEntity entity in entities) {
    if (entity is! File) {
      continue;
    }
    final String normalizedPath = _normalizePath(entity.path);
    if (!normalizedPath.endsWith(OpacityContractConst.dartSuffix)) {
      continue;
    }
    if (normalizedPath.endsWith(OpacityContractConst.generatedSuffix)) {
      continue;
    }
    if (normalizedPath.endsWith(OpacityContractConst.freezedSuffix)) {
      continue;
    }

    final List<String> lines = await entity.readAsLines();
    bool inWidgetOpacitiesClass = false;
    int braceBalance = 0;
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      if (!inWidgetOpacitiesClass &&
          normalizedPath == OpacityContractConst.dimensionsPath &&
          line.contains('class ${OpacityContractConst.allowedClassName}')) {
        inWidgetOpacitiesClass = true;
        braceBalance += _countChar(line, '{');
        braceBalance -= _countChar(line, '}');
      } else if (inWidgetOpacitiesClass) {
        braceBalance += _countChar(line, '{');
        braceBalance -= _countChar(line, '}');
        if (braceBalance <= 0) {
          inWidgetOpacitiesClass = false;
        }
      }

      final RegExpMatch? match = _constDoubleRegExp.firstMatch(line);
      if (match == null) {
        continue;
      }
      final String constName = match.group(1)!;
      if (!_opacityWordRegExp.hasMatch(constName)) {
        continue;
      }
      if (normalizedPath == OpacityContractConst.dimensionsPath &&
          inWidgetOpacitiesClass) {
        continue;
      }
      violations.add(
        OpacityViolation(
          filePath: normalizedPath,
          lineNumber: i + 1,
          message:
              'Opacity constants must be declared only in WidgetOpacities class.',
          lineContent: line.trim(),
        ),
      );
    }
  }
}

Future<void> _checkOnlyAllowedWidgetOpacityUsages(
  List<OpacityViolation> violations,
) async {
  final Directory root = Directory(OpacityContractConst.libRoot);
  if (!root.existsSync()) {
    return;
  }

  final List<FileSystemEntity> entities = root.listSync(recursive: true);
  for (final FileSystemEntity entity in entities) {
    if (entity is! File) {
      continue;
    }
    final String normalizedPath = _normalizePath(entity.path);
    if (!normalizedPath.endsWith(OpacityContractConst.dartSuffix)) {
      continue;
    }
    if (normalizedPath.endsWith(OpacityContractConst.generatedSuffix)) {
      continue;
    }
    if (normalizedPath.endsWith(OpacityContractConst.freezedSuffix)) {
      continue;
    }

    final List<String> lines = await entity.readAsLines();
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final Iterable<RegExpMatch> matches = _widgetOpacitiesUseRegExp
          .allMatches(line);
      for (final RegExpMatch match in matches) {
        final String constantName = match.group(1)!;
        if (constantName.startsWith('_')) {
          continue;
        }
        if (_allowedOpacityConstants.containsKey(constantName)) {
          continue;
        }
        violations.add(
          OpacityViolation(
            filePath: normalizedPath,
            lineNumber: i + 1,
            message:
                'Usage of WidgetOpacities.$constantName is not allowed by opacity contract.',
            lineContent: line.trim(),
          ),
        );
      }
    }
  }
}

int _countChar(String source, String char) {
  return char.allMatches(source).length;
}

String _normalizePath(String rawPath) {
  return rawPath.replaceAll('\\', '/');
}
