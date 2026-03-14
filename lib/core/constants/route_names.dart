abstract final class AppRoutePath {
  AppRoutePath._();

  static const String launch = '/launch';
  static const String auth = '/auth';
  static const String home = '/';
  static const String flashcard = '/flashcards/:deckId';
  static const String studySession = '/flashcards/:deckId/study';
}

abstract final class AppRouteName {
  AppRouteName._();

  static const String launch = 'launch';
  static const String auth = 'auth';
  static const String home = 'home';
  static const String flashcard = 'flashcard';
  static const String studySession = 'studySession';
}

abstract final class AppRouteParam {
  AppRouteParam._();

  static const String deckId = 'deckId';
}

abstract final class AppRouteQuery {
  AppRouteQuery._();

  static const String deckName = 'deckName';
  static const String sessionId = 'sessionId';
}
