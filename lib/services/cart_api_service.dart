import '../models/cart_response.dart';
import '../models/checkout_response.dart';
import 'api_client.dart';
import 'api_config.dart';

class CartService {
  final ApiClient _apiClient;

  CartService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Scan product → add to cart
  /// ✅ REMOVED: userId param — backend extracts it from JWT
  Future<CartResponse> scanProduct(
      String barcode, {
        int quantity = 1,
      }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.scanEndpoint,
        body: {
          "barcode": barcode,
          "quantity": quantity,
          // ✅ NO userId here
        },
      );
      return CartResponse.fromJson(response);
    } catch (e) {
      throw Exception("Scan failed: $e");
    }
  }

  /// Get active cart
  /// ✅ REMOVED: userId param + was /api/cart/$userId → caused 404 with emails
  Future<CartResponse> getActiveCart() async {
    try {
      final response = await _apiClient.get(ApiConfig.cartEndpoint);
      return CartResponse.fromJson(response);
    } catch (e) {
      throw Exception("Fetch cart failed: $e");
    }
  }

  /// Remove product from cart
  /// ✅ REMOVED: userId from body — backend extracts it from JWT
  Future<CartResponse> removeProduct(
      String barcode, {
        int quantity = 1,
      }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.removeEndpoint,
        body: {
          "barcode": barcode,
          "quantity": quantity,
          // ✅ NO userId here
        },
      );
      return CartResponse.fromJson(response);
    } catch (e) {
      throw Exception("Remove product failed: $e");
    }
  }

  /// Checkout cart
  /// ✅ REMOVED: userId param + was /api/cart/$userId/checkout → caused 404
  /// ✅ RENAMED: checkoutCart → checkout (matches CartScreen call)
  Future<CheckoutResponse> checkout() async {
    try {
      final response = await _apiClient.post(ApiConfig.checkoutEndpoint);
      return CheckoutResponse.fromJson(response);  // ✅ parse and return
    } catch (e) {
      throw Exception("Checkout failed: $e");
    }
  }

  void dispose() {
    _apiClient.dispose();
  }
}