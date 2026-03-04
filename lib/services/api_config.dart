import 'package:shopzy/utils/Token_storage.dart';

class ApiConfig {
  static const String baseUrl = "http://192.168.0.104:8087";

  // ✅ All endpoints defined in one place — no hardcoding elsewhere
  static const String scanEndpoint     = '/api/cart/scan';
  static const String cartEndpoint     = '/api/cart';
  static const String checkoutEndpoint = '/api/cart/checkout';
  static const String removeEndpoint   = '/api/cart/remove';
  static const String loginEndpoint    = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout    = Duration(seconds: 30);

  static Map<String, String> get baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ✅ Auth headers — throws if token is missing so failures are obvious
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found. User must log in first.');
    }
    return {
      ...baseHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  // ✅ Public headers — for login/register only (no auth needed)
  static Map<String, String> get publicHeaders => Map.from(baseHeaders);
}