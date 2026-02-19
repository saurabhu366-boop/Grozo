// lib/models/grocery_item.dart
class GroceryItem {
  final String barcode;
  final String name;
  final String category;
  final double price;
  final int calories;
  final double protein;
  final double carbs;
  final double? sugar;
  final double? fat;
  final bool isHealthy;
  final String healthHint;
  final String imagePath;
  final int aisle;

  const GroceryItem({
    required this.barcode,
    required this.name,
    required this.category,
    required this.price,
    required this.calories,
    required this.protein,
    required this.carbs,
    this.sugar,
    this.fat,
    this.isHealthy = false,
    required this.healthHint,
    required this.imagePath,
    required this.aisle,
  });
}