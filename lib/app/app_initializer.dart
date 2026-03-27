import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/utils/google_fonts_bootstrap.dart';

final class AppInitializer {
  AppInitializer._();

  static const String _defaultFlavor = 'dev';
  static const String _envPrefix = '.env.';
  static const String _fallbackEnvFile = '.env.dev';
  static const String _flavorDefineKey = 'FLAVOR';

  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Future.wait<void>(<Future<void>>[
      AppGoogleFontsBootstrap.ensureFontsReady(),
      _loadEnvironment(),
    ]);
  }

  static Future<void> _loadEnvironment() async {
    final String envFile = _resolveEnvFileByFlavor();
    try {
      await dotenv.load(fileName: envFile);
      return;
    } on Exception {
      if (envFile == _fallbackEnvFile) {
        return;
      }
    }

    try {
      await dotenv.load(fileName: _fallbackEnvFile);
    } on Exception {
      return;
    }
  }

  static String _resolveEnvFileByFlavor() {
    const String flavor = String.fromEnvironment(
      _flavorDefineKey,
      defaultValue: _defaultFlavor,
    );
    return '$_envPrefix$flavor';
  }
}
