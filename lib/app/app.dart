import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/theme_provider.dart';
import '../core/theme/responsive/responsive_theme_factory.dart';
import '../l10n/app_localizations.dart';
import 'app_lifecycle_handler.dart';
import 'app_providers.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _AppView());
  }
}

class _AppView extends ConsumerStatefulWidget {
  const _AppView();

  @override
  ConsumerState<_AppView> createState() {
    return _AppViewState();
  }
}

class _AppViewState extends ConsumerState<_AppView> {
  @override
  void reassemble() {
    super.reassemble();
    if (!kDebugMode) {
      return;
    }
    ref.invalidate(appLightThemeProvider);
    ref.invalidate(appDarkThemeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final bool isInForeground = ref.watch(appIsInForegroundProvider);
    final routerConfig = ref.watch(appRouterConfigProvider);
    final themeMode = ref.watch(appThemeModeConfigProvider);
    final lightTheme = ref.watch(appLightThemeConfigProvider);
    final darkTheme = ref.watch(appDarkThemeConfigProvider);
    final appLocale = ref.watch(appLocaleConfigProvider);

    return AppLifecycleHandler(
      onStateChanged: _handleLifecycleStateChanged,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) {
          return AppLocalizations.of(context)?.appTitle ?? 'Lumos';
        },
        builder: (BuildContext context, Widget? child) {
          final bool disableAnimations = MediaQuery.disableAnimationsOf(
            context,
          );
          final TextScaler textScaler = MediaQuery.textScalerOf(context);
          if (child == null) {
            return const SizedBox.shrink();
          }
          final MediaQueryData mediaQueryData = MediaQuery.of(
            context,
          ).copyWith(textScaler: textScaler);
          final ThemeData adaptiveTheme = ResponsiveThemeFactory.adapt(
            theme: Theme.of(context),
            mediaQueryData: mediaQueryData,
          );
          return MediaQuery(
            data: mediaQueryData,
            child: Theme(
              data: adaptiveTheme,
              child: TickerMode(
                enabled: isInForeground && !disableAnimations,
                child: child,
              ),
            ),
          );
        },
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        locale: appLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: routerConfig,
      ),
    );
  }

  void _handleLifecycleStateChanged(AppLifecycleState lifecycleState) {
    ref
        .read(appLifecycleControllerProvider.notifier)
        .setLifecycleState(lifecycleState);
  }
}
