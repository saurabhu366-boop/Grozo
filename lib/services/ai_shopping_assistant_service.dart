// lib/services/ai_shopping_assistant_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
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
      "quick_actions": ["Give me a recipe with chicken", "Is this healthy?", "Any offers?"],
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

    // Recipe Intent
    if (message.contains('recipe') || message.contains('cook') || message.contains('make with') || message.contains('ingredients')) {
      return await _generateRealRecipe(userMessage);
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
          "• Recipe Generation (e.g., 'What can I cook with tomatoes?')\n"
          "• Health & Nutrition\n"
          "• Deals & Offers\n"
          "• Item Recommendations",
      "quick_actions": ["Give me a recipe with eggs", "Is this healthy?", "Any offers?"],
      "highlight_type": "general"
    };
  }

  Future<Map<String, dynamic>> _generateRealRecipe(String prompt) async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
    if (apiKey.isEmpty) {
      // Return mock matching the screenshot perfectly if no API key is provided
      return {
        "response_type": "recipe_card",
        "time": "15 minutes (plus 60-90 minutes cooking time)",
        "title": "Classic Roasted Herb Chicken",
        "description": "A simple yet flavorful whole roasted chicken, seasoned with aromatic herbs and garlic, resulting in a juicy interior and crispy skin. Perfect for a family meal or Sunday dinner.",
        "ingredients": [
          "1 whole chicken (3-4 lbs)",
          "2 tbsp olive oil",
          "1 tsp dried rosemary",
          "1 tsp dried thyme",
          "1/2 tsp garlic powder",
          "1/2 tsp onion powder",
          "Salt and freshly ground black pepper to taste",
          "1 lemon, halved",
          "4-5 sprigs fresh rosemary (optional, for cavity)"
        ],
        "steps": [
          "Preheat oven to 425°F (220°C).",
          "Remove giblets from chicken cavity. Pat dry with paper towels.",
          "Rub chicken all over with olive oil.",
          "In a small bowl, mix rosemary, thyme, garlic powder, onion powder, salt, and pepper. Rub mixture over chicken.",
          "Stuff the cavity of the chicken with the halved lemon, fresh rosemary sprigs, and smashed garlic cloves (if using). This adds extra moisture and flavor.",
          "Tie the chicken legs together with kitchen twine, if desired, to help it cook more evenly.",
          "Roast for 60-90 minutes, or until a meat thermometer inserted into the thickest part of the thigh (without touching bone) reads 165°F (74°C). If the skin starts to brown too quickly, you can loosely tent it with aluminum foil.",
          "Once cooked, remove the chicken from the oven and let it rest for 10-15 minutes before carving. This allows the juices to redistribute, ensuring a tender and moist chicken.",
          "Carve the chicken and serve immediately with your favorite side dishes."
        ]
      };
    }

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final fullPrompt = """
      You are an AI Meal Planner. The user says: "$prompt".
      Generate a recipe based on this.
      Return ONLY a valid JSON object with the following structure, no markdown formatting outside the JSON:
      {
        "response_type": "recipe_card",
        "time": "e.g., 15 minutes prep, 30 mins cook",
        "title": "Recipe Name",
        "description": "Short description",
        "ingredients": ["ingredient 1", "ingredient 2"],
        "steps": ["step 1", "step 2"]
      }
      """;
      final response = await model.generateContent([Content.text(fullPrompt)]);
      final text = response.text ?? "{}";
      // Clean up potential markdown code blocks
      final cleanText = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final jsonMap = jsonDecode(cleanText);
      jsonMap['response_type'] = 'recipe_card';
      return jsonMap;
    } catch (e) {
      return {
        "ui_message": "Sorry, I couldn't generate a recipe right now. Please try again.",
        "highlight_type": "general"
      };
    }
  }
}