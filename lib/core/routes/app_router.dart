import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/route_names.dart';
import '../../presentation/features/home/screens/home_screen.dart';
import '../../presentation/features/flashcard/screens/flashcard_flip_study_screen.dart';
import '../../presentation/features/flashcard/screens/flashcard_screen.dart';

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
        path: AppRoutePath.flashcardStudy,
        name: AppRouteName.flashcardStudy,
        builder: (BuildContext context, GoRouterState state) {
          final int deckId = _resolveDeckId(state);
          final String deckName = _resolveDeckName(state);
          final FlashcardFlipStudyRouteExtra extra = _resolveStudyExtra(state);
          return FlashcardFlipStudyScreen(
            deckId: deckId,
            deckName: deckName,
            items: extra.items,
            initialIndex: extra.initialIndex,
            initialStarredFlashcardIds: extra.starredFlashcardIds,
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

FlashcardFlipStudyRouteExtra _resolveStudyExtra(GoRouterState state) {
  final Object? extra = state.extra;
  if (extra is FlashcardFlipStudyRouteExtra) {
    return extra;
  }
  return const FlashcardFlipStudyRouteExtra.fallback();
}
