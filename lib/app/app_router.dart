import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/di/core_providers.dart';
import 'package:lumos/presentation/features/auth/providers/auth_provider.dart';
import 'package:lumos/presentation/shared/screens/lumos_not_found_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final envConfig = ref.watch(envConfigProvider);
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  final routerRefreshNotifier = ValueNotifier<int>(0);
  ref.onDispose(routerRefreshNotifier.dispose);
  ref.listen<AuthControllerState>(authControllerProvider, (_, _) {
    routerRefreshNotifier.value++;
  });

  final splashLocation = const SplashRouteData().location;
  final authLocation = const AuthRouteData().location;
  final loginLocation = const LoginRouteData().location;
  final registerLocation = const RegisterRouteData().location;
  final forgotPasswordLocation = const ForgotPasswordRouteData().location;
  final dashboardLocation = const DashboardRouteData().location;
  final offlineLocation = const OfflineRouteData().location;
  final maintenanceLocation = const MaintenanceRouteData().location;
  final notFoundLocation = const NotFoundRouteData().location;

  final router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: envConfig.enableRouterLogs,
    initialLocation: splashLocation,
    refreshListenable: routerRefreshNotifier,
    routes: $appRoutes,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.uri.path;
      final isCheckingSession = authState.isCheckingSession;
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute =
          location == authLocation ||
          location == loginLocation ||
          location == registerLocation ||
          location == forgotPasswordLocation;
      final isAlwaysPublicRoute =
          location == offlineLocation ||
          location == maintenanceLocation ||
          location == notFoundLocation;

      if (isCheckingSession) {
        if (location == splashLocation) {
          return null;
        }
        return splashLocation;
      }

      if (!isAuthenticated) {
        if (location == authLocation) {
          return loginLocation;
        }
        if (isAuthRoute || isAlwaysPublicRoute) {
          return null;
        }
        return loginLocation;
      }

      if (location == splashLocation || isAuthRoute) {
        return dashboardLocation;
      }

      return null;
    },
    errorBuilder: (context, state) => const LumosNotFoundScreen(),
  );

  ref.onDispose(router.dispose);
  return router;
}
