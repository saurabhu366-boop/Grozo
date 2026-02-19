class ApiConfig {

  // Android emulator -> Spring Boot on host machine (port 8087)
  static const String baseUrl = "http://192.168.0.104:8087";


  // Endpoints (all start with /api)
  static const String scanEndpoint = '/api/cart/scan';
  static const String cartEndpoint = '/api/cart';



  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get headers =>
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
