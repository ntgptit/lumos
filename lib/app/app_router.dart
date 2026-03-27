import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/features/auth/providers/auth_session_provider.dart';
import '../presentation/features/auth/screens/auth_screen.dart';
import '../presentation/features/auth/screens/launch_screen.dart';
import '../presentation/features/flashcard/screens/flashcard_screen.dart';
import '../presentation/features/home/screens/home_screen.dart';
import '../presentation/features/study/screens/study_session_screen.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final AsyncValue<AuthViewState> authAsync = ref.watch(
    authSessionControllerProvider,
  );
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutePath.launch,
    redirect: (BuildContext context, GoRouterState state) {
      final String matchedLocation = state.matchedLocation;
      final bool isLaunchRoute = matchedLocation == AppRoutePath.launch;
      final bool isAuthRoute = matchedLocation == AppRoutePath.auth;
      if (authAsync.isLoading) {
        if (isLaunchRoute) {
          return null;
        }
        return AppRoutePath.launch;
      }
      if (authAsync.hasError) {
        if (isAuthRoute) {
          return null;
        }
        return AppRoutePath.auth;
      }
      final bool isAuthenticated =
          authAsync.asData?.value.isAuthenticated ?? false;
      if (!isAuthenticated) {
        if (isAuthRoute) {
          return null;
        }
        return AppRoutePath.auth;
      }
      if (isLaunchRoute) {
        return AppRoutePath.home;
      }
      if (isAuthRoute) {
        return AppRoutePath.home;
      }
      return null;
    },
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
          final int? sessionId = _resolveSessionId(state);
          return StudySessionScreen(
            deckId: deckId,
            deckName: deckName,
            sessionId: sessionId,
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

int? _resolveSessionId(GoRouterState state) {
  final String? rawSessionId =
      state.uri.queryParameters[AppRouteQuery.sessionId];
  return int.tryParse(rawSessionId ?? '');
}
