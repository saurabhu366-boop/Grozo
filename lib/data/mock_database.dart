import 'package:flutter/material.dart';
import 'package:shopzy/models/grocery_item.dart';

class MockDatabase {
  static final Map<String, GroceryItem> items = {

    // 1️⃣ Maggi Masala Noodles
    '8901058851298': const GroceryItem(
        barcode: '8901058851298',
        name: 'Maggi Masala Noodles',
        category: 'Snacks',
        price: 15.0,
        calories: 350,
        protein: 8.0,
        carbs: 52.0,
        fat: 11.0,
        sugar: 2.0,
        isHealthy: false,
        healthHint: 'High in Sodium',
        imagePath:  'assets/images/maggie.png',
        aisle: 4),

    // 2️⃣ Parle-G Biscuits
    '8901719134852': const GroceryItem(
        barcode: '8901719101038',
        name: 'Parle-G Biscuits',
        category: 'Snacks',
        price: 10.0,
        calories: 450,
        protein: 6.5,
        carbs: 70.0,
        fat: 14.0,
        sugar: 20.0,
        isHealthy: false,
        healthHint: 'Classic Tea-Time Snack',
        imagePath: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Parle-g-biscuits.jpg/320px-Parle-g-biscuits.jpg',
        aisle: 4),

    // 3️⃣ Amul Butter
    '8901030505827': const GroceryItem(
        barcode: '8901030505827',
        name: 'Amul Butter (100g)',
        category: 'Dairy',
        price: 55.0,
        calories: 720,
        protein: 0.5,
        carbs: 0.0,
        fat: 80.0,
        sugar: 0.0,
        isHealthy: false,
        healthHint: 'Use in Moderation',
        imagePath:  'assets/images/butter.png',
        aisle: 1),

    // 4️⃣ Britannia Good Day Cookies
    '8901063130016': const GroceryItem(
        barcode: '8901063130016',
        name: 'Britannia Good Day Cookies',
        category: 'Snacks',
        price: 30.0,
        calories: 503,
        protein: 7.0,
        carbs: 62.0,
        fat: 24.0,
        sugar: 18.0,
        isHealthy: false,
        healthHint: 'Occasional Treat',
        imagePath:  'assets/images/biscuit.png',
        aisle: 4),

    // 5️⃣ Lays Classic Salted
    '8901526101013': const GroceryItem(
        barcode: '8901526101013',
        name: "Lay's Classic Salted Chips",
        category: 'Snacks',
        price: 20.0,
        calories: 536,
        protein: 6.6,
        carbs: 55.0,
        fat: 31.0,
        sugar: 1.0,
        isHealthy: false,
        healthHint: 'High in Fat & Sodium',
        imagePath:  'assets/images/lays.jpg',
        aisle: 4),

    // 6️⃣ Haldiram's Aloo Bhujia
    '8906002310033': const GroceryItem(
        barcode: '8906002310033',
        name: "Haldiram's Aloo Bhujia",
        category: 'Snacks',
        price: 30.0,
        calories: 544,
        protein: 9.0,
        carbs: 55.0,
        fat: 32.0,
        sugar: 2.0,
        isHealthy: false,
        healthHint: 'Deep Fried — Limit Intake',
        imagePath:  'assets/images/aloo_bhujia.jpg.png',
        aisle: 4),

    // 7️⃣ Frooti Mango Drink
    '8901565000279': const GroceryItem(
        barcode: '8901565000279',
        name: 'Frooti Mango Drink (200ml)',
        category: 'Beverages',
        price: 20.0,
        calories: 110,
        protein: 0.0,
        carbs: 27.0,
        fat: 0.0,
        sugar: 25.0,
        isHealthy: false,
        healthHint: 'High Sugar Content',
        imagePath:  'assets/images/frooti.png',
        aisle: 6),

    // 8️⃣ Kurkure Masala Munch
    '8901491107719': const GroceryItem(
        barcode: '8901491107719',
        name: 'Kurkure Masala Munch',
        category: 'Snacks',
        price: 20.0,
        calories: 540,
        protein: 5.0,
        carbs: 58.0,
        fat: 30.0,
        sugar: 3.0,
        isHealthy: false,
        healthHint: 'High in Calories',
        imagePath:  'assets/images/kurkure.png',
        aisle: 4),





  };

  static GroceryItem? findByBarcode(String barcode) {
    return items[barcode];
  }

  static List<GroceryItem> searchItems(String query) {
    if (query.isEmpty) return [];
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