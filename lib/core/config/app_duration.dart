abstract final class AppDuration {
  static const instant = Duration.zero;
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const long = Duration(milliseconds: 400);
  static const themeChange = Duration(milliseconds: 250);
  static const routeTransition = Duration(milliseconds: 280);
  static const splashMinimum = Duration(milliseconds: 800);
  static const snackbar = Duration(seconds: 3);
  static const requestTimeout = Duration(seconds: 30);
}
