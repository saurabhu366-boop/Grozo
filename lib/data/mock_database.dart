
import 'package:shopzy/models/grocery_item.dart';

class MockDatabase {
  static final Map<String, GroceryItem> items = {
    '8901234567890': const GroceryItem(
        barcode: '8901058851298',
        name: 'Maggiee',
        category: 'Snacks',
        price: 15,
        calories: 160,
        protein: 6.0,
        carbs: 6.0,
        fat: 14.0,
        sugar: 1.0,
        isHealthy: false,
        healthHint: 'High Protein',
        imagePath: '"C:\Users\saurabh\Downloads\Maggi Masala 2-Minute Noodles India Snack - 24 Pack.jpg"',
        aisle: 4),
    '1234567890128': const GroceryItem(
        barcode: '1234567890128',
        name: 'Fresh Orange Juice',
        category: 'Beverages',
        price: 120.0,
        calories: 110,
        protein: 2.0,
        carbs: 26.0,
        sugar: 22.0,
        fat: 0.0,
        isHealthy: false,
        healthHint: 'Source of Vitamin C',
        imagePath: 'https://img.freepik.com/premium-photo/fresh-orange-juice_926199-33457.jpg',
        aisle: 1),
    '9876543210987': const GroceryItem(
        barcode: '9876543210987',
        name: 'Whole Wheat Bread',
        category: 'Bakery',
        price: 45.0,
        calories: 80,
        protein: 4.0,
        carbs: 14.0,
        sugar: 2.0,
        fat: 1.0,
        isHealthy: true,
        healthHint: 'High Fiber',
        imagePath: 'https://i.pinimg.com/originals/29/60/fa/2960fa1299981d3bd231e07fceb1d583.jpg',
        aisle: 3),
    '4567890123456': const GroceryItem(
        barcode: '4567890123456',
        name: 'Standard Yogurt',
        category: 'Dairy',
        price: 30.0,
        calories: 150,
        protein: 8.0,
        carbs: 17.0,
        sugar: 16.0,
        fat: 5.0,
        isHealthy: false,
        healthHint: 'Good for Gut Health',
        imagePath: 'https://nenaswellnesscorner.com/wp-content/uploads/2023/07/Strawberry_yogurt-4.jpeg',
        aisle: 1),
    '4567890123457': const GroceryItem(
        barcode: '4567890123457',
        name: 'Greek Yogurt',
        category: 'Dairy',
        price: 55.0,
        calories: 100,
        protein: 18.0,
        carbs: 6.0,
        sugar: 5.0,
        fat: 2.0,
        isHealthy: true,
        healthHint: 'Excellent Protein Source',
        imagePath: 'https://images.pexels.com/photos/5623668/pexels-photo-5623668.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        aisle: 1),
    '6543210987654': const GroceryItem(
        barcode: '6543210987654',
        name: 'Italian Avocado',
        category: 'Produce',
        price: 149.0,
        calories: 234,
        protein: 3.0,
        carbs: 12.0,
        sugar: 1.0,
        fat: 22.0,
        isHealthy: true,
        healthHint: 'Healthy Fats',
        imagePath: 'https://images.pexels.com/photos/557659/pexels-photo-557659.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        aisle: 2),
    '8901719101038': const GroceryItem(
        barcode: '8901719101038',
        name: 'Parle-G',
        category: 'Snacks',
        price: 10.0,
        calories: 250,
        protein: 3.7,
        carbs: 53.8,
        sugar: 14.9,
        fat: 6.9,
        isHealthy: false,
        healthHint: 'A classic tea-time snack',
        imagePath: 'https://images.pexels.com/photos/7936339/pexels-photo-7936339.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        aisle: 4),
    '8901058901511': const GroceryItem(
        barcode: '8901058901511',
        name: 'Beetroot (Local)',
        category: 'Produce',
        price: 40.0,
        calories: 43,
        protein: 1.6,
        carbs: 10.0,
        sugar: 6.8,
        fat: 0.2,
        isHealthy: true,
        healthHint: 'Good for Blood Pressure',
        imagePath: 'https://images.pexels.com/photos/1435907/pexels-photo-1435907.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        aisle: 2),
    '1112223334445': const GroceryItem(
        barcode: '1112223334445',
        name: 'Beef Mixed Cut Bone',
        category: 'Meat',
        price: 350.0,
        calories: 250,
        protein: 26,
        carbs: 0,
        sugar: 0,
        fat: 15,
        isHealthy: true,
        healthHint: 'Excellent Source of Iron',
        imagePath: 'https://images.pexels.com/photos/6517333/pexels-photo-6517333.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        aisle: 5),
  };

  static GroceryItem? findByBarcode(String barcode) {
    return items[barcode];
  }

  static List<GroceryItem> searchItems(String query) {
    if (query.isEmpty) {
      return [];
    }
    final lowerCaseQuery = query.toLowerCase();
    return items.values.where((item) {
      return item.name.toLowerCase().contains(lowerCaseQuery) ||
          item.category.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  static void removeByBarcode(String barcode) {
    items.remove(barcode);
  }
}
