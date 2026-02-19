import 'Cart_item.dart';
import 'Cart_status.dart';


class Cart {
  final int? id;
  final String userId;
  final CartStatus status;
  final List<CartItem> items;

  Cart({
    this.id,
    required this.userId,
    required this.status,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      status: CartStatus.fromString(json['status']),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}