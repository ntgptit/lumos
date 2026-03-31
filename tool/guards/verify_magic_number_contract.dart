import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'guard_utils.dart';

class MagicNumberGuardConst {
  const MagicNumberGuardConst._();

  static const String featuresRoot = 'lib/presentation/features';
  static const String screensMarker = '/screens/';
  static const String widgetsMarker = '/widgets/';
  static const String allowLiteralMarker = 'magic-number-guard: allow-literal';
  static const List<double> allowedLiterals = <double>[0, 1, 2, 0.5];
}

class MagicNumberViolation {
  const MagicNumberViolation({
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

class _MagicNumberFileContext {
  const _MagicNumberFileContext({
    required this.path,
    required this.lines,
    required this.lineInfo,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
}

Future<void> main() async {
  final Directory root = Directory(MagicNumberGuardConst.featuresRoot);
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${MagicNumberGuardConst.featuresRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<MagicNumberViolation> violations = <MagicNumberViolation>[];
  final List<File> files = collectTrackedDartFiles(<String>[
    MagicNumberGuardConst.featuresRoot,
  ]);

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    if (!_isTrackedFeatureUiPath(path)) {
      continue;
    }

    final String source = await file.readAsString();
    final parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final _MagicNumberVisitor visitor = _MagicNumberVisitor(
      fileContext: _MagicNumberFileContext(
        path: path,
        lines: source.split('\n'),
        lineInfo: parsed.lineInfo,
      ),
      violations: violations,
    );
    parsed.unit.accept(visitor);
  }

  if (violations.isEmpty) {
    stdout.writeln('Magic number contract passed.');
    return;
  }

  stderr.writeln('Magic number contract failed.');
  for (final MagicNumberViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

class _MagicNumberVisitor extends RecursiveAstVisitor<void> {
  _MagicNumberVisitor({required this.fileContext, required this.violations});

  final _MagicNumberFileContext fileContext;
  final List<MagicNumberViolation> violations;
  final Set<String> _dedupeKeys = <String>{};

  @override
  void visitBinaryExpression(BinaryExpression node) {
    if (node.operator.lexeme != '<') {
      super.visitBinaryExpression(node);
      return;
    }

    final String leftSource = node.leftOperand.toSource().replaceAll(' ', '');
    if (leftSource != 'constraints.maxHeight' &&
        leftSource != 'constraints.maxWidth') {
      super.visitBinaryExpression(node);
      return;
    }

    final Expression rightOperand = _unwrapParenthesized(node.rightOperand);
    final num? literalValue = _resolveNumericLiteral(rightOperand);
    if (literalValue == null) {
      super.visitBinaryExpression(node);
      return;
    }
    if (MagicNumberGuardConst.allowedLiterals.contains(
      literalValue.toDouble(),
    )) {
      super.visitBinaryExpression(node);
      return;
    }

    final bool hasAllowMarker = nodeHasMarker(
      node: node,
      lines: fileContext.lines,
      lineInfo: fileContext.lineInfo,
      marker: MagicNumberGuardConst.allowLiteralMarker,
    );
    if (hasAllowMarker) {
      super.visitBinaryExpression(node);
      return;
    }

    final int lineNumber = fileContext.lineInfo
        .getLocation(node.offset)
        .lineNumber;
    final String dedupeKey =
        '${fileContext.path}:$lineNumber:$leftSource:$literalValue';
    if (!_dedupeKeys.add(dedupeKey)) {
      super.visitBinaryExpression(node);
      return;
    }

    violations.add(
      MagicNumberViolation(
        filePath: fileContext.path,
        lineNumber: lineNumber,
        reason:
            'Breakpoint/layout comparison should use centralized token or context extension instead of literal `$literalValue`.',
        lineContent: lineContentAt(fileContext.lines, lineNumber),
      ),
    );

    super.visitBinaryExpression(node);
  }
}

bool _isTrackedFeatureUiPath(String path) {
  if (!path.startsWith(MagicNumberGuardConst.featuresRoot)) {
    return false;
  }
  if (path.contains(MagicNumberGuardConst.screensMarker)) {
    return true;
  }
  if (path.contains(MagicNumberGuardConst.widgetsMarker)) {
    return true;
  }
  return false;
}

Expression _unwrapParenthesized(Expression expression) {
  if (expression is! ParenthesizedExpression) {
    return expression;
  }
  return _unwrapParenthesized(expression.expression);
}

num? _resolveNumericLiteral(Expression expression) {
  if (expression is IntegerLiteral) {
    return expression.value;
  }
  if (expression is DoubleLiteral) {
    return expression.value;
  }
  return null;
}
