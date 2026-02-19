// lib/services/ai_shopping_assistant_service.dart
import 'dart:math';
import 'package:shopzy/services/reward_service.dart';

class AiShoppingAssistantService {
  final RewardService _rewardService = RewardService();

  Future<Map<String, dynamic>> getWelcomeMessage() async {
    final greetings = [
      "Hello! I'm your AI shopping assistant. How can I help you shop smarter today? 🧠",
      "Welcome! Ready to find the best deals and nutritional info? Just ask!",
      "Hi there! Your smart shopping journey starts here. What are you looking for?"
    ];

    return {
      "ui_message": greetings[Random().nextInt(greetings.length)],
      "quick_actions": ["Is this healthy?", "Any offers?", "What goes with this?"],
      "highlight_type": "general"
    };
  }

  Future<Map<String, dynamic>> getResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(500)));

    final message = userMessage.toLowerCase();
    final points = _rewardService.totalPoints.value;
    final pointsNeeded = 200 - points;

    // --- Intent Detection & Response Generation ---

    // Reward-based Nudge (High Priority)
    if (points < 200 && pointsNeeded <= 50) {
      return {
        "ui_message": "Heads up! You’re only **$pointsNeeded points** away from a ₹50 discount.\n\n"
            "🛒 **Smart Suggestion**\n"
            "• Organic Almonds (earns bonus points!)",
        "quick_actions": ["Find healthy snacks", "How do I earn points?"],
        "highlight_type": "offer"
      };
    }

    // Health Intent
    if (message.contains('healthy') || message.contains('nutrition')) {
      return {
        "ui_message": "Good question! This is a solid choice.\n\n"
            "🥗 **Nutrition Snapshot**\n"
            "• **High Fiber:** Great for digestion.\n"
            "• **Low Sugar:** A healthier daily option.\n\n"
            "💡 For even more protein, consider Multigrain Bread.",
        "quick_actions": ["Compare with Multigrain", "Add to cart"],
        "highlight_type": "health"
      };
    }

    // Offer Intent - Now returns a structured card
    if (message.contains('offer') || message.contains('deal') || message.contains('save')) {
      return {
        "response_type": "deal_card",
        "ui_message": "You bet! Here's a smart deal for you.",
        "deal_title": "Today's Top Deal",
        "deal_description": "Buy any 2 bakery items and get **10% off** instantly.",
        "bonus_info": "This combo also earns you **double reward points**! ⭐",
        "quick_actions": ["Browse Bakery", "Any other offers?"],
      };
    }

    // Recommendation Intent
    if (message.contains('related') || message.contains('goes with') || message.contains('pair')) {
      return {
        "ui_message": "Of course! Here’s what shoppers often buy with this.\n\n"
            "🛒 **Popular Pairings**\n"
            "• **Butter 🧈:** A classic choice.\n"
            "• **Strawberry Jam 🍓:** For a sweet treat.",
        "quick_actions": ["Add butter", "Add jam", "Any healthy spreads?"],
        "highlight_type": "recommendation"
      };
    }

    // Default / General Help
    return {
      "ui_message": "I can help with that! What would you like to know?\n\n"
          "You can ask me about:\n"
          "• Health & Nutrition\n"
          "• Deals & Offers\n"
          "• Item Recommendations",
      "quick_actions": ["Is this healthy?", "Any offers?", "What goes with this?"],
      "highlight_type": "general"
    };
  }
}