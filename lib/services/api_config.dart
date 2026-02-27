import 'package:shopzy/utils/Token_storage.dart';

class ApiConfig {
  // Android emulator -> Spring Boot on host machine (port 8087)
  static const String baseUrl = "http://192.168.0.104:8087";

  // Endpoints (all start with /api)
  static const String scanEndpoint = '/api/cart/scan';
  static const String cartEndpoint = '/api/cart';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Base headers without auth
  static Map<String, String> get baseHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Headers with optional auth token
  static Future<Map<String, String>> getHeaders({String? token}) async {
    final base = Map<String, String>.from(baseHeaders);
    if (token != null && token.isNotEmpty) {
      base['Authorization'] = 'Bearer $token';
    }
    return base;
  }

  // Headers using stored token
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await TokenStorage.getToken();
    return getHeaders(token: token);
  }
}
