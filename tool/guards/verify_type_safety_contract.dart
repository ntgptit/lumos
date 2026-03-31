import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'guard_utils.dart';

class TypeSafetyGuardConst {
  const TypeSafetyGuardConst._();

  static const String sharedRoot = 'lib/presentation/shared';
  static const String allowObjectMarker =
      'type-safety-guard: allow-object-param';
  static const Set<String> widgetSuperTypes = <String>{
    'StatelessWidget',
    'StatefulWidget',
    'ConsumerWidget',
    'ConsumerStatefulWidget',
    'HookWidget',
    'HookConsumerWidget',
  };
  static const Set<String> forbiddenTypeSources = <String>{
    'Object',
    'Object?',
    'dynamic',
  };
}

class TypeSafetyViolation {
  const TypeSafetyViolation({
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

class _TypeSafetyFileContext {
  const _TypeSafetyFileContext({
    required this.path,
    required this.lines,
    required this.lineInfo,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
}

class _FieldContractInfo {
  const _FieldContractInfo({
    required this.typeSource,
    required this.lineNumber,
    required this.hasAllowMarker,
  });

  final String typeSource;
  final int lineNumber;
  final bool hasAllowMarker;
}

Future<void> main() async {
  final Directory root = Directory(TypeSafetyGuardConst.sharedRoot);
  if (!root.existsSync()) {
    stderr.writeln('Missing `${TypeSafetyGuardConst.sharedRoot}` directory.');
    exitCode = 1;
    return;
  }

  final List<TypeSafetyViolation> violations = <TypeSafetyViolation>[];
  final List<File> files = collectTrackedDartFiles(<String>[
    TypeSafetyGuardConst.sharedRoot,
  ]);

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    final String source = await file.readAsString();
    final parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final _TypeSafetyVisitor visitor = _TypeSafetyVisitor(
      fileContext: _TypeSafetyFileContext(
        path: path,
        lines: source.split('\n'),
        lineInfo: parsed.lineInfo,
      ),
      violations: violations,
    );
    parsed.unit.accept(visitor);
  }

  if (violations.isEmpty) {
    stdout.writeln('Type safety contract passed.');
    return;
  }

  stderr.writeln('Type safety contract failed.');
  for (final TypeSafetyViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

class _TypeSafetyVisitor extends RecursiveAstVisitor<void> {
  _TypeSafetyVisitor({required this.fileContext, required this.violations});

  final _TypeSafetyFileContext fileContext;
  final List<TypeSafetyViolation> violations;
  final Set<String> _dedupeKeys = <String>{};

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (!_isTrackedWidgetClass(node)) {
      super.visitClassDeclaration(node);
      return;
    }

    final Map<String, _FieldContractInfo> fieldInfoByName = _collectFieldInfo(
      node,
    );
    _checkFieldDeclarations(node);
    _checkConstructors(node, fieldInfoByName);

    super.visitClassDeclaration(node);
  }

  void _checkFieldDeclarations(ClassDeclaration node) {
    for (final ClassMember member in node.members) {
      if (member is! FieldDeclaration) {
        continue;
      }

      final TypeAnnotation? type = member.fields.type;
      final String typeSource = _typeSourceOf(type);
      if (!_isForbiddenTypeSource(typeSource)) {
        continue;
      }

      final int lineNumber = fileContext.lineInfo
          .getLocation(member.offset)
          .lineNumber;
      final bool hasAllowMarker =
          lineHasMarker(
            lines: fileContext.lines,
            lineNumber: lineNumber,
            marker: TypeSafetyGuardConst.allowObjectMarker,
          ) ||
          nodeHasMarker(
            node: member,
            lines: fileContext.lines,
            lineInfo: fileContext.lineInfo,
            marker: TypeSafetyGuardConst.allowObjectMarker,
          );
      if (hasAllowMarker) {
        continue;
      }

      for (final VariableDeclaration variable in member.fields.variables) {
        _addViolation(
          lineNumber: lineNumber,
          dedupeSuffix: 'field:${variable.name.lexeme}',
          reason:
              'Shared widget field `${variable.name.lexeme}` must not use `$typeSource` as a catch-all type. Prefer a specific type or a generic parameter.',
        );
      }
    }
  }

  void _checkConstructors(
    ClassDeclaration node,
    Map<String, _FieldContractInfo> fieldInfoByName,
  ) {
    for (final ClassMember member in node.members) {
      if (member is! ConstructorDeclaration) {
        continue;
      }

      for (final FormalParameter parameter in member.parameters.parameters) {
        _checkConstructorParameter(parameter, fieldInfoByName);
      }
    }
  }

  void _checkConstructorParameter(
    FormalParameter parameter,
    Map<String, _FieldContractInfo> fieldInfoByName,
  ) {
    final FormalParameter effectiveParameter = _unwrapDefaultParameter(
      parameter,
    );
    final String typeSource = _resolveParameterTypeSource(
      effectiveParameter,
      fieldInfoByName,
    );
    if (!_isForbiddenTypeSource(typeSource)) {
      return;
    }

    final String parameterName = _resolveParameterName(effectiveParameter);
    if (parameterName.isEmpty) {
      return;
    }

    final int lineNumber = fileContext.lineInfo
        .getLocation(effectiveParameter.offset)
        .lineNumber;
    final bool hasAllowMarker =
        lineHasMarker(
          lines: fileContext.lines,
          lineNumber: lineNumber,
          marker: TypeSafetyGuardConst.allowObjectMarker,
        ) ||
        nodeHasMarker(
          node: effectiveParameter,
          lines: fileContext.lines,
          lineInfo: fileContext.lineInfo,
          marker: TypeSafetyGuardConst.allowObjectMarker,
        ) ||
        _hasFieldAllowMarker(
          parameterName: parameterName,
          fieldInfoByName: fieldInfoByName,
        );
    if (hasAllowMarker) {
      return;
    }

    _addViolation(
      lineNumber: lineNumber,
      dedupeSuffix: 'parameter:$parameterName',
      reason:
          'Shared widget constructor parameter `$parameterName` must not use `$typeSource` as a catch-all type. Prefer a specific type or a generic parameter.',
    );
  }

  Map<String, _FieldContractInfo> _collectFieldInfo(ClassDeclaration node) {
    final Map<String, _FieldContractInfo> fieldInfoByName =
        <String, _FieldContractInfo>{};

    for (final ClassMember member in node.members) {
      if (member is! FieldDeclaration) {
        continue;
      }

      final String typeSource = _typeSourceOf(member.fields.type);
      if (typeSource.isEmpty) {
        continue;
      }

      final int lineNumber = fileContext.lineInfo
          .getLocation(member.offset)
          .lineNumber;
      final bool hasAllowMarker =
          lineHasMarker(
            lines: fileContext.lines,
            lineNumber: lineNumber,
            marker: TypeSafetyGuardConst.allowObjectMarker,
          ) ||
          nodeHasMarker(
            node: member,
            lines: fileContext.lines,
            lineInfo: fileContext.lineInfo,
            marker: TypeSafetyGuardConst.allowObjectMarker,
          );

      for (final VariableDeclaration variable in member.fields.variables) {
        fieldInfoByName[variable.name.lexeme] = _FieldContractInfo(
          typeSource: typeSource,
          lineNumber: lineNumber,
          hasAllowMarker: hasAllowMarker,
        );
      }
    }

    return fieldInfoByName;
  }

  bool _hasFieldAllowMarker({
    required String parameterName,
    required Map<String, _FieldContractInfo> fieldInfoByName,
  }) {
    final _FieldContractInfo? fieldInfo = fieldInfoByName[parameterName];
    if (fieldInfo == null) {
      return false;
    }
    return fieldInfo.hasAllowMarker;
  }

  void _addViolation({
    required int lineNumber,
    required String dedupeSuffix,
    required String reason,
  }) {
    final String dedupeKey = '${fileContext.path}:$lineNumber:$dedupeSuffix';
    if (!_dedupeKeys.add(dedupeKey)) {
      return;
    }

    violations.add(
      TypeSafetyViolation(
        filePath: fileContext.path,
        lineNumber: lineNumber,
        reason: reason,
        lineContent: lineContentAt(fileContext.lines, lineNumber),
      ),
    );
  }
}

FormalParameter _unwrapDefaultParameter(FormalParameter parameter) {
  if (parameter is! DefaultFormalParameter) {
    return parameter;
  }
  return parameter.parameter;
}

String _resolveParameterTypeSource(
  FormalParameter parameter,
  Map<String, _FieldContractInfo> fieldInfoByName,
) {
  if (parameter is SimpleFormalParameter) {
    return _typeSourceOf(parameter.type);
  }
  if (parameter is FieldFormalParameter) {
    final String directType = _typeSourceOf(parameter.type);
    if (directType.isNotEmpty) {
      return directType;
    }
    final String parameterName = _resolveParameterName(parameter);
    final _FieldContractInfo? fieldInfo = fieldInfoByName[parameterName];
    if (fieldInfo == null) {
      return '';
    }
    return fieldInfo.typeSource;
  }
  if (parameter is SuperFormalParameter) {
    return _typeSourceOf(parameter.type);
  }
  return '';
}

String _resolveParameterName(FormalParameter parameter) {
  if (parameter is SimpleFormalParameter) {
    return parameter.name?.lexeme ?? '';
  }
  if (parameter is FieldFormalParameter) {
    return parameter.name.lexeme;
  }
  if (parameter is SuperFormalParameter) {
    return parameter.name.lexeme;
  }
  if (parameter is FunctionTypedFormalParameter) {
    return parameter.name.lexeme;
  }
  return '';
}

bool _isTrackedWidgetClass(ClassDeclaration node) {
  final ExtendsClause? extendsClause = node.extendsClause;
  if (extendsClause == null) {
    return false;
  }

  final String superType = extendsClause.superclass
      .toSource()
      .split('.')
      .last
      .trim();
  return TypeSafetyGuardConst.widgetSuperTypes.contains(superType);
}

String _typeSourceOf(TypeAnnotation? type) {
  if (type == null) {
    return '';
  }
  return type.toSource().trim();
}

bool _isForbiddenTypeSource(String typeSource) {
  if (typeSource.isEmpty) {
    return false;
  }
  return TypeSafetyGuardConst.forbiddenTypeSources.contains(typeSource);
}
