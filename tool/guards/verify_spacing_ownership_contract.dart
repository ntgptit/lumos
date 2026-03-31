import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

class SpacingOwnershipGuardConst {
  const SpacingOwnershipGuardConst._();

  static const String libDirectory = 'lib';
  static const String dartExtension = '.dart';
  static const String generatedExtension = '.g.dart';
  static const String freezedExtension = '.freezed.dart';

  static const String featurePrefix = 'lib/presentation/features/';
  static const String featureScreensMarker = '/screens/';
  static const String featureWidgetsMarker = '/widgets/';
  static const String sharedWidgetsPrefix = 'lib/presentation/shared/widgets/';
  static const String coreWidgetsPrefix = 'lib/core/widgets/';

  static const String allowLineMarker = 'spacing-ownership-guard: allow-line';
  static const String allowFileMarker = 'spacing-ownership-guard: allow-file';
  static const Set<String> forbiddenLumosSpacingStatics = <String>{
    'none',
    'md',
    'lg',
    'xl',
    'xxl',
    'xxxl',
    'section',
    'page',
    'canvas',
  };
  static const String childArgumentName = 'child';
  static const String paddingArgumentName = 'padding';
  static const String marginArgumentName = 'margin';
  static const String paddingWidgetName = 'Padding';
  static const String containerWidgetName = 'Container';
  static const String buildMethodName = 'build';

  static const Set<String> widgetSuperTypes = <String>{
    'StatelessWidget',
    'StatefulWidget',
    'ConsumerWidget',
    'ConsumerStatefulWidget',
    'HookWidget',
    'HookConsumerWidget',
  };

  static const Set<String> allowedRootSpacingOwnerKeywords = <String>{
    'screen',
    'section',
    'header',
    'footer',
    'content',
    'layout',
    'shell',
    'frame',
    'builder',
    'dialog',
    'sheet',
    'scaffold',
    'body',
    'navigation',
    'carousel',
    'list',
    'grid',
    'pager',
    'viewport',
  };
  static const Set<String> transparentSingleChildWrappers = <String>{
    'Align',
    'Center',
    'SafeArea',
    'Expanded',
    'Flexible',
    'ClipRRect',
    'ClipRect',
    'ClipOval',
    'ClipPath',
    'DecoratedBox',
    'ColoredBox',
    'ConstrainedBox',
    'SizedBox',
    'LimitedBox',
    'FractionallySizedBox',
    'AspectRatio',
    'IntrinsicHeight',
    'IntrinsicWidth',
    'FittedBox',
    'Opacity',
    'AnimatedOpacity',
    'IgnorePointer',
    'AbsorbPointer',
    'Visibility',
    'Offstage',
    'Semantics',
    'GestureDetector',
    'InkWell',
    'InkResponse',
    'Material',
    'Theme',
    'IconTheme',
    'DefaultTextStyle',
    'Directionality',
    'MediaQuery',
    'Scrollbar',
    'SingleChildScrollView',
    'SliverToBoxAdapter',
    'AnimatedSwitcher',
    'AnimatedContainer',
    'Tooltip',
    'MouseRegion',
  };
}

class SpacingOwnershipViolation {
  const SpacingOwnershipViolation({
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

class _SpacingWrapperSpec {
  const _SpacingWrapperSpec({
    required this.label,
    required this.ownsPadding,
    required this.ownsMargin,
  });

  final String label;
  final bool ownsPadding;
  final bool ownsMargin;
}

Future<void> main() async {
  final Directory root = Directory(SpacingOwnershipGuardConst.libDirectory);
  if (!root.existsSync()) {
    stderr.writeln(
      'Missing `${SpacingOwnershipGuardConst.libDirectory}` directory.',
    );
    exitCode = 1;
    return;
  }

  final List<File> sourceFiles = _collectSourceFiles(root);
  final List<SpacingOwnershipViolation> violations =
      <SpacingOwnershipViolation>[];

  for (final File sourceFile in sourceFiles) {
    final String path = _normalizePath(sourceFile.path);
    if (!_isUiLayerFile(path)) {
      continue;
    }

    final String sourceText = await sourceFile.readAsString();
    if (sourceText.contains(SpacingOwnershipGuardConst.allowFileMarker)) {
      continue;
    }

    final parsed = parseString(
      content: sourceText,
      path: path,
      throwIfDiagnostics: false,
    );
    final List<String> lines = sourceText.split('\n');
    final _SpacingOwnershipVisitor visitor = _SpacingOwnershipVisitor(
      path: path,
      lines: lines,
      lineInfo: parsed.lineInfo,
      violations: violations,
    );
    parsed.unit.accept(visitor);
  }

  if (violations.isEmpty) {
    stdout.writeln('Spacing ownership contract passed.');
    return;
  }

  stderr.writeln('Spacing ownership contract failed.');
  for (final SpacingOwnershipViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

class _SpacingOwnershipVisitor extends RecursiveAstVisitor<void> {
  _SpacingOwnershipVisitor({
    required this.path,
    required this.lines,
    required this.lineInfo,
    required this.violations,
  });

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
  final List<SpacingOwnershipViolation> violations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    if (!_isWidgetClass(node)) {
      return;
    }

    final String className = node.name.lexeme;
    if (_isAllowedRootSpacingOwner(className: className, path: path)) {
      return;
    }

    for (final ClassMember member in node.members) {
      if (member is! MethodDeclaration) {
        continue;
      }
      if (member.name.lexeme != SpacingOwnershipGuardConst.buildMethodName) {
        continue;
      }
      if (_isIgnored(member) || _isIgnored(node)) {
        continue;
      }

      final List<Expression> returnedExpressions =
          _collectBuildReturnExpressions(member.body);
      for (final Expression returnedExpression in returnedExpressions) {
        if (_isIgnored(returnedExpression)) {
          continue;
        }

        final _SpacingWrapperSpec? rootSpec = _resolveRootBuildSpacingWrapper(
          returnedExpression,
        );
        if (rootSpec == null) {
          continue;
        }

        final int lineNumber = lineInfo
            .getLocation(returnedExpression.offset)
            .lineNumber;
        violations.add(
          SpacingOwnershipViolation(
            filePath: path,
            lineNumber: lineNumber,
            reason:
                'Root spacing wrapper detected in widget build '
                '(${rootSpec.label}). '
                'This widget is acting as an outer inset owner. Move spacing to '
                'the parent section/screen, or group this widget under a '
                'header/content/footer layout owner.',
            lineContent: _lineAt(lineNumber),
          ),
        );
      }
    }
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (_isIgnored(node)) {
      return;
    }

    final _SpacingWrapperSpec? parentSpec = _resolveSpacingWrapper(node);
    if (parentSpec == null) {
      return;
    }

    final Expression? childExpression = _childExpression(node);
    if (childExpression == null) {
      return;
    }

    final InstanceCreationExpression? childWidget = _unwrapWidgetCreation(
      childExpression,
    );
    if (childWidget == null) {
      return;
    }

    if (_isIgnored(childWidget)) {
      return;
    }

    final _SpacingWrapperSpec? childSpec = _resolveSpacingWrapper(childWidget);
    if (childSpec == null) {
      return;
    }

    if (!_isForbiddenNestedSpacing(parentSpec, childSpec)) {
      return;
    }

    final int lineNumber = lineInfo.getLocation(node.offset).lineNumber;
    final String lineContent = _lineAt(lineNumber);
    violations.add(
      SpacingOwnershipViolation(
        filePath: path,
        lineNumber: lineNumber,
        reason:
            'Nested spacing ownership detected '
            '(${parentSpec.label} -> ${childSpec.label}). '
            'Move outer inset to the screen/section wrapper and keep inner content '
            'padding inside the component only.',
        lineContent: lineContent,
      ),
    );
  }

  bool _isIgnored(AstNode node) {
    final int startLine = lineInfo.getLocation(node.offset).lineNumber;
    final int endOffset = node.endToken.end;
    final int endLine = lineInfo.getLocation(endOffset).lineNumber;
    for (int index = startLine; index <= endLine; index++) {
      final String line = _lineAt(index);
      if (line.contains(SpacingOwnershipGuardConst.allowLineMarker)) {
        return true;
      }
    }
    return false;
  }

  String _lineAt(int lineNumber) {
    if (lineNumber <= 0 || lineNumber > lines.length) {
      return '';
    }
    return lines[lineNumber - 1].trim();
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    super.visitPrefixedIdentifier(node);

    if (!path.startsWith(SpacingOwnershipGuardConst.featurePrefix)) {
      return;
    }
    if (node.prefix.name != 'LumosSpacing') {
      return;
    }
    if (!SpacingOwnershipGuardConst.forbiddenLumosSpacingStatics.contains(
      node.identifier.name,
    )) {
      return;
    }
    if (_isIgnored(node)) {
      return;
    }

    final int lineNumber = lineInfo.getLocation(node.offset).lineNumber;
    violations.add(
      SpacingOwnershipViolation(
        filePath: path,
        lineNumber: lineNumber,
        reason:
            'Dùng context.spacing.${node.identifier.name} thay vì LumosSpacing.${node.identifier.name} static const trong feature layer.',
        lineContent: _lineAt(lineNumber),
      ),
    );
  }
}

List<File> _collectSourceFiles(Directory root) {
  final List<File> files = <File>[];

  for (final FileSystemEntity entity in root.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }

    final String path = _normalizePath(entity.path);
    if (!path.endsWith(SpacingOwnershipGuardConst.dartExtension)) {
      continue;
    }
    if (path.endsWith(SpacingOwnershipGuardConst.generatedExtension)) {
      continue;
    }
    if (path.endsWith(SpacingOwnershipGuardConst.freezedExtension)) {
      continue;
    }

    files.add(entity);
  }

  return files;
}

bool _isUiLayerFile(String path) {
  if (path.startsWith(SpacingOwnershipGuardConst.sharedWidgetsPrefix)) {
    return true;
  }
  if (path.startsWith(SpacingOwnershipGuardConst.coreWidgetsPrefix)) {
    return true;
  }
  if (!path.startsWith(SpacingOwnershipGuardConst.featurePrefix)) {
    return false;
  }
  if (path.contains(SpacingOwnershipGuardConst.featureScreensMarker)) {
    return true;
  }
  if (path.contains(SpacingOwnershipGuardConst.featureWidgetsMarker)) {
    return true;
  }
  return false;
}

_SpacingWrapperSpec? _resolveSpacingWrapper(InstanceCreationExpression node) {
  final String widgetName = _widgetName(node);
  if (widgetName == SpacingOwnershipGuardConst.paddingWidgetName) {
    return const _SpacingWrapperSpec(
      label: 'Padding',
      ownsPadding: true,
      ownsMargin: false,
    );
  }

  if (widgetName != SpacingOwnershipGuardConst.containerWidgetName) {
    return null;
  }

  final bool ownsPadding = _hasNamedArgument(
    node,
    SpacingOwnershipGuardConst.paddingArgumentName,
  );
  final bool ownsMargin = _hasNamedArgument(
    node,
    SpacingOwnershipGuardConst.marginArgumentName,
  );
  if (!ownsPadding && !ownsMargin) {
    return null;
  }

  final List<String> ownership = <String>[];
  if (ownsPadding) {
    ownership.add('padding');
  }
  if (ownsMargin) {
    ownership.add('margin');
  }
  return _SpacingWrapperSpec(
    label: 'Container(${ownership.join(' + ')})',
    ownsPadding: ownsPadding,
    ownsMargin: ownsMargin,
  );
}

bool _isForbiddenNestedSpacing(
  _SpacingWrapperSpec parent,
  _SpacingWrapperSpec child,
) {
  if (parent.label == 'Padding' && child.label == 'Padding') {
    return true;
  }

  if (parent.label == 'Padding' && (child.ownsPadding || child.ownsMargin)) {
    return true;
  }

  if ((parent.ownsPadding || parent.ownsMargin) && child.label == 'Padding') {
    return true;
  }

  return false;
}

bool _isWidgetClass(ClassDeclaration node) {
  final ExtendsClause? extendsClause = node.extendsClause;
  if (extendsClause == null) {
    return false;
  }

  final String superType = extendsClause.superclass.toSource().split('.').last;
  return SpacingOwnershipGuardConst.widgetSuperTypes.contains(superType);
}

bool _isAllowedRootSpacingOwner({
  required String className,
  required String path,
}) {
  final String normalizedClassName = className.toLowerCase();
  final String fileName = _fileNameWithoutExtension(path).toLowerCase();

  for (final String keyword
      in SpacingOwnershipGuardConst.allowedRootSpacingOwnerKeywords) {
    if (normalizedClassName.contains(keyword)) {
      return true;
    }
    if (fileName.contains(keyword)) {
      return true;
    }
  }

  return false;
}

List<Expression> _collectBuildReturnExpressions(FunctionBody body) {
  if (body is ExpressionFunctionBody) {
    return <Expression>[body.expression];
  }

  if (body is! BlockFunctionBody) {
    return const <Expression>[];
  }

  final _BuildReturnExpressionVisitor visitor = _BuildReturnExpressionVisitor();
  body.block.accept(visitor);
  return visitor.expressions;
}

_SpacingWrapperSpec? _resolveRootBuildSpacingWrapper(Expression expression) {
  final InstanceCreationExpression? widgetCreation =
      _unwrapSingleChildWidgetChain(expression);
  if (widgetCreation == null) {
    return null;
  }

  final String widgetName = _widgetName(widgetCreation);
  if (widgetName == SpacingOwnershipGuardConst.paddingWidgetName) {
    return const _SpacingWrapperSpec(
      label: 'Padding',
      ownsPadding: true,
      ownsMargin: false,
    );
  }

  if (widgetName != SpacingOwnershipGuardConst.containerWidgetName) {
    return null;
  }

  final bool ownsMargin = _hasNamedArgument(
    widgetCreation,
    SpacingOwnershipGuardConst.marginArgumentName,
  );
  if (!ownsMargin) {
    return null;
  }

  return const _SpacingWrapperSpec(
    label: 'Container(margin)',
    ownsPadding: false,
    ownsMargin: true,
  );
}

InstanceCreationExpression? _unwrapSingleChildWidgetChain(
  Expression expression,
) {
  InstanceCreationExpression? current = _unwrapWidgetCreation(expression);
  while (current != null) {
    final _SpacingWrapperSpec? directSpacing = _resolveSpacingWrapper(current);
    if (directSpacing != null) {
      return current;
    }

    final String widgetName = _widgetName(current);
    if (!SpacingOwnershipGuardConst.transparentSingleChildWrappers.contains(
      widgetName,
    )) {
      return current;
    }

    final Expression? child = _childExpression(current);
    if (child == null) {
      return current;
    }
    current = _unwrapWidgetCreation(child);
  }
  return null;
}

bool _hasNamedArgument(InstanceCreationExpression node, String argumentName) {
  for (final Expression argument in node.argumentList.arguments) {
    if (argument is! NamedExpression) {
      continue;
    }
    if (argument.name.label.name != argumentName) {
      continue;
    }
    return true;
  }
  return false;
}

Expression? _childExpression(InstanceCreationExpression node) {
  for (final Expression argument in node.argumentList.arguments) {
    if (argument is! NamedExpression) {
      continue;
    }
    if (argument.name.label.name !=
        SpacingOwnershipGuardConst.childArgumentName) {
      continue;
    }
    return argument.expression;
  }
  return null;
}

InstanceCreationExpression? _unwrapWidgetCreation(Expression expression) {
  Expression current = expression;
  while (true) {
    if (current is ParenthesizedExpression) {
      current = current.expression;
      continue;
    }
    if (current is NamedExpression) {
      current = current.expression;
      continue;
    }
    if (current is AwaitExpression) {
      current = current.expression;
      continue;
    }
    if (current is ConditionalExpression) {
      return null;
    }
    if (current is InstanceCreationExpression) {
      return current;
    }
    return null;
  }
}

String _widgetName(InstanceCreationExpression node) {
  final String typeSource = node.constructorName.type.toSource();
  final List<String> parts = typeSource.split('.');
  return parts.isEmpty ? typeSource : parts.last;
}

String _normalizePath(String path) {
  return path.replaceAll('\\', '/');
}

String _fileNameWithoutExtension(String path) {
  final String fileName = path.split('/').last;
  final int extensionIndex = fileName.lastIndexOf('.');
  if (extensionIndex < 0) {
    return fileName;
  }
  return fileName.substring(0, extensionIndex);
}

class _BuildReturnExpressionVisitor extends RecursiveAstVisitor<void> {
  final List<Expression> expressions = <Expression>[];

  @override
  void visitFunctionExpression(FunctionExpression node) {}

  @override
  void visitMethodDeclaration(MethodDeclaration node) {}

  @override
  void visitReturnStatement(ReturnStatement node) {
    final Expression? expression = node.expression;
    if (expression == null) {
      return;
    }
    expressions.add(expression);
  }
}
