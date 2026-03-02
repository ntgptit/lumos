import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

const String _libRoot = 'lib';
const String _beRoot = 'lumos-api-service/src/main/java';
const String _reportPath = 'tool/reports/public_methods_inventory.md';

const List<String> _dartExcludedSuffixes = <String>[
  '.g.dart',
  '.freezed.dart',
  '.gr.dart',
];

const List<String> _dartExcludedPrefixes = <String>['lib/l10n/'];

final RegExp _javaTypePattern = RegExp(
  r'\b(class|interface|enum|record)\s+([A-Za-z_]\w*)\b',
);

final RegExp _javaPublicMethodPattern = RegExp(
  r'^\s*public\s+(?:static\s+)?(?:final\s+)?(?:synchronized\s+)?(?:<[^>]+>\s*)?(?!class\b|interface\b|enum\b|record\b)([A-Za-z_][\w<>\[\],\s.?]*)\s+([A-Za-z_]\w*)\s*\(',
);

final RegExp _javaPublicConstructorPattern = RegExp(
  r'^\s*public\s+([A-Za-z_]\w*)\s*\(',
);

void main() {
  final List<_MethodEntry> dartEntries = _collectDartPublicMethods();
  final List<_MethodEntry> javaEntries = _collectJavaPublicMethods();
  final String report = _buildReport(
    dartEntries: dartEntries,
    javaEntries: javaEntries,
  );
  final File reportFile = File(_reportPath);
  reportFile.parent.createSync(recursive: true);
  reportFile.writeAsStringSync(report);
  stdout.writeln(
    'Public methods inventory generated: $_reportPath '
    '(FE=${dartEntries.length}, BE=${javaEntries.length})',
  );
}

List<_MethodEntry> _collectDartPublicMethods() {
  final Directory root = Directory(_libRoot);
  if (!root.existsSync()) {
    return <_MethodEntry>[];
  }
  final List<_MethodEntry> entries = <_MethodEntry>[];
  final List<FileSystemEntity> entities = root.listSync(recursive: true);
  for (final FileSystemEntity entity in entities) {
    if (entity is! File) {
      continue;
    }
    final String path = _normalizePath(entity.path);
    if (!_isDartSourcePath(path)) {
      continue;
    }
    final String source = entity.readAsStringSync();
    final ParseStringResult parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final CompilationUnit unit = parsed.unit;
    for (final CompilationUnitMember declaration in unit.declarations) {
      _collectUnitMemberMethods(
        declaration: declaration,
        filePath: path,
        lineInfo: parsed.lineInfo,
        entries: entries,
      );
    }
  }
  entries.sort(_sortEntries);
  return entries;
}

void _collectUnitMemberMethods({
  required CompilationUnitMember declaration,
  required String filePath,
  required LineInfo lineInfo,
  required List<_MethodEntry> entries,
}) {
  if (declaration is FunctionDeclaration) {
    final String functionName = declaration.name.lexeme;
    if (_isPrivateName(functionName)) {
      return;
    }
    _addEntry(
      entries: entries,
      filePath: filePath,
      lineInfo: lineInfo,
      offset: declaration.offset,
      owner: '(top-level)',
      methodName: functionName,
      kind: 'function',
    );
    return;
  }

  if (declaration is ClassDeclaration) {
    _collectClassMemberMethods(
      filePath: filePath,
      lineInfo: lineInfo,
      className: declaration.name.lexeme,
      members: declaration.members,
      entries: entries,
    );
    return;
  }

  if (declaration is MixinDeclaration) {
    _collectClassMemberMethods(
      filePath: filePath,
      lineInfo: lineInfo,
      className: declaration.name.lexeme,
      members: declaration.members,
      entries: entries,
    );
    return;
  }

  if (declaration is EnumDeclaration) {
    _collectClassMemberMethods(
      filePath: filePath,
      lineInfo: lineInfo,
      className: declaration.name.lexeme,
      members: declaration.members,
      entries: entries,
    );
    return;
  }

  if (declaration is ExtensionDeclaration) {
    final String extensionName = declaration.name?.lexeme ?? '(extension)';
    _collectClassMemberMethods(
      filePath: filePath,
      lineInfo: lineInfo,
      className: extensionName,
      members: declaration.members,
      entries: entries,
    );
    return;
  }
}

void _collectClassMemberMethods({
  required String filePath,
  required LineInfo lineInfo,
  required String className,
  required NodeList<ClassMember> members,
  required List<_MethodEntry> entries,
}) {
  for (final ClassMember member in members) {
    if (member is ConstructorDeclaration) {
      final String? namedConstructor = member.name?.lexeme;
      if (namedConstructor != null && _isPrivateName(namedConstructor)) {
        continue;
      }
      final String methodName = namedConstructor == null
          ? '$className()'
          : '$className.$namedConstructor()';
      _addEntry(
        entries: entries,
        filePath: filePath,
        lineInfo: lineInfo,
        offset: member.offset,
        owner: className,
        methodName: methodName,
        kind: 'constructor',
      );
      continue;
    }

    if (member is MethodDeclaration) {
      final String methodName = member.name.lexeme;
      if (_isPrivateName(methodName)) {
        continue;
      }
      final String kind = _resolveDartMethodKind(member: member);
      _addEntry(
        entries: entries,
        filePath: filePath,
        lineInfo: lineInfo,
        offset: member.offset,
        owner: className,
        methodName: methodName,
        kind: kind,
      );
      continue;
    }
  }
}

String _resolveDartMethodKind({required MethodDeclaration member}) {
  if (member.isGetter) {
    return 'getter';
  }
  if (member.isSetter) {
    return 'setter';
  }
  if (member.isOperator) {
    return 'operator';
  }
  if (member.isStatic) {
    return 'static-method';
  }
  return 'method';
}

List<_MethodEntry> _collectJavaPublicMethods() {
  final Directory root = Directory(_beRoot);
  if (!root.existsSync()) {
    return <_MethodEntry>[];
  }
  final List<_MethodEntry> entries = <_MethodEntry>[];
  final List<FileSystemEntity> entities = root.listSync(recursive: true);
  for (final FileSystemEntity entity in entities) {
    if (entity is! File) {
      continue;
    }
    final String path = _normalizePath(entity.path);
    if (!path.endsWith('.java')) {
      continue;
    }
    final List<String> lines = entity.readAsLinesSync();
    String currentType = '(top-level)';
    for (int index = 0; index < lines.length; index++) {
      final String line = lines[index];
      final RegExpMatch? typeMatch = _javaTypePattern.firstMatch(line);
      if (typeMatch != null) {
        currentType = typeMatch.group(2)!;
      }
      final RegExpMatch? constructorMatch = _javaPublicConstructorPattern
          .firstMatch(line);
      if (constructorMatch != null) {
        final String constructorName = constructorMatch.group(1)!;
        final bool isCurrentTypeConstructor = constructorName == currentType;
        if (isCurrentTypeConstructor) {
          entries.add(
            _MethodEntry(
              filePath: path,
              lineNumber: index + 1,
              owner: currentType,
              methodName: '$constructorName()',
              kind: 'constructor',
            ),
          );
          continue;
        }
      }
      final RegExpMatch? methodMatch = _javaPublicMethodPattern.firstMatch(
        line,
      );
      if (methodMatch == null) {
        continue;
      }
      final String methodName = methodMatch.group(2)!;
      entries.add(
        _MethodEntry(
          filePath: path,
          lineNumber: index + 1,
          owner: currentType,
          methodName: methodName,
          kind: 'method',
        ),
      );
    }
  }
  entries.sort(_sortEntries);
  return entries;
}

void _addEntry({
  required List<_MethodEntry> entries,
  required String filePath,
  required LineInfo lineInfo,
  required int offset,
  required String owner,
  required String methodName,
  required String kind,
}) {
  final int lineNumber = lineInfo.getLocation(offset).lineNumber;
  entries.add(
    _MethodEntry(
      filePath: filePath,
      lineNumber: lineNumber,
      owner: owner,
      methodName: methodName,
      kind: kind,
    ),
  );
}

String _buildReport({
  required List<_MethodEntry> dartEntries,
  required List<_MethodEntry> javaEntries,
}) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('# Public Methods Inventory');
  buffer.writeln();
  buffer.writeln(
    '- Generated by: `tool/generate_public_methods_inventory.dart`',
  );
  buffer.writeln('- FE public methods (Dart): ${dartEntries.length}');
  buffer.writeln('- BE public methods (Java): ${javaEntries.length}');
  buffer.writeln();
  buffer.writeln('## FE (Dart)');
  _appendEntries(buffer: buffer, entries: dartEntries);
  buffer.writeln();
  buffer.writeln('## BE (Java)');
  _appendEntries(buffer: buffer, entries: javaEntries);
  return buffer.toString();
}

void _appendEntries({
  required StringBuffer buffer,
  required List<_MethodEntry> entries,
}) {
  if (entries.isEmpty) {
    buffer.writeln('_No entries found._');
    return;
  }
  String? currentFile;
  for (final _MethodEntry entry in entries) {
    if (currentFile != entry.filePath) {
      currentFile = entry.filePath;
      buffer.writeln();
      buffer.writeln('### `$currentFile`');
    }
    buffer.writeln(
      '- L${entry.lineNumber}: `${entry.owner}.${entry.methodName}` (${entry.kind})',
    );
  }
}

bool _isDartSourcePath(String path) {
  if (!path.endsWith('.dart')) {
    return false;
  }
  for (final String suffix in _dartExcludedSuffixes) {
    if (path.endsWith(suffix)) {
      return false;
    }
  }
  for (final String prefix in _dartExcludedPrefixes) {
    if (path.startsWith(prefix)) {
      return false;
    }
  }
  return true;
}

bool _isPrivateName(String value) {
  return value.startsWith('_');
}

String _normalizePath(String rawPath) {
  return rawPath.replaceAll('\\', '/');
}

int _sortEntries(_MethodEntry left, _MethodEntry right) {
  final int fileResult = left.filePath.compareTo(right.filePath);
  if (fileResult != 0) {
    return fileResult;
  }
  return left.lineNumber.compareTo(right.lineNumber);
}

class _MethodEntry {
  const _MethodEntry({
    required this.filePath,
    required this.lineNumber,
    required this.owner,
    required this.methodName,
    required this.kind,
  });

  final String filePath;
  final int lineNumber;
  final String owner;
  final String methodName;
  final String kind;
}
