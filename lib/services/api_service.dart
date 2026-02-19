import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For Android Emulator: use 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:8087/api';

  // Example: Get all products
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
