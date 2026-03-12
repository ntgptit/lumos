import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/route_names.dart';
import '../../presentation/features/auth/screens/auth_screen.dart';
import '../../presentation/features/auth/screens/launch_screen.dart';
import '../../presentation/features/flashcard/screens/flashcard_screen.dart';
import '../../presentation/features/home/screens/home_screen.dart';
import '../../presentation/features/study/screens/study_session_screen.dart';

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
    initialLocation: AppRoutePath.launch,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePath.launch,
        name: AppRouteName.launch,
        builder: (BuildContext context, GoRouterState state) {
          return const LaunchScreen();
        },
      ),
      GoRoute(
        path: AppRoutePath.auth,
        name: AppRouteName.auth,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthScreen();
        },
      ),
      GoRoute(
        path: AppRoutePath.home,
        name: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutePath.flashcard,
        name: AppRouteName.flashcard,
        builder: (BuildContext context, GoRouterState state) {
          final int deckId = _resolveDeckId(state);
          final String deckName = _resolveDeckName(state);
          return FlashcardScreen(deckId: deckId, deckName: deckName);
        },
      ),
      GoRoute(
        path: AppRoutePath.studySession,
        name: AppRouteName.studySession,
        builder: (BuildContext context, GoRouterState state) {
          final int deckId = _resolveDeckId(state);
          final String deckName = _resolveDeckName(state);
          return StudySessionScreen(
            deckId: deckId,
            deckName: deckName,
          );
        },
      ),
    ],
  );
}

int _resolveDeckId(GoRouterState state) {
  final String? rawDeckId = state.pathParameters[AppRouteParam.deckId];
  final int? parsedDeckId = int.tryParse(rawDeckId ?? '');
  if (parsedDeckId == null) {
    return 0;
  }
  return parsedDeckId;
}

String _resolveDeckName(GoRouterState state) {
  return state.uri.queryParameters[AppRouteQuery.deckName] ?? '';
}
