import 'package:shopzy/models/Product.dart';
import 'package:shopzy/services/api_client.dart';

class ProductService {
  final ApiClient _apiClient;

  ProductService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  // REMOVE PRODUCT FROM CART (matches Spring Boot API)
  Future<void> removeProduct({
    required String barcode,
    required String userId,
    int quantity = 1,
  }) async {
    await _apiClient.delete(
      '/remove',
      body: {
        "barcode": barcode,
        "userId": userId,
        "quantity": quantity,
      },
    );
  }

  // GET PRODUCT BY BARCODE
  Future<Product?> getProductByBarcode(String barcode) async {
    final response = await _apiClient.get('/products?barcode=$barcode');

    if (response != null && response.isNotEmpty) {
      return Product.fromJson(response[0]);
    }
    return null;
  }
}
