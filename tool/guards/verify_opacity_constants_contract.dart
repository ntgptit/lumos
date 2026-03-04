import 'dart:io';

class OpacityContractConst {
  const OpacityContractConst._();

  static const String libRoot = 'lib';
  static const String dimensionsPath =
      'lib/core/themes/foundation/app_opacity.dart';
  static const String allowedSharedWidgetsPath =
      'lib/presentation/shared/widgets/';
  static const String allowedCoreThemesPath = 'lib/core/themes/';
  static const String allowedFeaturePath = 'lib/presentation/features/';
  static const String allowedClassName = 'AppOpacity';
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
  'transparent': '0.0',
  'divider': '0.12',
  'scrimLight': '0.32',
  'scrimDark': '0.40',
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
  'lowEmphasis': '0.60',
  'hint': '0.38',
  'faint': '0.08',
  'subtle': '0.12',
  'soft': '0.16',
  'medium': '0.24',
  'strong': '0.48',
  'disabled': '0.38',
};

final RegExp _constDoubleRegExp = RegExp(
  r'^\s*static\s+const\s+double\s+([A-Za-z0-9_]+)\s*=\s*([^;]+);',
);
final RegExp _opacityWordRegExp = RegExp(r'(opacity|Opacity|alpha|Alpha)');
final RegExp _widgetOpacitiesUseRegExp = RegExp(r'AppOpacity\.([A-Za-z0-9_]+)');
final RegExp _withOpacityUseRegExp = RegExp(r'\bwithOpacity\s*\(');
final RegExp _withValuesAlphaUseRegExp = RegExp(
  r'\bwithValues\s*\([^)]*\balpha\s*:',
);
final RegExp _opacityNamedArgumentRegExp = RegExp(r'\bopacity\s*:');
final RegExp _alphaNamedArgumentRegExp = RegExp(r'\balpha\s*:');

Future<void> main() async {
  final List<OpacityViolation> violations = <OpacityViolation>[];
  await _checkAppOpacityClass(violations);
  await _checkNoExtraOpacityConstants(violations);
  await _checkOnlyAllowedWidgetOpacityUsages(violations);
  await _checkOpacityUsageRestrictedByPath(violations);

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

Future<void> _checkAppOpacityClass(List<OpacityViolation> violations) async {
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
  bool inAppOpacityClass = false;
  int braceBalance = 0;

  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];
    if (!inAppOpacityClass &&
        line.contains('class ${OpacityContractConst.allowedClassName}')) {
      inAppOpacityClass = true;
      classStartLine = i + 1;
      braceBalance += _countChar(line, '{');
      braceBalance -= _countChar(line, '}');
      continue;
    }

    if (!inAppOpacityClass) {
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
      inAppOpacityClass = false;
    }
  }

  if (classStartLine < 0) {
    violations.add(
      const OpacityViolation(
        filePath: OpacityContractConst.dimensionsPath,
        lineNumber: 1,
        message: 'Missing AppOpacity class.',
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
    bool inAppOpacityClass = false;
    int braceBalance = 0;
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      if (!inAppOpacityClass &&
          normalizedPath == OpacityContractConst.dimensionsPath &&
          line.contains('class ${OpacityContractConst.allowedClassName}')) {
        inAppOpacityClass = true;
        braceBalance += _countChar(line, '{');
        braceBalance -= _countChar(line, '}');
      } else if (inAppOpacityClass) {
        braceBalance += _countChar(line, '{');
        braceBalance -= _countChar(line, '}');
        if (braceBalance <= 0) {
          inAppOpacityClass = false;
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
          inAppOpacityClass) {
        continue;
      }
      violations.add(
        OpacityViolation(
          filePath: normalizedPath,
          lineNumber: i + 1,
          message:
              'Opacity constants must be declared only in AppOpacity class.',
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
                'Usage of AppOpacity.$constantName is not allowed by opacity contract.',
            lineContent: line.trim(),
          ),
        );
      }
    }
  }
}

Future<void> _checkOpacityUsageRestrictedByPath(
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
    if (_isAllowedOpacityPath(normalizedPath)) {
      continue;
    }

    final List<String> lines = await entity.readAsLines();
    for (int i = 0; i < lines.length; i++) {
      final String rawLine = lines[i];
      final String line = _stripLineComment(rawLine).trim();
      if (line.isEmpty) {
        continue;
      }
      if (!_containsRestrictedOpacityUsage(line)) {
        continue;
      }
      violations.add(
        OpacityViolation(
          filePath: normalizedPath,
          lineNumber: i + 1,
          message:
              'Opacity usage is only allowed in shared widgets and core themes.',
          lineContent: rawLine.trim(),
        ),
      );
    }
  }
}

bool _isAllowedOpacityPath(String normalizedPath) {
  if (normalizedPath.startsWith(
    OpacityContractConst.allowedSharedWidgetsPath,
  )) {
    return true;
  }
  if (normalizedPath.startsWith(OpacityContractConst.allowedCoreThemesPath)) {
    return true;
  }
  if (normalizedPath.startsWith(OpacityContractConst.allowedFeaturePath)) {
    return true;
  }
  return false;
}

bool _containsRestrictedOpacityUsage(String line) {
  if (_widgetOpacitiesUseRegExp.hasMatch(line)) {
    return true;
  }
  if (_withOpacityUseRegExp.hasMatch(line)) {
    return true;
  }
  if (_withValuesAlphaUseRegExp.hasMatch(line)) {
    return true;
  }
  if (_opacityNamedArgumentRegExp.hasMatch(line)) {
    return true;
  }
  if (_alphaNamedArgumentRegExp.hasMatch(line)) {
    return true;
  }
  return false;
}

int _countChar(String source, String char) {
  return char.allMatches(source).length;
}

String _normalizePath(String rawPath) {
  return rawPath.replaceAll('\\', '/');
}

String _stripLineComment(String sourceLine) {
  final int commentIndex = sourceLine.indexOf('//');
  if (commentIndex < 0) {
    return sourceLine;
  }
  return sourceLine.substring(0, commentIndex);
}
