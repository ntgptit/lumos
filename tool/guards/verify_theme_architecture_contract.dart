import 'dart:io';

class ThemeArchitectureGuardConst {
  const ThemeArchitectureGuardConst._();

  static const String themesRoot = 'lib/core/themes';
  static const String themeRoot = 'lib/core/theme';
  static const String extension = '.dart';
  static const String generatedExtension = '.g.dart';
  static const String freezedExtension = '.freezed.dart';
  static const String tokenRoot = 'lib/core/theme/tokens';
  static const String responsiveBreakpointsFile =
      'lib/core/theme/responsive/breakpoints.dart';
  static const List<String> forwardedConstGuardFiles = <String>[
    'lib/core/theme/responsive/breakpoints.dart',
    'lib/core/themes/foundation/app_layout_tokens.dart',
    'lib/core/themes/foundation/app_material3_tokens.dart',
    'lib/core/themes/foundation/app_motion_tokens.dart',
  ];

  static const List<String> requiredDirectories = <String>[
    'lib/core/themes/foundation',
    'lib/core/themes/semantic',
    'lib/core/themes/component',
    'lib/core/themes/builders',
    'lib/core/themes/extensions',
  ];

  static const List<String> requiredFiles = <String>[
    'lib/core/themes/foundation/app_palette.dart',
    'lib/core/themes/foundation/app_spacing.dart',
    'lib/core/themes/foundation/app_radius.dart',
    'lib/core/themes/foundation/app_opacity.dart',
    'lib/core/themes/foundation/app_stroke.dart',
    'lib/core/themes/foundation/app_motion.dart',
    'lib/core/themes/semantic/app_color_tokens.dart',
    'lib/core/themes/semantic/app_text_tokens.dart',
    'lib/core/themes/semantic/app_elevation_tokens.dart',
    'lib/core/themes/component/app_button_tokens.dart',
    'lib/core/themes/component/app_input_tokens.dart',
    'lib/core/themes/component/app_card_tokens.dart',
    'lib/core/themes/component/app_dialog_tokens.dart',
    'lib/core/themes/component/app_navigation_bar_tokens.dart',
    'lib/core/themes/builders/app_color_scheme_builder.dart',
    'lib/core/themes/builders/app_text_theme_builder.dart',
    'lib/core/themes/builders/app_component_theme_builder.dart',
    'lib/core/themes/builders/app_theme_extensions_builder.dart',
    'lib/core/themes/extensions/build_context_theme_x.dart',
    'lib/core/themes/app_light_theme.dart',
    'lib/core/themes/app_dark_theme.dart',
    'lib/core/themes/app_theme.dart',
  ];

  static const List<String> forbiddenLegacyFiles = <String>[
    'lib/core/themes/extensions/semantic_colors_extension.dart',
  ];

  static const List<String> forbiddenLegacyDirectories = <String>[
    'lib/core/themes/component_themes',
    'lib/core/themes/constants',
    'lib/core/themes/providers',
  ];
}

class ThemeArchitectureViolation {
  const ThemeArchitectureViolation({
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

final Map<String, List<String>> _requiredFilePatterns = <String, List<String>>{
  'lib/core/themes/foundation/app_palette.dart': <String>[
    'abstract final class AppPalette',
  ],
  'lib/core/themes/foundation/app_spacing.dart': <String>[
    'abstract final class AppSpacing',
  ],
  'lib/core/themes/foundation/app_radius.dart': <String>[
    'abstract final class AppRadius',
  ],
  'lib/core/themes/foundation/app_opacity.dart': <String>[
    'abstract final class AppOpacity',
  ],
  'lib/core/themes/foundation/app_stroke.dart': <String>[
    'abstract final class AppStroke',
  ],
  'lib/core/themes/foundation/app_motion.dart': <String>[
    'abstract final class AppMotion',
  ],
  'lib/core/themes/semantic/app_color_tokens.dart': <String>[
    'class AppColorTokens extends ThemeExtension<AppColorTokens>',
  ],
  'lib/core/themes/semantic/app_text_tokens.dart': <String>[
    'class AppTextTokens extends ThemeExtension<AppTextTokens>',
  ],
  'lib/core/themes/semantic/app_elevation_tokens.dart': <String>[
    'abstract final class AppElevationTokens',
  ],
  'lib/core/themes/component/app_button_tokens.dart': <String>[
    'class AppButtonTokens extends ThemeExtension<AppButtonTokens>',
  ],
  'lib/core/themes/component/app_input_tokens.dart': <String>[
    'class AppInputTokens extends ThemeExtension<AppInputTokens>',
  ],
  'lib/core/themes/component/app_card_tokens.dart': <String>[
    'class AppCardTokens extends ThemeExtension<AppCardTokens>',
  ],
  'lib/core/themes/component/app_dialog_tokens.dart': <String>[
    'class AppDialogTokens extends ThemeExtension<AppDialogTokens>',
  ],
  'lib/core/themes/component/app_navigation_bar_tokens.dart': <String>[
    'class AppNavigationBarTokens extends ThemeExtension<AppNavigationBarTokens>',
  ],
  'lib/core/themes/extensions/build_context_theme_x.dart': <String>[
    'extension BuildContextThemeX on BuildContext',
    'AppColorTokens get appColors',
    'AppTextTokens get appText',
    'AppButtonTokens get appButton',
    'AppInputTokens get appInput',
    'AppCardTokens get appCard',
  ],
  'lib/core/themes/app_light_theme.dart': <String>[
    'final class AppLightTheme',
    'useMaterial3: true',
    'AppColorSchemeBuilder.light',
    'AppTextThemeBuilder.light',
    'AppThemeExtensionsBuilder.light',
    'AppComponentThemeBuilder.apply',
  ],
  'lib/core/themes/app_dark_theme.dart': <String>[
    'final class AppDarkTheme',
    'useMaterial3: true',
    'AppColorSchemeBuilder.dark',
    'AppTextThemeBuilder.dark',
    'AppThemeExtensionsBuilder.dark',
    'AppComponentThemeBuilder.apply',
  ],
  'lib/core/themes/app_theme.dart': <String>[
    'abstract final class AppTheme',
    'static ThemeData get light',
    'static ThemeData get dark',
    'AppLightTheme.build',
    'AppDarkTheme.build',
  ],
};

final RegExp _staticConstFieldNameRegExp = RegExp(
  r'static\s+const\s+[A-Za-z_<>,? ]+\s+([A-Za-z_]\w*)\s*=',
);
final RegExp _finalFieldNameRegExp = RegExp(
  r'final\s+[A-Za-z_<>,? ]+\s+([A-Za-z_]\w*)\s*;',
);
final RegExp _camelCaseFieldRegExp = RegExp(r'^[a-z][A-Za-z0-9]*$');
final RegExp _forwardedStaticConstRegExp = RegExp(
  r'^\s*static\s+const\s+[A-Za-z_<>,? ]+\s+[A-Za-z_]\w*\s*=\s*([A-Z][A-Za-z0-9_]*)\.[A-Za-z0-9_.]+\s*;',
);
const Set<String> _forwardedTokenSourcePrefixes = <String>{
  'App',
  'ColorTokens',
  'SpacingTokens',
  'RadiusTokens',
  'BorderTokens',
  'ElevationTokens',
  'TypographyTokens',
  'IconTokens',
  'SizeTokens',
  'IconSizes',
  'WidgetSizes',
  'Material3',
  'Breakpoints',
};

Future<void> main() async {
  final List<ThemeArchitectureViolation> violations =
      <ThemeArchitectureViolation>[];

  final Directory rootDirectory = Directory(
    ThemeArchitectureGuardConst.themesRoot,
  );
  if (!rootDirectory.existsSync()) {
    stderr.writeln('Missing `${ThemeArchitectureGuardConst.themesRoot}`.');
    exitCode = 1;
    return;
  }

  _appendMissingDirectoryViolations(violations: violations);
  _appendMissingFileViolations(violations: violations);
  _appendForbiddenLegacyFileViolations(violations: violations);
  _appendForbiddenLegacyDirectoryViolations(violations: violations);
  await _appendRequiredPatternViolations(violations: violations);
  await _appendTokenNamingViolations(violations: violations);
  await _appendForwardedTokenDeclarationViolations(violations: violations);

  if (violations.isEmpty) {
    stdout.writeln('Theme architecture contract guard passed.');
    return;
  }

  stderr.writeln('Theme architecture contract guard failed.');
  for (final ThemeArchitectureViolation violation in violations) {
    stderr.writeln(
      '${violation.filePath}:${violation.lineNumber}: '
      '${violation.reason} ${violation.lineContent}',
    );
  }
  exitCode = 1;
}

Future<void> _appendForwardedTokenDeclarationViolations({
  required List<ThemeArchitectureViolation> violations,
}) async {
  final Directory tokenDirectory = Directory(
    ThemeArchitectureGuardConst.tokenRoot,
  );
  final List<String> tokenFiles = <String>[];
  if (tokenDirectory.existsSync()) {
    tokenFiles.addAll(
      tokenDirectory
          .listSync(recursive: true)
          .whereType<File>()
          .map((File file) => file.path.replaceAll('\\', '/'))
          .where(
            (String path) =>
                path.endsWith(ThemeArchitectureGuardConst.extension),
          )
          .where(
            (String path) =>
                !path.endsWith(
                  ThemeArchitectureGuardConst.generatedExtension,
                ) &&
                !path.endsWith(ThemeArchitectureGuardConst.freezedExtension),
          ),
    );
  }
  final Set<String> targetFiles = <String>{
    ...tokenFiles,
    ...ThemeArchitectureGuardConst.forwardedConstGuardFiles,
  };
  final List<String> sortedTargetFiles = targetFiles.toList()..sort();

  for (final String filePath in sortedTargetFiles) {
    final File file = File(filePath);
    if (!file.existsSync()) {
      continue;
    }
    final List<String> lines = await file.readAsLines();
    for (int index = 0; index < lines.length; index++) {
      final String line = lines[index];
      if (!_isForwardedTokenDeclaration(line)) {
        continue;
      }
      violations.add(
        ThemeArchitectureViolation(
          filePath: filePath,
          lineNumber: index + 1,
          reason:
              'Theme token wrappers must not forward constants from another type. Use canonical declaration or export/typedef.',
          lineContent: line.trim(),
        ),
      );
    }
  }
}

bool _isForwardedTokenDeclaration(String line) {
  final RegExpMatch? match = _forwardedStaticConstRegExp.firstMatch(line);
  if (match == null) {
    return false;
  }
  final String sourceType = match.group(1) ?? '';
  for (final String prefix in _forwardedTokenSourcePrefixes) {
    if (sourceType.startsWith(prefix)) {
      return true;
    }
  }
  return false;
}

void _appendMissingDirectoryViolations({
  required List<ThemeArchitectureViolation> violations,
}) {
  for (final String path in ThemeArchitectureGuardConst.requiredDirectories) {
    final Directory directory = Directory(path);
    if (directory.existsSync()) {
      continue;
    }
    violations.add(
      ThemeArchitectureViolation(
        filePath: path,
        lineNumber: 1,
        reason: 'Missing required theme directory.',
        lineContent: path,
      ),
    );
  }
}

void _appendMissingFileViolations({
  required List<ThemeArchitectureViolation> violations,
}) {
  for (final String path in ThemeArchitectureGuardConst.requiredFiles) {
    final File file = File(path);
    if (file.existsSync()) {
      continue;
    }
    violations.add(
      ThemeArchitectureViolation(
        filePath: path,
        lineNumber: 1,
        reason: 'Missing required theme file.',
        lineContent: path,
      ),
    );
  }
}

void _appendForbiddenLegacyFileViolations({
  required List<ThemeArchitectureViolation> violations,
}) {
  for (final String path in ThemeArchitectureGuardConst.forbiddenLegacyFiles) {
    final File file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    violations.add(
      ThemeArchitectureViolation(
        filePath: path,
        lineNumber: 1,
        reason:
            'Legacy theme file is not allowed after architecture migration.',
        lineContent: path,
      ),
    );
  }
}

void _appendForbiddenLegacyDirectoryViolations({
  required List<ThemeArchitectureViolation> violations,
}) {
  for (final String legacyPath
      in ThemeArchitectureGuardConst.forbiddenLegacyDirectories) {
    final Directory legacyDirectory = Directory(legacyPath);
    if (!legacyDirectory.existsSync()) {
      continue;
    }
    final List<FileSystemEntity> legacyFiles = legacyDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .toList();
    if (legacyFiles.isEmpty) {
      continue;
    }
    violations.add(
      ThemeArchitectureViolation(
        filePath: legacyPath,
        lineNumber: 1,
        reason: 'Legacy theme directory is not allowed.',
        lineContent: legacyPath,
      ),
    );
  }
}

Future<void> _appendRequiredPatternViolations({
  required List<ThemeArchitectureViolation> violations,
}) async {
  for (final MapEntry<String, List<String>> entry
      in _requiredFilePatterns.entries) {
    final String filePath = entry.key;
    final File file = File(filePath);
    if (!file.existsSync()) {
      continue;
    }

    final List<String> lines = await file.readAsLines();
    for (final String pattern in entry.value) {
      final int lineNumber = _findLineNumber(lines: lines, pattern: pattern);
      if (lineNumber > 0) {
        continue;
      }
      violations.add(
        ThemeArchitectureViolation(
          filePath: filePath,
          lineNumber: 1,
          reason: 'Missing required theme pattern.',
          lineContent: pattern,
        ),
      );
    }
  }
}

Future<void> _appendTokenNamingViolations({
  required List<ThemeArchitectureViolation> violations,
}) async {
  await _appendRequiredStaticConstNameViolations(
    filePath: 'lib/core/themes/foundation/app_spacing.dart',
    requiredNames: <String>{
      'none',
      'xxs',
      'xs',
      'sm',
      'md',
      'lg',
      'xl',
      'xxl',
      'xxxl',
    },
    violations: violations,
    typeLabel: 'AppSpacing',
  );

  await _appendRequiredStaticConstNameViolations(
    filePath: 'lib/core/themes/foundation/app_radius.dart',
    requiredNames: <String>{'xs', 'sm', 'md', 'lg', 'xl', 'pill'},
    violations: violations,
    typeLabel: 'AppRadius',
  );

  await _appendRequiredFinalFieldNameViolations(
    filePath: 'lib/core/themes/semantic/app_color_tokens.dart',
    requiredNames: <String>{
      'success',
      'onSuccess',
      'successContainer',
      'onSuccessContainer',
      'warning',
      'onWarning',
      'warningContainer',
      'onWarningContainer',
      'info',
      'onInfo',
      'infoContainer',
      'onInfoContainer',
    },
    violations: violations,
    typeLabel: 'AppColorTokens',
  );

  await _appendRequiredFinalFieldNameViolations(
    filePath: 'lib/core/themes/semantic/app_text_tokens.dart',
    requiredNames: <String>{
      'bodyMediumStrong',
      'bodySmallMuted',
      'labelMediumLink',
    },
    violations: violations,
    typeLabel: 'AppTextTokens',
  );

  await _appendRequiredFinalFieldNameViolations(
    filePath: 'lib/core/themes/component/app_button_tokens.dart',
    requiredNames: <String>{
      'heightSm',
      'heightMd',
      'heightLg',
      'paddingSm',
      'paddingMd',
      'paddingLg',
      'radiusSm',
      'radiusMd',
      'radiusLg',
    },
    violations: violations,
    typeLabel: 'AppButtonTokens',
  );

  await _appendRequiredFinalFieldNameViolations(
    filePath: 'lib/core/themes/component/app_input_tokens.dart',
    requiredNames: <String>{
      'minHeight',
      'contentPadding',
      'borderRadius',
      'borderWidth',
      'focusedBorderWidth',
      'iconSize',
    },
    violations: violations,
    typeLabel: 'AppInputTokens',
  );

  await _appendRequiredFinalFieldNameViolations(
    filePath: 'lib/core/themes/component/app_card_tokens.dart',
    requiredNames: <String>{
      'paddingSm',
      'paddingMd',
      'paddingLg',
      'radius',
      'borderWidth',
    },
    violations: violations,
    typeLabel: 'AppCardTokens',
  );
}

Future<void> _appendRequiredStaticConstNameViolations({
  required String filePath,
  required Set<String> requiredNames,
  required List<ThemeArchitectureViolation> violations,
  required String typeLabel,
}) async {
  final File file = File(filePath);
  if (!file.existsSync()) {
    return;
  }
  final String source = await file.readAsString();
  final Set<String> names = _extractFieldNames(
    source: source,
    fieldRegExp: _staticConstFieldNameRegExp,
  );
  final Set<String> missing = requiredNames.difference(names);
  if (missing.isNotEmpty) {
    violations.add(
      ThemeArchitectureViolation(
        filePath: filePath,
        lineNumber: 1,
        reason: 'Missing required naming tokens for $typeLabel.',
        lineContent: missing.join(', '),
      ),
    );
  }
  _appendInvalidNamingViolations(
    names: names,
    filePath: filePath,
    violations: violations,
    typeLabel: typeLabel,
  );
}

Future<void> _appendRequiredFinalFieldNameViolations({
  required String filePath,
  required Set<String> requiredNames,
  required List<ThemeArchitectureViolation> violations,
  required String typeLabel,
}) async {
  final File file = File(filePath);
  if (!file.existsSync()) {
    return;
  }
  final String source = await file.readAsString();
  final Set<String> names = _extractFieldNames(
    source: source,
    fieldRegExp: _finalFieldNameRegExp,
  );
  final Set<String> missing = requiredNames.difference(names);
  if (missing.isNotEmpty) {
    violations.add(
      ThemeArchitectureViolation(
        filePath: filePath,
        lineNumber: 1,
        reason: 'Missing required naming tokens for $typeLabel.',
        lineContent: missing.join(', '),
      ),
    );
  }
  _appendInvalidNamingViolations(
    names: names,
    filePath: filePath,
    violations: violations,
    typeLabel: typeLabel,
  );
}

void _appendInvalidNamingViolations({
  required Set<String> names,
  required String filePath,
  required List<ThemeArchitectureViolation> violations,
  required String typeLabel,
}) {
  final List<String> invalidNames =
      names
          .where((String name) => !_camelCaseFieldRegExp.hasMatch(name))
          .toList()
        ..sort();
  if (invalidNames.isEmpty) {
    return;
  }
  violations.add(
    ThemeArchitectureViolation(
      filePath: filePath,
      lineNumber: 1,
      reason: 'Token naming must be camelCase in $typeLabel.',
      lineContent: invalidNames.join(', '),
    ),
  );
}

Set<String> _extractFieldNames({
  required String source,
  required RegExp fieldRegExp,
}) {
  final Set<String> names = <String>{};
  for (final RegExpMatch match in fieldRegExp.allMatches(source)) {
    final String? fieldName = match.group(1);
    if (fieldName == null) {
      continue;
    }
    names.add(fieldName);
  }
  return names;
}

int _findLineNumber({required List<String> lines, required String pattern}) {
  for (int index = 0; index < lines.length; index++) {
    if (!lines[index].contains(pattern)) {
      continue;
    }
    return index + 1;
  }
  return -1;
}
