import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductImageService {
  static final Map<String, String> _cache = {};

  static Future<String?> getImageUrl(String barcode) async {
    // Return from cache if already fetched
    if (_cache.containsKey(barcode)) return _cache[barcode];

    try {
      final response = await http.get(
        Uri.parse(
          'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
        ),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final product = data['product'];
        if (product != null) {
          // Try multiple image fields in order of preference
          final imageUrl =
              product['image_front_url'] ??
                  product['image_url'] ??
                  product['image_front_small_url'];

          if (imageUrl != null && imageUrl.toString().isNotEmpty) {
            _cache[barcode] = imageUrl.toString();
            return imageUrl.toString();
          }
        }
      }
    } catch (_) {}

    return null; // fallback to placeholder
  }
}