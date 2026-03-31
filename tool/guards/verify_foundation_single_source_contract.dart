import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'guard_utils.dart';

class FoundationSingleSourceGuardConst {
  const FoundationSingleSourceGuardConst._();

  static const List<String> scanRoots = <String>[
    'lib/presentation/features',
    'lib/presentation/shared',
  ];
  static const String coreThemeRoot = 'lib/core/theme/';
  static const String lumosSpacingDefinePath =
      'lib/presentation/shared/primitives/layout/lumos_spacing.dart';
  static const String allowStaticTokenMarker =
      'foundation-source-guard: allow-static-token';
  static const Map<String, String> forbiddenStaticOwners = <String, String>{
    'LumosSpacing':
        'Dùng `context.spacing.xxx` hoặc widget `LumosSpacing(...)`, không dùng `LumosSpacing.xxx` static const trong presentation layer.',
    'AppSpacingTokens':
        'Dùng `context.spacing.xxx` thay vì `AppSpacingTokens.xxx` trực tiếp trong presentation layer.',
    'IconSizes':
        'Dùng responsive/context extension thay vì `IconSizes.xxx` trực tiếp trong presentation layer.',
    'WidgetSizes':
        'Dùng `context.componentSize` hoặc responsive/context extension thay vì `WidgetSizes.xxx` trực tiếp trong presentation layer.',
    'BorderRadii':
        'Dùng `context.radius.xxx` thay vì `BorderRadii.xxx` trực tiếp trong presentation layer.',
    'FontSizes':
        'Dùng `context.textTheme` hoặc typography/context extension thay vì `FontSizes.xxx` trực tiếp trong presentation layer.',
    'AppDurations':
        'Dùng motion/context extension hoặc centralized animation API thay vì `AppDurations.xxx` trực tiếp trong presentation layer.',
  };
}

class FoundationSingleSourceViolation {
  const FoundationSingleSourceViolation({
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

class _FoundationFileContext {
  const _FoundationFileContext({
    required this.path,
    required this.lines,
    required this.lineInfo,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
}

Future<void> main() async {
  final List<File> files = collectTrackedDartFiles(
    FoundationSingleSourceGuardConst.scanRoots,
  );
  if (files.isEmpty) {
    stderr.writeln(
      'Missing foundation scan targets: ${FoundationSingleSourceGuardConst.scanRoots.join(', ')}.',
    );
    exitCode = 1;
    return;
  }

  final List<FoundationSingleSourceViolation> violations =
      <FoundationSingleSourceViolation>[];

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    if (_isAllowedPath(path)) {
      continue;
    }

    final String source = await file.readAsString();
    final parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final _FoundationSingleSourceVisitor visitor =
        _FoundationSingleSourceVisitor(
          fileContext: _FoundationFileContext(
            path: path,
            lines: source.split('\n'),
            lineInfo: parsed.lineInfo,
          ),
          violations: violations,
        );
    parsed.unit.accept(visitor);
  }

  if (violations.isEmpty) {
    stdout.writeln('Foundation single source contract passed.');
    return;
  }

  stderr.writeln('Foundation single source contract failed.');
  for (final FoundationSingleSourceViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

class _FoundationSingleSourceVisitor extends RecursiveAstVisitor<void> {
  _FoundationSingleSourceVisitor({
    required this.fileContext,
    required this.violations,
  });

  final _FoundationFileContext fileContext;
  final List<FoundationSingleSourceViolation> violations;
  final Set<String> _dedupeKeys = <String>{};

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    _checkStaticAccess(
      owner: node.prefix.name,
      propertyName: node.identifier.name,
      node: node,
    );
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    final Expression? target = node.target;
    if (target is! SimpleIdentifier) {
      super.visitPropertyAccess(node);
      return;
    }
    _checkStaticAccess(
      owner: target.name,
      propertyName: node.propertyName.name,
      node: node,
    );
    super.visitPropertyAccess(node);
  }

  void _checkStaticAccess({
    required String owner,
    required String propertyName,
    required AstNode node,
  }) {
    final String? reason =
        FoundationSingleSourceGuardConst.forbiddenStaticOwners[owner];
    if (reason == null) {
      return;
    }

    final bool hasAllowMarker = nodeHasMarker(
      node: node,
      lines: fileContext.lines,
      lineInfo: fileContext.lineInfo,
      marker: FoundationSingleSourceGuardConst.allowStaticTokenMarker,
    );
    if (hasAllowMarker) {
      return;
    }

    final int lineNumber = fileContext.lineInfo
        .getLocation(node.offset)
        .lineNumber;
    final String dedupeKey =
        '${fileContext.path}:$lineNumber:$owner.$propertyName';
    if (!_dedupeKeys.add(dedupeKey)) {
      return;
    }

    violations.add(
      FoundationSingleSourceViolation(
        filePath: fileContext.path,
        lineNumber: lineNumber,
        reason: reason,
        lineContent: lineContentAt(fileContext.lines, lineNumber),
      ),
    );
  }
}

bool _isAllowedPath(String path) {
  if (path.startsWith(FoundationSingleSourceGuardConst.coreThemeRoot)) {
    return true;
  }
  if (path == FoundationSingleSourceGuardConst.lumosSpacingDefinePath) {
    return true;
  }
  return false;
}
