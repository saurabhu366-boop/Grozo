import '../models/cart_response.dart';
import '../models/scan_request.dart';
import 'api_client.dart';
import 'api_config.dart';

class CartService {
  final ApiClient _apiClient;

  CartService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Scan product → add to cart
  Future<CartResponse> scanProduct(
      String barcode,
      String userId, {
        int quantity = 1,
      }) async {
    try {
      final scanRequest = ScanRequest(
        barcode: barcode,
        userId: userId,
        quantity: quantity,
      );

      final response = await _apiClient.post(
        ApiConfig.scanEndpoint,
        body: scanRequest.toJson(),
      );

      return CartResponse.fromJson(response);
    } catch (e) {
      throw Exception("Scan failed: $e");
    }
  }

  /// Get active cart
  Future<CartResponse> getActiveCart(String userId) async {
    try {
      final response =
      await _apiClient.get('${ApiConfig.cartEndpoint}/$userId');

      return CartResponse.fromJson(response);
    } catch (e) {
      throw Exception("Fetch cart failed: $e");
    }
  }

  /// Remove product from cart
  Future<CartResponse> removeProduct(
      String barcode,
      String userId, {
        int quantity = 1,
      }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.cartEndpoint}/remove',
        body: {
          "barcode": barcode,
          "userId": userId,
          "quantity": quantity,
        },
      );


      return CartResponse.fromJson(response);
    } catch (e) {
      throw Exception("Remove product failed: $e");
    }
  }

  /// Checkout cart
  Future<void> checkoutCart(String userId) async {
    try {
      await _apiClient.post(
        '${ApiConfig.cartEndpoint}/$userId/checkout',
      );
    } catch (e) {
      throw Exception("Checkout failed: $e");
    }
  }

  void dispose() {
    _apiClient.dispose();
  }
}
