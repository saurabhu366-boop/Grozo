// lib/services/order_service.dart

import 'api_client.dart';
import 'api_config.dart';
import '../models/order_history_response.dart';

class OrderService {
  final ApiClient _apiClient;

  OrderService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<OrderHistoryResponse>> getOrderHistory() async {
    try {
      final response = await _apiClient.get(ApiConfig.orderHistoryEndpoint);
      return (response as List)
          .map((e) => OrderHistoryResponse.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load order history: $e");
    }
  }

  void dispose() => _apiClient.dispose();
}