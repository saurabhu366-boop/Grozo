// lib/services/cart_service.dart
import 'package:flutter/foundation.dart';
import 'package:shopzy/models/grocery_item.dart';

class CartService {
  // Singleton pattern to ensure a single instance of the cart throughout the app.
  static final CartService _instance = CartService._internal();
  factory CartService() {
    return _instance;
  }
  CartService._internal();

  final List<GroceryItem> _items = [];
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  /// Returns a copy of the items in the cart.
  List<GroceryItem> get items => List.from(_items);

  /// Adds an item to the cart and notifies listeners.
  void addItem(GroceryItem item) {
    _items.add(item);
    // In a real app, you would handle quantities of the same item.
    cartItemCount.value = _items.length;
  }

  /// Calculates the total price of all items in the cart.
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  /// Clears all items from the cart.
  void clearCart() {
    _items.clear();
    cartItemCount.value = 0;
  }
}
