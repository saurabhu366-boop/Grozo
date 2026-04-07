import 'package:google_generative_ai/google_generative_ai.dart';

class AiShoppingAssistantService {
  // ⚠️ SECURITY: Never check this key into GitHub/GitLab.
  // Consider using 'flutter_dotenv' or '--dart-define' for production.
  final String _apiKey = "AIzaSyDHsqxakWqYJlQLsoP_qtwt6-cDFhTC7zs";

  late final GenerativeModel _model;

  AiShoppingAssistantService() {
    // We use 'gemini-1.5-flash' because it's faster and has higher
    // free-tier limits than 'gemini-1.5-pro'.
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  /// 🤖 Get AI response with detailed debugging
  Future<Map<String, dynamic>> getResponse(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return {"ui_message": response.text!};
      } else {
        return {"ui_message": "The AI returned an empty response."};
      }
    } on InvalidApiKey catch (e) {
      print("❌ KEY ERROR: The API key is invalid. Details: $e");
      return {"ui_message": "Invalid API Key. Please check your setup."};
    } on UnsupportedUserLocation catch (e) {
      print("❌ REGION ERROR: Gemini is not available in your current location/IP. Details: $e");
      return {"ui_message": "Gemini is not supported in your region."};
    } on ServerException catch (e) {
      // This catches 429 (Rate Limit), 500 (Server Error), and 503 (Overloaded)
      print("❌ SERVER ERROR: Google AI is having trouble. Details: $e");
      return {"ui_message": "Server Error: ${e.message}"};
    } catch (e) {
      // This catches network issues or unexpected formatting errors
      print("❌ UNKNOWN ERROR: $e");
      return {"ui_message": "Something went wrong. Check your console logs."};
    }
  }

  /// 👋 Welcome message
  Future<Map<String, dynamic>> getWelcomeMessage() async {
    return {
      "ui_message":
      "Hi! I'm your AI Shopping Assistant 🛒\nAsk me anything about food, health, or products!"
    };
  }
}