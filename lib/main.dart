import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/localization/locale_provider.dart';
import 'core/themes/providers/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'presentation/routes/app_router.dart';

class AppBootstrapConst {
  const AppBootstrapConst._();

  static const String flavorDefineKey = 'FLAVOR';
  static const String defaultFlavor = 'dev';
  static const String envPrefix = '.env.';
  static const String fallbackEnvFile = '.env.dev';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await _loadEnvironment();
  runApp(const ProviderScope(child: AppEntryPoint()));
}

Future<void> _loadEnvironment() async {
  final String envFile = _resolveEnvFileByFlavor();
  try {
    await dotenv.load(fileName: envFile);
    return;
  } on Exception {
    if (envFile == AppBootstrapConst.fallbackEnvFile) {
      return;
    }
  }

  try {
    await dotenv.load(fileName: AppBootstrapConst.fallbackEnvFile);
  } on Exception {
    return;
  }
}

String _resolveEnvFileByFlavor() {
  const String flavor = String.fromEnvironment(
    AppBootstrapConst.flavorDefineKey,
    defaultValue: AppBootstrapConst.defaultFlavor,
  );
  return '${AppBootstrapConst.envPrefix}$flavor';
}

class AppEntryPoint extends ConsumerWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final lightTheme = ref.watch(appLightThemeProvider);
    final darkTheme = ref.watch(appDarkThemeProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) {
        return AppLocalizations.of(context)?.appTitle ?? 'Lumos';
      },
      builder: (BuildContext context, Widget? child) {
        final bool disableAnimations = MediaQuery.disableAnimationsOf(context);
        final TextScaler textScaler = MediaQuery.textScalerOf(context);
        if (child == null) {
          return const SizedBox.shrink();
        }
        final MediaQueryData mediaQueryData = MediaQuery.of(
          context,
        ).copyWith(textScaler: textScaler);
        return MediaQuery(
          data: mediaQueryData,
          child: TickerMode(enabled: !disableAnimations, child: child),
        );
      },
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: appLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: routerConfig,
    );
  }
}
