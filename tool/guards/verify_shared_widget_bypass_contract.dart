import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'guard_utils.dart';

class SharedWidgetBypassGuardConst {
  const SharedWidgetBypassGuardConst._();

  static const String sharedRoot = 'lib/presentation/shared';
  static const String allowOverrideMarker =
      'widget-bypass-guard: allow-style-override';
  static const Set<String> widgetSuperTypes = <String>{
    'StatelessWidget',
    'StatefulWidget',
    'ConsumerWidget',
    'ConsumerStatefulWidget',
    'HookWidget',
    'HookConsumerWidget',
  };
  static const Set<String> rawTextStyleKnobNames = <String>{
    'fontSize',
    'fontWeight',
    'fontStyle',
    'letterSpacing',
    'fontFamily',
    'height',
    'wordSpacing',
  };
  static const Set<String> textWidgetBypassNames = <String>{
    'fontSize',
    'fontWeight',
    'fontStyle',
    'letterSpacing',
    'fontFamily',
  };
}

class SharedWidgetBypassViolation {
  const SharedWidgetBypassViolation({
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

class _SharedWidgetBypassFileContext {
  const _SharedWidgetBypassFileContext({
    required this.path,
    required this.lines,
    required this.lineInfo,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
}

class _WidgetFieldInfo {
  const _WidgetFieldInfo({
    required this.typeSource,
    required this.lineNumber,
    required this.hasAllowMarker,
  });

  final String typeSource;
  final int lineNumber;
  final bool hasAllowMarker;
}

class _WidgetParameterInfo {
  const _WidgetParameterInfo({
    required this.name,
    required this.typeSource,
    required this.lineNumber,
    required this.hasAllowMarker,
  });

  final String name;
  final String typeSource;
  final int lineNumber;
  final bool hasAllowMarker;
}

Future<void> main() async {
  final Directory root = Directory(SharedWidgetBypassGuardConst.sharedRoot);
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${SharedWidgetBypassGuardConst.sharedRoot}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<SharedWidgetBypassViolation> violations =
      <SharedWidgetBypassViolation>[];
  final List<File> files = collectTrackedDartFiles(<String>[
    SharedWidgetBypassGuardConst.sharedRoot,
  ]);

  for (final File file in files) {
    final String path = normalizeGuardPath(file.path);
    final String source = await file.readAsString();
    final parsed = parseString(
      content: source,
      path: path,
      throwIfDiagnostics: false,
    );
    final _SharedWidgetBypassVisitor visitor = _SharedWidgetBypassVisitor(
      fileContext: _SharedWidgetBypassFileContext(
        path: path,
        lines: source.split('\n'),
        lineInfo: parsed.lineInfo,
      ),
      violations: violations,
    );
    parsed.unit.accept(visitor);
  }

  if (violations.isEmpty) {
    stdout.writeln('Shared widget bypass contract passed.');
    return;
  }

  stderr.writeln('Shared widget bypass contract failed.');
  for (final SharedWidgetBypassViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

class _SharedWidgetBypassVisitor extends RecursiveAstVisitor<void> {
  _SharedWidgetBypassVisitor({
    required this.fileContext,
    required this.violations,
  });

  final _SharedWidgetBypassFileContext fileContext;
  final List<SharedWidgetBypassViolation> violations;
  final Set<String> _dedupeKeys = <String>{};

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (!_isTrackedWidgetClass(node)) {
      super.visitClassDeclaration(node);
      return;
    }

    final bool classHasAllowMarker = nodeHasMarker(
      node: node,
      lines: fileContext.lines,
      lineInfo: fileContext.lineInfo,
      marker: SharedWidgetBypassGuardConst.allowOverrideMarker,
    );
    if (classHasAllowMarker) {
      super.visitClassDeclaration(node);
      return;
    }

    final Map<String, _WidgetFieldInfo> fieldInfoByName = _collectFieldInfo(
      node,
    );
    final Map<String, _WidgetParameterInfo> parameterInfoByName =
        _collectParameterInfo(node, fieldInfoByName);

    _checkDirectBypassParams(parameterInfoByName);
    _checkRawTextStyleBypass(node, parameterInfoByName);
    _checkTextWidgetFontKnobs(node, parameterInfoByName);

    super.visitClassDeclaration(node);
  }

  void _checkDirectBypassParams(
    Map<String, _WidgetParameterInfo> parameterInfoByName,
  ) {
    for (final _WidgetParameterInfo parameter in parameterInfoByName.values) {
      if (parameter.hasAllowMarker) {
        continue;
      }

      if (parameter.name == 'style' &&
          _isButtonStyleType(parameter.typeSource)) {
        _addViolation(
          lineNumber: parameter.lineNumber,
          dedupeSuffix: 'style:${parameter.name}',
          reason:
              'Shared widget must not expose `style: ${parameter.typeSource}` because it lets feature callers bypass centralized button theming.',
        );
      }

      if (parameter.name == 'decoration' &&
          _isInputDecorationType(parameter.typeSource)) {
        _addViolation(
          lineNumber: parameter.lineNumber,
          dedupeSuffix: 'decoration:${parameter.name}',
          reason:
              'Shared widget must not expose `decoration: ${parameter.typeSource}` because it lets feature callers bypass centralized input theming.',
        );
      }
    }
  }

  void _checkRawTextStyleBypass(
    ClassDeclaration node,
    Map<String, _WidgetParameterInfo> parameterInfoByName,
  ) {
    final List<_WidgetParameterInfo> rawTextStyleKnobs = parameterInfoByName
        .values
        .where(_isRawTextStyleKnob)
        .where((item) => !item.hasAllowMarker)
        .toList(growable: false);
    if (rawTextStyleKnobs.length < 5) {
      return;
    }

    final int lineNumber = fileContext.lineInfo
        .getLocation(node.offset)
        .lineNumber;
    _addViolation(
      lineNumber: lineNumber,
      dedupeSuffix: 'raw-text-style-knobs:${node.name.lexeme}',
      reason:
          'Shared widget exposes ${rawTextStyleKnobs.length} raw text-style knobs (${rawTextStyleKnobs.map((item) => item.name).join(', ')}). Prefer a constrained variant API or a single mergeable `TextStyle?` instead of full style bypass.',
    );
  }

  void _checkTextWidgetFontKnobs(
    ClassDeclaration node,
    Map<String, _WidgetParameterInfo> parameterInfoByName,
  ) {
    if (!_isTextWidgetClass(node, fileContext.path)) {
      return;
    }

    final List<_WidgetParameterInfo> textWidgetKnobs = parameterInfoByName
        .values
        .where(
          (item) => SharedWidgetBypassGuardConst.textWidgetBypassNames.contains(
            item.name,
          ),
        )
        .where((item) => !item.hasAllowMarker)
        .toList(growable: false);
    if (textWidgetKnobs.length < 4) {
      return;
    }

    final int lineNumber = fileContext.lineInfo
        .getLocation(node.offset)
        .lineNumber;
    _addViolation(
      lineNumber: lineNumber,
      dedupeSuffix: 'text-widget-knobs:${node.name.lexeme}',
      reason:
          'Text-oriented shared widget exposes too many font override params (${textWidgetKnobs.map((item) => item.name).join(', ')}). Keep typography ownership in theme or a single mergeable `TextStyle?`.',
    );
  }

  Map<String, _WidgetFieldInfo> _collectFieldInfo(ClassDeclaration node) {
    final Map<String, _WidgetFieldInfo> fieldInfoByName =
        <String, _WidgetFieldInfo>{};

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
      final bool hasAllowMarker = nodeHasMarker(
        node: member,
        lines: fileContext.lines,
        lineInfo: fileContext.lineInfo,
        marker: SharedWidgetBypassGuardConst.allowOverrideMarker,
      );

      for (final VariableDeclaration variable in member.fields.variables) {
        fieldInfoByName[variable.name.lexeme] = _WidgetFieldInfo(
          typeSource: typeSource,
          lineNumber: lineNumber,
          hasAllowMarker: hasAllowMarker,
        );
      }
    }

    return fieldInfoByName;
  }

  Map<String, _WidgetParameterInfo> _collectParameterInfo(
    ClassDeclaration node,
    Map<String, _WidgetFieldInfo> fieldInfoByName,
  ) {
    final Map<String, _WidgetParameterInfo> parameterInfoByName =
        <String, _WidgetParameterInfo>{};

    for (final ClassMember member in node.members) {
      if (member is! ConstructorDeclaration) {
        continue;
      }

      final bool constructorHasAllowMarker = nodeHasMarker(
        node: member,
        lines: fileContext.lines,
        lineInfo: fileContext.lineInfo,
        marker: SharedWidgetBypassGuardConst.allowOverrideMarker,
      );

      for (final FormalParameter parameter in member.parameters.parameters) {
        final FormalParameter effectiveParameter = _unwrapDefaultParameter(
          parameter,
        );
        final String name = _resolveParameterName(effectiveParameter);
        if (name.isEmpty) {
          continue;
        }

        final String typeSource = _resolveParameterTypeSource(
          effectiveParameter,
          fieldInfoByName,
        );
        if (typeSource.isEmpty) {
          continue;
        }

        final int lineNumber = fileContext.lineInfo
            .getLocation(effectiveParameter.offset)
            .lineNumber;
        final _WidgetFieldInfo? fieldInfo = fieldInfoByName[name];
        final bool hasAllowMarker =
            constructorHasAllowMarker ||
            nodeHasMarker(
              node: effectiveParameter,
              lines: fileContext.lines,
              lineInfo: fileContext.lineInfo,
              marker: SharedWidgetBypassGuardConst.allowOverrideMarker,
            ) ||
            lineHasMarker(
              lines: fileContext.lines,
              lineNumber: lineNumber,
              marker: SharedWidgetBypassGuardConst.allowOverrideMarker,
            ) ||
            (fieldInfo?.hasAllowMarker ?? false);

        parameterInfoByName[name] = _WidgetParameterInfo(
          name: name,
          typeSource: typeSource,
          lineNumber: lineNumber,
          hasAllowMarker: hasAllowMarker,
        );
      }
    }

    return parameterInfoByName;
  }

  bool _isRawTextStyleKnob(_WidgetParameterInfo parameter) {
    if (SharedWidgetBypassGuardConst.rawTextStyleKnobNames.contains(
      parameter.name,
    )) {
      return true;
    }
    if (_isFontWeightType(parameter.typeSource)) {
      return true;
    }
    if (_isFontStyleType(parameter.typeSource)) {
      return true;
    }
    return false;
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
      SharedWidgetBypassViolation(
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
  Map<String, _WidgetFieldInfo> fieldInfoByName,
) {
  if (parameter is SimpleFormalParameter) {
    return _typeSourceOf(parameter.type);
  }
  if (parameter is FieldFormalParameter) {
    final String directType = _typeSourceOf(parameter.type);
    if (directType.isNotEmpty) {
      return directType;
    }
    final String name = _resolveParameterName(parameter);
    final _WidgetFieldInfo? fieldInfo = fieldInfoByName[name];
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
  return SharedWidgetBypassGuardConst.widgetSuperTypes.contains(superType);
}

bool _isTextWidgetClass(ClassDeclaration node, String path) {
  final String className = node.name.lexeme.toLowerCase();
  if (className.contains('text')) {
    return true;
  }
  return path.contains('/text/');
}

bool _isButtonStyleType(String typeSource) {
  return typeSource == 'ButtonStyle' || typeSource == 'ButtonStyle?';
}

bool _isInputDecorationType(String typeSource) {
  return typeSource == 'InputDecoration' || typeSource == 'InputDecoration?';
}

bool _isFontWeightType(String typeSource) {
  return typeSource == 'FontWeight' || typeSource == 'FontWeight?';
}

bool _isFontStyleType(String typeSource) {
  return typeSource == 'FontStyle' || typeSource == 'FontStyle?';
}

String _typeSourceOf(TypeAnnotation? type) {
  if (type == null) {
    return '';
  }
  return type.toSource().trim();
}
