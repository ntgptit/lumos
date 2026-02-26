class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  static const String health = '$apiVersion/health';
  static const String echo = '$apiVersion/echo';
}
