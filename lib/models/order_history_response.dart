// lib/models/order_history_response.dart

import 'cart_response.dart';

class OrderHistoryResponse {
  final int cartId;
  final DateTime createdAt;
  final List<CartItemResponse> items;
  final double totalAmount;
  final String status;

  OrderHistoryResponse({
    required this.cartId,
    required this.createdAt,
    required this.items,
    required this.totalAmount,
    required this.status,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      cartId: json['cartId'],
      // ✅ FIX: createdAt can be null for old cart rows created before column was added
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // fallback for old rows
      items: (json['items'] as List)
          .map((e) => CartItemResponse.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] ?? '',  // ✅ null safety
    );
  }
}