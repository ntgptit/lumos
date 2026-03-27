import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

class L10nUsageGuardConst {
  const L10nUsageGuardConst._();

  static const Set<String> scanRoots = <String>{
    'lib/presentation',
    'lib/main.dart',
  };
  static const String allowLiteralMarker = 'l10n-guard: allow-literal';

  static const Set<String> trackedTextWidgets = <String>{
    'Text',
    'SelectableText',
    'LumosText',
  };

  static const Set<String> trackedNamedArguments = <String>{
    'label',
    'labelText',
    'hintText',
    'helperText',
    'errorText',
    'tooltip',
    'title',
    'subtitle',
    'text',
    'semanticLabel',
    'buttonLabel',
    'message',
  };

  static const String l10nFacadePath = 'lib/l10n/l10n.dart';

}

class L10nUsageViolation {
  const L10nUsageViolation({
    required this.filePath,
    required this.lineNumber,
    required this.reason,
    required this.lineContent,
  });

  final String filePath;
  final int lineNumber;
  final String reason;
  final String lineContent;

  String toConsoleLine() {
    return '$filePath:$lineNumber: $reason :: $lineContent';
  }
}

class _FacadeViolation {
  const _FacadeViolation({
    required this.filePath,
    required this.lineNumber,
    required this.reason,
    required this.lineContent,
  });

  final String filePath;
  final int lineNumber;
  final String reason;
  final String lineContent;

  L10nUsageViolation toViolation() {
    return L10nUsageViolation(
      filePath: filePath,
      lineNumber: lineNumber,
      reason: reason,
      lineContent: lineContent,
    );
  }
}

class _FileContext {
  const _FileContext({
    required this.path,
    required this.lines,
    required this.lineInfo,
    required this.unit,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
  final CompilationUnit unit;
}

Future<void> main() async {
  final List<File> files = _collectScanFiles();
  if (files.isEmpty) {
    stderr.writeln(
      'Missing l10n scan targets: ${L10nUsageGuardConst.scanRoots.join(', ')}.',
    );
    exitCode = 1;
    return;
  }

  final List<L10nUsageViolation> violations = <L10nUsageViolation>[];

  for (final File file in files) {
    final String path = _normalizePath(file.path);
    final String source = await file.readAsString();
    final parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final _FileContext fileContext = _FileContext(
      path: path,
      lines: source.split('\n'),
      lineInfo: parsed.lineInfo,
      unit: parsed.unit,
    );
    final _L10nUsageVisitor visitor = _L10nUsageVisitor(fileContext);
    fileContext.unit.accept(visitor);
    violations.addAll(visitor.violations);
  }

  violations.addAll(await _collectFacadeViolations());

  if (violations.isEmpty) {
    stdout.writeln('L10n usage contract passed.');
    return;
  }

  stderr.writeln('L10n usage contract failed.');
  for (final L10nUsageViolation violation in violations) {
    stderr.writeln(violation.toConsoleLine());
  }
  exitCode = 1;
}

Future<List<L10nUsageViolation>> _collectFacadeViolations() async {
  final File file = File(L10nUsageGuardConst.l10nFacadePath);
  if (!file.existsSync()) {
    return <L10nUsageViolation>[];
  }

  final String path = _normalizePath(file.path);
  final String source = await file.readAsString();
  final parsed = parseString(
    content: source,
    path: path,
    throwIfDiagnostics: false,
  );
  final List<String> lines = source.split('\n');
  final _L10nFacadeVisitor visitor = _L10nFacadeVisitor(
    path: path,
    lines: lines,
    lineInfo: parsed.lineInfo,
  );
  parsed.unit.accept(visitor);
  return visitor.violations.map((_FacadeViolation item) => item.toViolation()).toList();
}

List<File> _collectScanFiles() {
  final Set<String> seenPaths = <String>{};
  final List<File> files = <File>[];
  for (final String scanRoot in L10nUsageGuardConst.scanRoots) {
    final FileSystemEntityType entityType = FileSystemEntity.typeSync(scanRoot);
    if (entityType == FileSystemEntityType.notFound) {
      continue;
    }
    if (entityType == FileSystemEntityType.file) {
      if (_isTrackedDartFile(scanRoot) && seenPaths.add(scanRoot)) {
        files.add(File(scanRoot));
      }
      continue;
    }
    final Directory directory = Directory(scanRoot);
    final Iterable<File> nestedFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => _isTrackedDartFile(file.path));
    for (final File file in nestedFiles) {
      if (!seenPaths.add(file.path)) {
        continue;
      }
      files.add(file);
    }
  }
  return files;
}

bool _isTrackedDartFile(String path) {
  return path.endsWith('.dart') &&
      !path.endsWith('.g.dart') &&
      !path.endsWith('.freezed.dart');
}

class _L10nUsageVisitor extends RecursiveAstVisitor<void> {
  _L10nUsageVisitor(this._fileContext);

  final _FileContext _fileContext;
  final List<L10nUsageViolation> violations = <L10nUsageViolation>[];
  final Set<String> _dedupeKeys = <String>{};

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final String owner = node.constructorName.type.name.lexeme;

    if (L10nUsageGuardConst.trackedTextWidgets.contains(owner)) {
      final Expression? firstArgument = node.argumentList.arguments.isEmpty
          ? null
          : node.argumentList.arguments.first;
      _checkLiteralExpression(
        expression: firstArgument,
        reason:
            'User-visible text literal detected in $owner. Use AppLocalizations instead of hardcoded text.',
      );
    }

    for (final Expression argument in node.argumentList.arguments) {
      if (argument is! NamedExpression) {
        continue;
      }
      final String argumentName = argument.name.label.name;
      if (!L10nUsageGuardConst.trackedNamedArguments.contains(argumentName)) {
        continue;
      }
      _checkLiteralExpression(
        expression: argument.expression,
        reason:
            'User-visible text literal detected in `$argumentName` of $owner. Use AppLocalizations instead of hardcoded text.',
      );
    }

    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitNamedExpression(NamedExpression node) {
    final String argumentName = node.name.label.name;
    if (!L10nUsageGuardConst.trackedNamedArguments.contains(argumentName)) {
      super.visitNamedExpression(node);
      return;
    }
    final AstNode? parent = node.parent;
    final String owner = _resolveOwnerName(parent);
    _checkLiteralExpression(
      expression: node.expression,
      reason:
          'User-visible text literal detected in `$argumentName` of $owner. Use AppLocalizations instead of hardcoded text.',
    );
    super.visitNamedExpression(node);
  }

  void _checkLiteralExpression({
    required Expression? expression,
    required String reason,
  }) {
    if (expression == null) {
      return;
    }
    final String? value = _resolveTrackedLiteral(expression);
    if (value == null) {
      return;
    }
    if (value.trim().isEmpty) {
      return;
    }

    final int lineNumber = _fileContext.lineInfo.getLocation(expression.offset).lineNumber;
    final String lineContent = _lineContentAt(_fileContext.lines, lineNumber);
    if (lineContent.contains(L10nUsageGuardConst.allowLiteralMarker)) {
      return;
    }

    final String dedupeKey = '${_fileContext.path}:$lineNumber:${value.trim()}';
    if (_dedupeKeys.contains(dedupeKey)) {
      return;
    }
    _dedupeKeys.add(dedupeKey);
    violations.add(
      L10nUsageViolation(
        filePath: _fileContext.path,
        lineNumber: lineNumber,
        reason: reason,
        lineContent: lineContent,
      ),
    );
  }

  String? _resolveTrackedLiteral(Expression expression) {
    if (expression is StringLiteral) {
      return expression.stringValue;
    }
    if (expression is StringInterpolation) {
      final String buffer = expression.elements
          .whereType<InterpolationString>()
          .map((InterpolationString element) => element.value)
          .join()
          .trim();
      if (buffer.isNotEmpty) {
        return buffer;
      }
      if (expression.elements.whereType<InterpolationExpression>().isNotEmpty) {
        return '__interpolated_literal__';
      }
    }
    return null;
  }

  String _resolveOwnerName(AstNode? parent) {
    if (parent is ArgumentList && parent.parent is InstanceCreationExpression) {
      final InstanceCreationExpression creation =
          parent.parent! as InstanceCreationExpression;
      return creation.constructorName.type.name.lexeme;
    }
    if (parent is ArgumentList && parent.parent is MethodInvocation) {
      final MethodInvocation invocation = parent.parent! as MethodInvocation;
      return invocation.methodName.name;
    }
    return 'unknown owner';
  }
}

class _L10nFacadeVisitor extends RecursiveAstVisitor<void> {
  _L10nFacadeVisitor({
    required this.path,
    required this.lines,
    required this.lineInfo,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
  final List<_FacadeViolation> violations = <_FacadeViolation>[];

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    final String source = node.toSource();
    if (!source.contains(' on AppLocalizations')) {
      super.visitExtensionDeclaration(node);
      return;
    }

    final int lineNumber = lineInfo.getLocation(node.offset).lineNumber;
    violations.add(
      _FacadeViolation(
        filePath: path,
        lineNumber: lineNumber,
        reason:
            'Do not add compatibility extensions on AppLocalizations in lib/l10n/l10n.dart. Add keys to *.arb and regenerate l10n instead.',
        lineContent: _lineContentAt(lines, lineNumber),
      ),
    );
    super.visitExtensionDeclaration(node);
  }
}

String _lineContentAt(List<String> lines, int lineNumber) {
  if (lineNumber <= 0 || lineNumber > lines.length) {
    return '';
  }
  return lines[lineNumber - 1].trim();
}

String _normalizePath(String path) {
  return path.replaceAll('\\', '/');
}
