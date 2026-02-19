// lib/services/ai_recommendation_service.dart
import 'package:shopzy/data/mock_database.dart';
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/models/recommendation.dart';

class AiRecommendationService {
  Recommendation getRecommendations(GroceryItem scannedItem, List<GroceryItem> cartItems) {
    List<GroceryItem> complementary = [];
    UpgradeSuggestion? upgrade;
    String? offer;
    List<String> nutritionTips = [];
    String? rewardNudge;

    final cartBarcodes = cartItems.map((item) => item.barcode).toSet();

    // --- Rule-based Logic ---

    // 1. Complementary Items (Cart-Aware)
    if (scannedItem.barcode == '9876543210987') { // Whole Wheat Bread
      if (!cartBarcodes.contains('6543210987654')) { // If Avocado not in cart
        final avocado = MockDatabase.findByBarcode('6543210987654');
        if (avocado != null) complementary.add(avocado);
      }
    }

    // 2. Upgrade Suggestion
    if (scannedItem.barcode == '4567890123456') { // Standard Yogurt
      final greekYogurt = MockDatabase.findByBarcode('4567890123457');
      if (greekYogurt != null) {
        upgrade = UpgradeSuggestion(
          alternativeItem: greekYogurt,
          reason: 'A healthier option with more protein and less sugar.',
        );
      }
    }

    // 3. Dynamic Offer Intelligence
    bool hasBread = cartBarcodes.contains('9876543210987') || scannedItem.barcode == '9876543210987';
    bool hasAvocado = cartBarcodes.contains('6543210987654') || scannedItem.barcode == '6543210987654';

    if (hasBread && hasAvocado) {
      offer = 'You\'ve unlocked a combo deal! Get 15% off Fresh Orange Juice.';
    } else if (complementary.isNotEmpty) {
      offer = 'Buy ${scannedItem.name} & ${complementary.first.name} to unlock a combo discount!';
    } else {
      offer = 'Buy 2 of this item and get the 3rd one 50% off.';
    }

    // 4. Upgraded Nutrition Insights
    if (scannedItem.healthHint == 'High Protein') {
      nutritionTips.add('High protein choice! Great for muscle support and keeping you full. 💪');
    }
    if (scannedItem.healthHint == 'High Fiber') {
      nutritionTips.add('Good source of energy! The high fiber content aids digestion.');
    }
    if (scannedItem.calories > 200) {
      nutritionTips.add('Energy-rich! Perfect for a pre-workout boost.');
    }

    // 5. Reward & Gamification Layer
    if (upgrade != null) {
      rewardNudge = 'Smart pick! Choosing a healthier alternative earns you +10 bonus points. ✨';
    } else if (scannedItem.name.contains("Organic")) {
      rewardNudge = 'Earn an extra 5 points for choosing an organic product!';
    }


    return Recommendation(
      complementaryItems: complementary,
      upgradeSuggestion: upgrade,
      offer: offer,
      nutritionTips: nutritionTips,
      rewardNudge: rewardNudge,
    );
  }
}
