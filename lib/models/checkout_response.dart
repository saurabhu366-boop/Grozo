// lib/models/checkout_response.dart

import 'cart_response.dart'; // reuses CartItemResponse

class CheckoutResponse {
  final int cartId;
  final List<CartItemResponse> items;
  final double totalAmount;
  final String status;
  final String message;

  CheckoutResponse({
    required this.cartId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.message,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      cartId: json['cartId'],
      items: (json['items'] as List)
          .map((e) => CartItemResponse.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
      message: json['message'],
    );
  }
}