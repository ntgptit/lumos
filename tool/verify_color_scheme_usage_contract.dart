import 'dart:io';

class ColorSchemeUsageGuardCompatConst {
  const ColorSchemeUsageGuardCompatConst._();

  static const String componentThemeGuard =
      'tool/verify_component_theme_usage_contract.dart';
  static const String featureSurfaceGuard =
      'tool/verify_feature_surface_contract.dart';
}

Future<void> main() async {
  final List<String> guards = <String>[
    ColorSchemeUsageGuardCompatConst.componentThemeGuard,
    ColorSchemeUsageGuardCompatConst.featureSurfaceGuard,
  ];

  bool hasFailure = false;

  for (final String guard in guards) {
    final ProcessResult result = await Process.run('dart', <String>[
      'run',
      guard,
    ]);

    final String stdoutOutput = (result.stdout ?? '').toString().trim();
    final String stderrOutput = (result.stderr ?? '').toString().trim();

    if (stdoutOutput.isNotEmpty) {
      stdout.writeln(stdoutOutput);
    }
    if (stderrOutput.isNotEmpty) {
      stderr.writeln(stderrOutput);
    }

    if (result.exitCode == 0) {
      continue;
    }
    hasFailure = true;
  }

  if (hasFailure) {
    stderr.writeln(
      'Color scheme usage contract failed (delegated to component + feature guards).',
    );
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Color scheme usage contract passed (delegated to component + feature guards).',
  );
}
