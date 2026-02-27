import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/route_names.dart';
import '../../presentation/features/home/screens/home_screen.dart';

part 'app_router.g.dart';

/// Root navigator key used by [GoRouter] for top-level navigation.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Application router provider.
///
/// This provider is the single source of truth for route configuration.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutePath.home,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePath.home,
        name: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
