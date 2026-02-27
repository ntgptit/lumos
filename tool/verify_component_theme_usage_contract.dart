import 'dart:io';

class ComponentThemeGuardConst {
  const ComponentThemeGuardConst._();

  static const String sharedWidgetsRoot = 'lib/presentation/shared/widgets';
  static const String dartExtension = '.dart';
  static const String generatedExtension = '.g.dart';
  static const String freezedExtension = '.freezed.dart';
  static const String allowInlineOverrideMarker =
      'component-theme-guard: allow-inline-override';
}

class ComponentThemeViolation {
  const ComponentThemeViolation({
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

class _ForbiddenPropertyRule {
  const _ForbiddenPropertyRule({
    required this.widgetName,
    required this.widgetStartPattern,
    required this.propertyNames,
    required this.reason,
  });

  final String widgetName;
  final RegExp widgetStartPattern;
  final List<String> propertyNames;
  final String reason;
}

final List<_ForbiddenPropertyRule>
_forbiddenPropertyRules = <_ForbiddenPropertyRule>[
  _ForbiddenPropertyRule(
    widgetName: 'AppBar',
    widgetStartPattern: RegExp(r'\bAppBar\s*\('),
    propertyNames: <String>['backgroundColor', 'foregroundColor'],
    reason: 'AppBar colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'BottomNavigationBar',
    widgetStartPattern: RegExp(r'\bBottomNavigationBar\s*\('),
    propertyNames: <String>[
      'backgroundColor',
      'selectedItemColor',
      'unselectedItemColor',
    ],
    reason:
        'BottomNavigationBar colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Card',
    widgetStartPattern: RegExp(r'\bCard\s*\('),
    propertyNames: <String>['color', 'surfaceTintColor'],
    reason: 'Card colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'ElevatedButton',
    widgetStartPattern: RegExp(r'\bElevatedButton\s*\('),
    propertyNames: <String>['style'],
    reason:
        'ElevatedButton in shared widgets should rely on theme style from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'OutlinedButton',
    widgetStartPattern: RegExp(r'\bOutlinedButton\s*\('),
    propertyNames: <String>['style'],
    reason:
        'OutlinedButton in shared widgets should rely on theme style from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'TextButton',
    widgetStartPattern: RegExp(r'\bTextButton\s*\('),
    propertyNames: <String>['style'],
    reason:
        'TextButton in shared widgets should rely on theme style from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'FloatingActionButton',
    widgetStartPattern: RegExp(r'\bFloatingActionButton(?:\.extended)?\s*\('),
    propertyNames: <String>['backgroundColor', 'foregroundColor'],
    reason:
        'FloatingActionButton colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Chip',
    widgetStartPattern: RegExp(r'\b(?:Chip|FilterChip|ChoiceChip)\s*\('),
    propertyNames: <String>['backgroundColor', 'side', 'labelStyle'],
    reason: 'Chip styles in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Divider',
    widgetStartPattern: RegExp(r'\bDivider\s*\('),
    propertyNames: <String>['color'],
    reason: 'Divider color in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'ListTile',
    widgetStartPattern: RegExp(r'\bListTile\s*\('),
    propertyNames: <String>['iconColor', 'textColor', 'selectedColor'],
    reason:
        'ListTile colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Switch',
    widgetStartPattern: RegExp(r'\bSwitch\s*\('),
    propertyNames: <String>[
      'thumbColor',
      'trackColor',
      'activeColor',
      'activeTrackColor',
      'inactiveTrackColor',
    ],
    reason: 'Switch colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Checkbox',
    widgetStartPattern: RegExp(r'\bCheckbox\s*\('),
    propertyNames: <String>['activeColor', 'checkColor', 'fillColor'],
    reason:
        'Checkbox colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Radio',
    widgetStartPattern: RegExp(r'\bRadio\s*<[^>]*>\s*\(|\bRadio\s*\('),
    propertyNames: <String>['activeColor', 'fillColor'],
    reason: 'Radio colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Slider',
    widgetStartPattern: RegExp(r'\bSlider\s*\('),
    propertyNames: <String>['activeColor', 'inactiveColor'],
    reason: 'Slider colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'ProgressIndicator',
    widgetStartPattern: RegExp(
      r'\b(?:LinearProgressIndicator|CircularProgressIndicator)\s*\(',
    ),
    propertyNames: <String>['color', 'backgroundColor', 'valueColor'],
    reason:
        'ProgressIndicator colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'Dialog',
    widgetStartPattern: RegExp(r'\bDialog\s*\('),
    propertyNames: <String>['backgroundColor', 'surfaceTintColor'],
    reason: 'Dialog colors in shared widgets must come from component_themes.',
  ),
  _ForbiddenPropertyRule(
    widgetName: 'SnackBar',
    widgetStartPattern: RegExp(r'\bSnackBar\s*\('),
    propertyNames: <String>['backgroundColor', 'contentTextStyle'],
    reason:
        'SnackBar colors in shared widgets must come from component_themes.',
  ),
];

Future<void> main() async {
  final Directory root = Directory(ComponentThemeGuardConst.sharedWidgetsRoot);
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${ComponentThemeGuardConst.sharedWidgetsRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<ComponentThemeViolation> violations = <ComponentThemeViolation>[];
  final List<File> files = _collectSourceFiles(root);
  for (final File file in files) {
    final String path = _normalizePath(file.path);
    final List<String> lines = await file.readAsLines();
    _checkFile(path: path, lines: lines, violations: violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('Component theme usage contract passed.');
    return;
  }

  stderr.writeln('Component theme usage contract failed.');
  for (final ComponentThemeViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: ${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

void _checkFile({
  required String path,
  required List<String> lines,
  required List<ComponentThemeViolation> violations,
}) {
  for (int index = 0; index < lines.length; index++) {
    final String rawLine = lines[index];
    final String sourceLine = _stripLineCommentSmart(rawLine).trim();
    if (sourceLine.isEmpty) {
      continue;
    }

    for (final _ForbiddenPropertyRule rule in _forbiddenPropertyRules) {
      if (!rule.widgetStartPattern.hasMatch(sourceLine)) {
        continue;
      }
      final int blockEnd = _findBlockEnd(lines: lines, startIndex: index);
      for (final String propertyName in rule.propertyNames) {
        final List<_PropertyOccurrence> occurrences =
            _extractPropertyOccurrences(
              lines: lines,
              blockStartIndex: index,
              blockEndIndex: blockEnd,
              propertyName: propertyName,
            );
        for (final _PropertyOccurrence occurrence in occurrences) {
          final bool allowOverride = _isAllowOverrideLine(
            line: occurrence.lineContent,
            expression: occurrence.expression,
          );
          if (allowOverride) {
            continue;
          }
          final bool inlineColorOverride = _isInlineColorOverride(
            expression: occurrence.expression,
          );
          if (!inlineColorOverride) {
            continue;
          }
          violations.add(
            ComponentThemeViolation(
              filePath: path,
              lineNumber: occurrence.lineNumber,
              reason: '${rule.reason} (`${rule.widgetName}.$propertyName`)',
              lineContent: occurrence.lineContent,
            ),
          );
        }
      }
    }
  }
}

bool _isAllowOverrideLine({required String line, required String expression}) {
  if (line.contains(ComponentThemeGuardConst.allowInlineOverrideMarker)) {
    return true;
  }
  if (expression.trim() == 'null') {
    return true;
  }
  return false;
}

bool _isInlineColorOverride({required String expression}) {
  final List<RegExp> inlineColorPatterns = <RegExp>[
    RegExp(r'\bcolorScheme\.'),
    RegExp(r'\bTheme\.of\(context\)\.colorScheme\.'),
    RegExp(r'\bColor\s*\('),
    RegExp(r'\bColors\.'),
  ];
  for (final RegExp pattern in inlineColorPatterns) {
    if (pattern.hasMatch(expression)) {
      return true;
    }
  }
  return false;
}

class _PropertyOccurrence {
  const _PropertyOccurrence({
    required this.expression,
    required this.lineNumber,
    required this.lineContent,
  });

  final String expression;
  final int lineNumber;
  final String lineContent;
}

List<_PropertyOccurrence> _extractPropertyOccurrences({
  required List<String> lines,
  required int blockStartIndex,
  required int blockEndIndex,
  required String propertyName,
}) {
  final List<_PropertyOccurrence> occurrences = <_PropertyOccurrence>[];
  final RegExp propertyRegExp = RegExp(
    '\\b${RegExp.escape(propertyName)}\\s*:',
  );
  for (int index = blockStartIndex; index <= blockEndIndex; index++) {
    final String rawLine = lines[index];
    final String line = _stripLineCommentSmart(rawLine);
    final RegExpMatch? match = propertyRegExp.firstMatch(line);
    if (match == null) {
      continue;
    }
    final String expression = _collectPropertyExpression(
      lines: lines,
      startLineIndex: index,
      startOffset: match.end,
      blockEndIndex: blockEndIndex,
    );
    occurrences.add(
      _PropertyOccurrence(
        expression: expression,
        lineNumber: index + 1,
        lineContent: rawLine.trim(),
      ),
    );
  }
  return occurrences;
}

String _collectPropertyExpression({
  required List<String> lines,
  required int startLineIndex,
  required int startOffset,
  required int blockEndIndex,
}) {
  final StringBuffer buffer = StringBuffer();
  int parenthesesDepth = 0;
  int bracketsDepth = 0;
  int bracesDepth = 0;
  bool inSingleQuote = false;
  bool inDoubleQuote = false;
  bool escaped = false;

  for (
    int lineIndex = startLineIndex;
    lineIndex <= blockEndIndex;
    lineIndex++
  ) {
    final String sourceLine = _stripLineCommentSmart(lines[lineIndex]);
    final int from = lineIndex == startLineIndex ? startOffset : 0;

    for (int charIndex = from; charIndex < sourceLine.length; charIndex++) {
      final String ch = sourceLine[charIndex];
      if (escaped) {
        buffer.write(ch);
        escaped = false;
        continue;
      }
      if ((inSingleQuote || inDoubleQuote) && ch == r'\') {
        buffer.write(ch);
        escaped = true;
        continue;
      }
      if (!inDoubleQuote && ch == '\'') {
        inSingleQuote = !inSingleQuote;
        buffer.write(ch);
        continue;
      }
      if (!inSingleQuote && ch == '"') {
        inDoubleQuote = !inDoubleQuote;
        buffer.write(ch);
        continue;
      }
      if (!inSingleQuote && !inDoubleQuote) {
        if (ch == '(') {
          parenthesesDepth++;
        }
        if (ch == ')') {
          parenthesesDepth--;
        }
        if (ch == '[') {
          bracketsDepth++;
        }
        if (ch == ']') {
          bracketsDepth--;
        }
        if (ch == '{') {
          bracesDepth++;
        }
        if (ch == '}') {
          bracesDepth--;
        }
      }
      if (!inSingleQuote &&
          !inDoubleQuote &&
          ch == ',' &&
          parenthesesDepth <= 0 &&
          bracketsDepth <= 0 &&
          bracesDepth <= 0) {
        return buffer.toString().trim();
      }
      buffer.write(ch);
    }
    buffer.write(' ');
  }
  return buffer.toString().trim();
}

int _findBlockEnd({required List<String> lines, required int startIndex}) {
  final String firstLine = _stripLineCommentSmart(lines[startIndex]);
  int parenthesesDepth =
      _countChar(firstLine, '(') - _countChar(firstLine, ')');
  if (parenthesesDepth <= 0) {
    return startIndex;
  }
  for (int lineIndex = startIndex + 1; lineIndex < lines.length; lineIndex++) {
    final String sourceLine = _stripLineCommentSmart(lines[lineIndex]);
    parenthesesDepth += _countChar(sourceLine, '(');
    parenthesesDepth -= _countChar(sourceLine, ')');
    if (parenthesesDepth <= 0) {
      return lineIndex;
    }
  }
  return lines.length - 1;
}

List<File> _collectSourceFiles(Directory root) {
  final List<File> files = <File>[];
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }
    final String path = _normalizePath(entity.path);
    if (!path.endsWith(ComponentThemeGuardConst.dartExtension)) {
      continue;
    }
    if (path.endsWith(ComponentThemeGuardConst.generatedExtension)) {
      continue;
    }
    if (path.endsWith(ComponentThemeGuardConst.freezedExtension)) {
      continue;
    }
    files.add(entity);
  }
  return files;
}

int _countChar(String source, String char) => char.allMatches(source).length;

String _normalizePath(String rawPath) => rawPath.replaceAll('\\', '/');

String _stripLineCommentSmart(String sourceLine) {
  bool inSingleQuote = false;
  bool inDoubleQuote = false;
  bool escaped = false;
  for (int index = 0; index < sourceLine.length - 1; index++) {
    final String ch = sourceLine[index];
    if (escaped) {
      escaped = false;
      continue;
    }
    if ((inSingleQuote || inDoubleQuote) && ch == r'\') {
      escaped = true;
      continue;
    }
    if (!inDoubleQuote && ch == '\'') {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (!inSingleQuote && ch == '"') {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) {
      continue;
    }
    if (ch != '/') {
      continue;
    }
    if (sourceLine[index + 1] != '/') {
      continue;
    }
    return sourceLine.substring(0, index);
  }
  return sourceLine;
}
