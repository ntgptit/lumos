abstract final class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:8080';
  static const String apiVersion = '/v1';
  static const String health = '$apiVersion/health';
  static const String echo = '$apiVersion/echo';
}
