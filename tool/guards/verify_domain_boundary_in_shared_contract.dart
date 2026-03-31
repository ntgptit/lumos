import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'guard_utils.dart';

class DomainBoundaryInSharedGuardConst {
  const DomainBoundaryInSharedGuardConst._();

  static const String sharedRoot = 'lib/presentation/shared';
  static const String allowDomainMarker =
      'domain-boundary-guard: allow-domain-in-shared';
  static const Set<String> blacklistedDirectoryNames = <String>{
    'study',
    'flashcard',
    'deck',
    'folder',
    'progress',
    'auth',
    'profile',
    'home',
    'quiz',
    'exam',
  };
  static const Set<String> blacklistedClassKeywords = <String>{
    'study',
    'flashcard',
    'deck',
    'folder',
    'progress',
    'auth',
    'profile',
    'home',
    'quiz',
    'exam',
  };
}

class DomainBoundaryInSharedViolation {
  const DomainBoundaryInSharedViolation({
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

class _DomainBoundaryFileContext {
  const _DomainBoundaryFileContext({
    required this.path,
    required this.lines,
    required this.lineInfo,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
}

Future<void> main() async {
  final Directory root = Directory(DomainBoundaryInSharedGuardConst.sharedRoot);
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${DomainBoundaryInSharedGuardConst.sharedRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<DomainBoundaryInSharedViolation> violations =
      <DomainBoundaryInSharedViolation>[];

  await _collectDirectoryViolations(violations);
  await _collectClassViolations(violations);

  if (violations.isEmpty) {
    stdout.writeln('Domain boundary in shared contract passed.');
    return;
  }

  stderr.writeln('Domain boundary in shared contract failed.');
  for (final DomainBoundaryInSharedViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

Future<void> _collectDirectoryViolations(
  List<DomainBoundaryInSharedViolation> violations,
) async {
  final Directory root = Directory(DomainBoundaryInSharedGuardConst.sharedRoot);
  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! Directory) {
      continue;
    }

    final String path = normalizeGuardPath(entity.path);
    final String directoryName = path.split('/').last.toLowerCase();
    if (!DomainBoundaryInSharedGuardConst.blacklistedDirectoryNames.contains(
      directoryName,
    )) {
      continue;
    }
    if (await _directoryHasAllowMarker(entity)) {
      continue;
    }

    violations.add(
      DomainBoundaryInSharedViolation(
        filePath: path,
        lineNumber: 1,
        reason:
            'Shared layer must stay domain-agnostic. Directory `$directoryName` should move to a feature-owned path instead of `presentation/shared`.',
        lineContent: path,
      ),
    );
  }
}

Future<void> _collectClassViolations(
  List<DomainBoundaryInSharedViolation> violations,
) async {
  final List<File> files = collectTrackedDartFiles(<String>[
    DomainBoundaryInSharedGuardConst.sharedRoot,
  ]);

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    final String source = await file.readAsString();
    final parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final _DomainBoundaryClassVisitor visitor = _DomainBoundaryClassVisitor(
      fileContext: _DomainBoundaryFileContext(
        path: path,
        lines: source.split('\n'),
        lineInfo: parsed.lineInfo,
      ),
      violations: violations,
    );
    parsed.unit.accept(visitor);
  }
}

class _DomainBoundaryClassVisitor extends RecursiveAstVisitor<void> {
  _DomainBoundaryClassVisitor({
    required this.fileContext,
    required this.violations,
  });

  final _DomainBoundaryFileContext fileContext;
  final List<DomainBoundaryInSharedViolation> violations;
  final Set<String> _dedupeKeys = <String>{};

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final bool hasAllowMarker = nodeHasMarker(
      node: node,
      lines: fileContext.lines,
      lineInfo: fileContext.lineInfo,
      marker: DomainBoundaryInSharedGuardConst.allowDomainMarker,
    );
    if (hasAllowMarker) {
      super.visitClassDeclaration(node);
      return;
    }

    final String className = node.name.lexeme;
    if (!_containsDomainKeyword(className)) {
      super.visitClassDeclaration(node);
      return;
    }
    if (_isAllowedStudySessionName(className)) {
      super.visitClassDeclaration(node);
      return;
    }

    final int lineNumber = fileContext.lineInfo
        .getLocation(node.offset)
        .lineNumber;
    final String dedupeKey = '${fileContext.path}:$lineNumber:$className';
    if (!_dedupeKeys.add(dedupeKey)) {
      super.visitClassDeclaration(node);
      return;
    }

    violations.add(
      DomainBoundaryInSharedViolation(
        filePath: fileContext.path,
        lineNumber: lineNumber,
        reason:
            'Warning: shared class `$className` contains a domain keyword. Move it to a feature package or rename it to a domain-agnostic shared pattern.',
        lineContent: lineContentAt(fileContext.lines, lineNumber),
      ),
    );

    super.visitClassDeclaration(node);
  }
}

Future<bool> _directoryHasAllowMarker(Directory directory) async {
  final List<File> files = collectTrackedDartFiles(<String>[directory.path]);
  for (final File file in files) {
    final List<String> lines = await file.readAsLines();
    if (!fileHasMarker(
      lines: lines,
      marker: DomainBoundaryInSharedGuardConst.allowDomainMarker,
    )) {
      continue;
    }
    return true;
  }
  return false;
}

bool _containsDomainKeyword(String className) {
  final String normalizedName = className.toLowerCase();
  for (final String keyword
      in DomainBoundaryInSharedGuardConst.blacklistedClassKeywords) {
    if (!normalizedName.contains(keyword)) {
      continue;
    }
    return true;
  }
  return false;
}

bool _isAllowedStudySessionName(String className) {
  final String normalizedName = className.toLowerCase();
  if (!normalizedName.contains('studysession')) {
    return false;
  }
  return true;
}
