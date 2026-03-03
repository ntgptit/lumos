abstract final class AppRoutePath {
  AppRoutePath._();

  static const String home = '/';
  static const String flashcard = '/flashcards/:deckId';
  static const String flashcardStudy = '/flashcards/:deckId/study';
}

abstract final class AppRouteName {
  AppRouteName._();

  static const String home = 'home';
  static const String flashcard = 'flashcard';
  static const String flashcardStudy = 'flashcardStudy';
}

abstract final class AppRouteParam {
  AppRouteParam._();

  static const String deckId = 'deckId';
}

abstract final class AppRouteQuery {
  AppRouteQuery._();

  static const String deckName = 'deckName';
}
