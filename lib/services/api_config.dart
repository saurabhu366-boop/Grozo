import 'package:shopzy/utils/Token_storage.dart';

class ApiConfig {

  // 👈 add this
  static const String baseUrl = "http://172.16.255.93:8087";

  static const String scanEndpoint         = '/api/cart/scan';
  static const String cartEndpoint         = '/api/cart';
  static const String checkoutEndpoint     = '/api/cart/checkout';
  static const String removeEndpoint       = '/api/cart/remove';
  static const String loginEndpoint        = '/api/auth/login';
  static const String registerEndpoint     = '/api/auth/register';
  static const String orderHistoryEndpoint = '/api/orders/history';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout    = Duration(seconds: 30);

  static Map<String, String> get baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

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

  static Map<String, String> get publicHeaders => Map.from(baseHeaders);
}