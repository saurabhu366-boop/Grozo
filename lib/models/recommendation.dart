// lib/models/recommendation.dart
import 'package:shopzy/models/grocery_item.dart';

class Recommendation {
  final List<GroceryItem> complementaryItems;
  final UpgradeSuggestion? upgradeSuggestion;
  final String? offer;
  final List<String> nutritionTips;
  final String? rewardNudge;

  Recommendation({
    this.complementaryItems = const [],
    this.upgradeSuggestion,
    this.offer,
    this.nutritionTips = const [],
    this.rewardNudge,
  });
}

class UpgradeSuggestion {
  final GroceryItem alternativeItem;
  final String reason;

  UpgradeSuggestion({required this.alternativeItem, required this.reason});
}
