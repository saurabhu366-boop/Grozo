// lib/models/chat_message.dart
enum ChatMessageType { user, ai, ai_typing }

class ChatMessage {
  final ChatMessageType type;
  final String text; // For user's message text or AI's formatted UI message
  final Map<String, dynamic>? aiResponse; // For structured AI response

  ChatMessage.user({required this.text})
      : type = ChatMessageType.user,
        aiResponse = null;

  ChatMessage.ai({required this.aiResponse})
      : type = ChatMessageType.ai,
        text = aiResponse?['ui_message'] as String? ?? 'Sorry, something went wrong.';

  const ChatMessage.typing()
      : type = ChatMessageType.ai_typing,
        text = '',
        aiResponse = null;
}
