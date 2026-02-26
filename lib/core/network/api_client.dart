import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../constants/api_endpoints.dart';

part 'api_client.g.dart';

/// REST client contract for Lumos backend APIs.
@RestApi()
abstract class ApiClient {
  /// Creates an [ApiClient] instance backed by Dio.
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /// Health check endpoint.
  @GET(ApiEndpoints.health)
  Future<Map<String, dynamic>> getHealth();

  /// Example POST endpoint.
  @POST(ApiEndpoints.echo)
  Future<Map<String, dynamic>> postEcho({
    @Body() required Map<String, dynamic> payload,
  });
}
