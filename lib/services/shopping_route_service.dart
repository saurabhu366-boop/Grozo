// lib/services/shopping_route_service.dart
import 'package:shopzy/models/grocery_item.dart';

class ShoppingRouteService {
  /// Sorts a list of grocery items based on their aisle number to create
  /// an optimized shopping route.
  List<GroceryItem> getOptimalRoute(List<GroceryItem> items) {
    // Create a mutable copy of the list to sort
    final sortedItems = List<GroceryItem>.from(items);

    // Sort the list based on the aisle number
    sortedItems.sort((a, b) => a.aisle.compareTo(b.aisle));

    return sortedItems;
  }
}